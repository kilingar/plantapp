"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import Link from "next/link";
import { useRouter } from "next/navigation";
import LoadingSpinner from "@/lib/components/LoadingSpinner";

type Home = Database["public"]["Tables"]["homes"]["Row"];
type Zone = Database["public"]["Tables"]["zones"]["Row"];
type Plant = Database["public"]["Tables"]["plants"]["Row"] & {
  zone?: Zone;
};
type DiaryEntry = Database["public"]["Tables"]["plant_diary_entries"]["Row"] & {
  plants?: Plant;
};

export default function DashboardPage() {
  const [homes, setHomes] = useState<Home[]>([]);
  const [selectedHome, setSelectedHome] = useState<Home | null>(null);
  const [zones, setZones] = useState<Zone[]>([]);
  const [plants, setPlants] = useState<Plant[]>([]);
  const [diaryEntries, setDiaryEntries] = useState<DiaryEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCreateHome, setShowCreateHome] = useState(false);
  const [newHomeName, setNewHomeName] = useState("");
  const [zonesExpanded, setZonesExpanded] = useState(true);
  const [plantsExpanded, setPlantsExpanded] = useState(true);
  const router = useRouter();

  useEffect(() => {
    loadHomes();
  }, []);

  useEffect(() => {
    if (selectedHome) {
      loadZones();
      loadPlants();
      loadDiaryEntries();
    }
  }, [selectedHome]);

  const loadHomes = async () => {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return;

    const { data, error } = await supabase
      .from("homes")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading homes:", error);
      // If it's a permissions error, user might not have profile yet
      // Show create home form anyway
      setShowCreateHome(true);
    } else if (data) {
      setHomes(data);
      if (data.length > 0) {
        setSelectedHome(data[0]);
      } else {
        setShowCreateHome(true);
      }
    }
    setLoading(false);
  };

  const loadZones = async () => {
    if (!selectedHome) return;

    const { data, error } = await supabase
      .from("zones")
      .select("*")
      .eq("home_id", selectedHome.id)
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading zones:", error);
    } else if (data) {
      setZones(data);
    }
  };

  const loadPlants = async () => {
    if (!selectedHome) return;

    // First get all zones for this home
    const { data: homeZones, error: zonesError } = await supabase
      .from("zones")
      .select("id")
      .eq("home_id", selectedHome.id);

    if (zonesError) {
      console.error("Error loading zones for plants:", zonesError);
      return;
    }

    if (!homeZones || homeZones.length === 0) {
      setPlants([]);
      return;
    }

    const zoneIds = homeZones.map(z => z.id);

    // Then get plants in those zones
    const { data, error } = await supabase
      .from("plants")
      .select(`
        *,
        zone:zones(*)
      `)
      .in("zone_id", zoneIds)
      .eq("status", "active")
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading plants:", error);
    } else if (data) {
      setPlants(data as Plant[]);
    }
  };

  const loadDiaryEntries = async () => {
    if (!selectedHome) return;

    // First get all zones for this home
    const { data: homeZones, error: zonesError } = await supabase
      .from("zones")
      .select("id")
      .eq("home_id", selectedHome.id);

    if (zonesError || !homeZones || homeZones.length === 0) {
      setDiaryEntries([]);
      return;
    }

    const zoneIds = homeZones.map(z => z.id);

    // Get plants in those zones
    const { data: homePlants, error: plantsError } = await supabase
      .from("plants")
      .select("id")
      .in("zone_id", zoneIds);

    if (plantsError || !homePlants || homePlants.length === 0) {
      setDiaryEntries([]);
      return;
    }

    const plantIds = homePlants.map(p => p.id);

    // Get diary entries for those plants
    const { data, error } = await supabase
      .from("plant_diary_entries")
      .select(`
        *,
        plants:plant_id (
          id,
          name,
          zone_id
        )
      `)
      .in("plant_id", plantIds)
      .order("created_at", { ascending: false })
      .limit(12);

    if (error) {
      console.error("Error loading diary entries:", error);
    } else if (data) {
      setDiaryEntries(data as any);
    }
  };

  const createHome = async (e: React.FormEvent) => {
    e.preventDefault();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return;

    const { data, error } = await supabase
      .from("homes")
      .insert([{ name: newHomeName, owner_id: user.id }])
      .select()
      .single();

    if (error) {
      console.error("Error creating home:", error);
      alert("Error creating home: " + error.message);
    } else if (data) {
      setHomes([data, ...homes]);
      setSelectedHome(data);
      setShowCreateHome(false);
      setNewHomeName("");
    }
  };

  const needsWatering = (plant: Plant) => {
    if (!plant.last_watered || !plant.watering_frequency_days) return false;
    const lastWatered = new Date(plant.last_watered);
    const nextWatering = new Date(lastWatered);
    nextWatering.setDate(nextWatering.getDate() + plant.watering_frequency_days);
    return nextWatering <= new Date();
  };

  // Calculate plants per zone for pie chart
  const getPlantsPerZone = () => {
    const zoneMap = new Map<string, { zone: Zone; count: number }>();
    
    plants.forEach((plant) => {
      if (plant.zone) {
        const existing = zoneMap.get(plant.zone.id);
        if (existing) {
          existing.count++;
        } else {
          zoneMap.set(plant.zone.id, { zone: plant.zone, count: 1 });
        }
      }
    });

    return Array.from(zoneMap.values());
  };

  const plantsPerZone = getPlantsPerZone();
  const totalPlants = plants.length;

  // Generate colors for pie chart
  const getZoneColor = (index: number) => {
    const colors = [
      "#10b981", // green-500
      "#3b82f6", // blue-500
      "#f59e0b", // amber-500
      "#ef4444", // red-500
      "#8b5cf6", // violet-500
      "#ec4899", // pink-500
      "#14b8a6", // teal-500
      "#f97316", // orange-500
    ];
    return colors[index % colors.length];
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <LoadingSpinner />
      </div>
    );
  }

  if (showCreateHome || homes.length === 0) {
    return (
      <div className="max-w-md mx-auto mt-8">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8">
          <h2 className="text-2xl font-bold text-green-800 dark:text-green-400 mb-4">
            Create Your Home
          </h2>
          <p className="text-gray-600 dark:text-gray-400 mb-6">
            Let's start by creating your home. You can add zones and plants afterwards.
          </p>
          <form onSubmit={createHome}>
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Home Name
              </label>
              <input
                type="text"
                value={newHomeName}
                onChange={(e) => setNewHomeName(e.target.value)}
                placeholder="e.g., Our Home, Apartment 5B"
                required
                className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
              />
            </div>
            <button
              type="submit"
              className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors"
            >
              Create Home
            </button>
          </form>
        </div>
      </div>
    );
  }

  const plantsNeedingWater = plants.filter(needsWatering);

  return (
    <div className="space-y-6">
      {/* Home Selector */}
      {homes.length > 1 && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-4">
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Select Home
          </label>
          <select
            value={selectedHome?.id || ""}
            onChange={(e) => {
              const home = homes.find((h) => h.id === e.target.value);
              setSelectedHome(home || null);
            }}
            className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
          >
            {homes.map((home) => (
              <option key={home.id} value={home.id}>
                {home.name}
              </option>
            ))}
          </select>
        </div>
      )}

      {/* Current Home Header */}
      {selectedHome && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
            {selectedHome.name}
          </h1>
          {selectedHome.description && (
            <p className="text-gray-600 dark:text-gray-400">
              {selectedHome.description}
            </p>
          )}
        </div>
      )}

      {/* Watering Alerts */}
      {plantsNeedingWater.length > 0 && (
        <div className="bg-yellow-50 dark:bg-yellow-900/20 border-l-4 border-yellow-400 p-4 rounded">
          <div className="flex items-start">
            <div className="flex-shrink-0">
              <svg
                className="h-5 w-5 text-yellow-400"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  fillRule="evenodd"
                  d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                  clipRule="evenodd"
                />
              </svg>
            </div>
            <div className="ml-3">
              <p className="text-sm text-yellow-700 dark:text-yellow-400">
                {plantsNeedingWater.length} plant{plantsNeedingWater.length !== 1 ? "s" : ""} need{plantsNeedingWater.length === 1 ? "s" : ""} watering!
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Quick Stats */}
      <div className="grid grid-cols-2 gap-4">
        <Link 
          href="/dashboard/zones"
          className="bg-white dark:bg-gray-800 rounded-lg shadow p-4 hover:shadow-lg transition-shadow cursor-pointer"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Zones</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {zones.length}
              </p>
            </div>
            <div className="text-3xl">📍</div>
          </div>
        </Link>

        <Link 
          href="/dashboard/plants"
          className="bg-white dark:bg-gray-800 rounded-lg shadow p-4 hover:shadow-lg transition-shadow cursor-pointer"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Plants</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {plants.length}
              </p>
            </div>
            <div className="text-3xl">🌿</div>
          </div>
        </Link>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 gap-4">
        <Link
          href="/dashboard/zones/new"
          className="bg-green-600 hover:bg-green-700 text-white font-semibold py-4 px-6 rounded-lg text-center transition-colors"
        >
          + Add Zone
        </Link>
        <Link
          href="/dashboard/plants/new"
          className="bg-green-600 hover:bg-green-700 text-white font-semibold py-4 px-6 rounded-lg text-center transition-colors"
        >
          + Add Plant
        </Link>
      </div>

      {/* Home Management */}
      <div className="grid grid-cols-2 gap-4">
        <Link
          href="/dashboard/members"
          className="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-6 rounded-lg text-center transition-colors flex items-center justify-center gap-2"
        >
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
          </svg>
          Members
        </Link>
        <button
          onClick={() => setShowCreateHome(true)}
          className="bg-purple-600 hover:bg-purple-700 text-white font-semibold py-3 px-6 rounded-lg text-center transition-colors flex items-center justify-center gap-2"
        >
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
          </svg>
          New Home
        </button>
      </div>

      {/* Create Home Modal */}
      {showCreateHome && homes.length > 0 && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 max-w-md w-full">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-bold text-gray-900 dark:text-white">
                Create New Home
              </h2>
              <button
                onClick={() => {
                  setShowCreateHome(false);
                  setNewHomeName("");
                }}
                className="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
              >
                ✕
              </button>
            </div>
            <form onSubmit={createHome} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Home Name
                </label>
                <input
                  type="text"
                  value={newHomeName}
                  onChange={(e) => setNewHomeName(e.target.value)}
                  placeholder="e.g., Vacation Home, Office"
                  required
                  className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
                />
              </div>
              <div className="flex gap-2">
                <button
                  type="submit"
                  className="flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
                >
                  Create
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setShowCreateHome(false);
                    setNewHomeName("");
                  }}
                  className="flex-1 bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-semibold py-2 px-4 rounded-lg transition-colors"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Plants Per Zone Pie Chart */}
      {plantsPerZone.length > 0 && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-4">
            Plants Distribution by Zone
          </h2>
          <div className="flex flex-col md:flex-row gap-6">
            {/* SVG Pie Chart */}
            <div className="w-full md:w-1/2 flex justify-center">
              <div className="relative w-64 h-64">
              <svg viewBox="0 0 100 100" className="transform -rotate-90">
                {plantsPerZone.map((item, index) => {
                  const percentage = (item.count / totalPlants) * 100;
                  const angle = (percentage / 100) * 360;
                  
                  // Calculate the starting position for this slice
                  let startAngle = 0;
                  for (let i = 0; i < index; i++) {
                    const prevPercentage = (plantsPerZone[i].count / totalPlants) * 100;
                    startAngle += (prevPercentage / 100) * 360;
                  }
                  
                  // Convert angles to radians
                  const startRad = (startAngle * Math.PI) / 180;
                  const endRad = ((startAngle + angle) * Math.PI) / 180;
                  
                  // Calculate arc path
                  const x1 = 50 + 40 * Math.cos(startRad);
                  const y1 = 50 + 40 * Math.sin(startRad);
                  const x2 = 50 + 40 * Math.cos(endRad);
                  const y2 = 50 + 40 * Math.sin(endRad);
                  
                  const largeArc = angle > 180 ? 1 : 0;
                  
                  return (
                    <Link
                      key={item.zone.id}
                      href={`/dashboard/zones/${item.zone.id}`}
                    >
                      <path
                        d={`M 50 50 L ${x1} ${y1} A 40 40 0 ${largeArc} 1 ${x2} ${y2} Z`}
                        fill={getZoneColor(index)}
                        className="hover:opacity-80 transition-opacity cursor-pointer"
                        stroke="white"
                        strokeWidth="0.5"
                      />
                    </Link>
                  );
                })}
                {/* Center circle */}
                <circle cx="50" cy="50" r="20" fill="white" className="dark:fill-gray-800" />
                <text
                  x="50"
                  y="50"
                  textAnchor="middle"
                  dy="0.3em"
                  className="text-base font-bold fill-gray-900 dark:fill-white transform rotate-90"
                  style={{ transformOrigin: "center" }}
                >
                  {totalPlants}
                </text>
              </svg>
              </div>
            </div>
            
            {/* Legend */}
            <div className="w-full md:w-1/2">
              <div className="overflow-x-auto md:overflow-x-visible md:overflow-y-auto md:max-h-64 flex md:flex-col gap-2 pb-2 md:pb-0">
              {plantsPerZone.map((item, index) => {
                const percentage = ((item.count / totalPlants) * 100).toFixed(1);
                return (
                  <Link
                    key={item.zone.id}
                    href={`/dashboard/zones/${item.zone.id}`}
                    className="flex items-center gap-3 p-2 rounded hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors flex-shrink-0 md:flex-shrink min-w-[200px] md:min-w-0"
                  >
                    <div
                      className="w-4 h-4 rounded flex-shrink-0"
                      style={{ backgroundColor: getZoneColor(index) }}
                    />
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-gray-900 dark:text-white truncate">
                        {item.zone.name}
                      </p>
                      <p className="text-xs text-gray-600 dark:text-gray-400">
                        {item.count} plant{item.count !== 1 ? 's' : ''} ({percentage}%)
                      </p>
                    </div>
                    <svg
                      className="w-4 h-4 text-gray-400 flex-shrink-0"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M9 5l7 7-7 7"
                      />
                    </svg>
                  </Link>
                );
              })}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Diary Entries Gallery */}
      {diaryEntries.length > 0 && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold text-gray-900 dark:text-white">
              Recent Diary Entries
            </h2>
            <Link
              href="/dashboard/plants"
              className="text-sm text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
            >
              View all
            </Link>
          </div>
          <div className="overflow-x-auto pb-2">
            <div className="flex gap-4">
            {diaryEntries.map((entry) => {
              const plant = entry.plants as any;
              return (
                <Link
                  key={entry.id}
                  href={`/dashboard/plants/${entry.plant_id}`}
                  className="group relative flex-shrink-0 w-48 h-48 rounded-lg overflow-hidden bg-gray-100 dark:bg-gray-700 hover:ring-2 hover:ring-green-500 transition-all"
                >
                  {entry.image_url ? (
                    <img
                      src={entry.image_url}
                      alt={entry.notes}
                      className="w-full h-full object-cover"
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-4xl">
                      {entry.entry_type === 'watering' && '💧'}
                      {entry.entry_type === 'fertilizing' && '🌱'}
                      {entry.entry_type === 'pruning' && '✂️'}
                      {entry.entry_type === 'observation' && '👁️'}
                      {entry.entry_type === 'other' && '📝'}
                    </div>
                  )}
                  <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity">
                    <div className="absolute bottom-0 left-0 right-0 p-3">
                      <p className="text-white text-sm font-medium truncate">
                        {plant?.name}
                      </p>
                      <p className="text-white/80 text-xs truncate">
                        {entry.notes}
                      </p>
                      <p className="text-white/60 text-xs mt-1">
                        {new Date(entry.created_at).toLocaleDateString()}
                      </p>
                    </div>
                  </div>
                </Link>
              );
            })}
            </div>
          </div>
        </div>
      )}

      {/* Zones List */}
      {zones.length > 0 && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
          <button
            onClick={() => setZonesExpanded(!zonesExpanded)}
            className="w-full p-6 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
          >
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
              Zones ({zones.length})
            </h2>
            <svg
              className={`w-5 h-5 text-gray-600 dark:text-gray-400 transition-transform ${
                zonesExpanded ? 'rotate-180' : ''
              }`}
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M19 9l-7 7-7-7"
              />
            </svg>
          </button>
          
          {zonesExpanded && (
            <div className="px-6 pb-6 overflow-y-auto max-h-[500px]">
              <div className="space-y-3">
              {zones.map((zone) => (
                <Link
                  key={zone.id}
                  href={`/dashboard/zones/${zone.id}`}
                  className="block p-4 bg-gray-50 dark:bg-gray-700 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    {zone.image_url && (
                      <div className="w-20 h-20 flex-shrink-0">
                        <img
                          src={zone.image_url}
                          alt={zone.name}
                          className="w-full h-full object-cover rounded-lg"
                        />
                      </div>
                    )}
                    <div className="flex-1">
                      <h3 className="font-medium text-gray-900 dark:text-white">
                        📍 {zone.name}
                      </h3>
                      {zone.description && (
                        <p className="text-sm text-gray-600 dark:text-gray-400 mt-1">
                          {zone.description}
                        </p>
                      )}
                    </div>
                    <svg
                      className="w-5 h-5 text-gray-400 flex-shrink-0"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M9 5l7 7-7 7"
                      />
                    </svg>
                  </div>
                </Link>
              ))}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Recent Plants */}
      {plants.length > 0 && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
          <button
            onClick={() => setPlantsExpanded(!plantsExpanded)}
            className="w-full p-6 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
          >
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
              Plants ({plants.length})
            </h2>
            <svg
              className={`w-5 h-5 text-gray-600 dark:text-gray-400 transition-transform ${
                plantsExpanded ? 'rotate-180' : ''
              }`}
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M19 9l-7 7-7-7"
              />
            </svg>
          </button>
          
          {plantsExpanded && (
            <div className="px-6 pb-6 overflow-y-auto max-h-[500px]">
              <div className="space-y-3">
              {plants.slice(0, 10).map((plant) => (
                <Link
                  key={plant.id}
                  href={`/dashboard/plants/${plant.id}`}
                  className="block p-4 bg-gray-50 dark:bg-gray-700 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3 flex-1">
                      {plant.image_url ? (
                        <div className="flex-shrink-0 w-12 h-12 rounded overflow-hidden bg-gray-200 dark:bg-gray-600">
                          <img
                            src={plant.image_url}
                            alt={plant.name}
                            className="w-full h-full object-cover"
                          />
                        </div>
                      ) : (
                        <div className="flex-shrink-0 w-12 h-12 rounded bg-gray-200 dark:bg-gray-600 flex items-center justify-center text-xl">
                          🌿
                        </div>
                      )}
                      <div className="flex-1 min-w-0">
                        <h3 className="font-medium text-gray-900 dark:text-white truncate">
                          {plant.name}
                        </h3>
                        {plant.zone && (
                          <p className="text-sm text-gray-600 dark:text-gray-400 truncate">
                            📍 {plant.zone.name}
                          </p>
                        )}
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      {needsWatering(plant) && (
                        <span className="text-yellow-500 text-xl">💧</span>
                      )}
                      <svg
                        className="w-5 h-5 text-gray-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M9 5l7 7-7 7"
                        />
                      </svg>
                    </div>
                  </div>
                </Link>
              ))}
              {plants.length > 10 && (
                <Link
                  href="/dashboard/plants"
                  className="block p-4 text-center text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
                >
                  View all {plants.length} plants →
                </Link>
              )}
              </div>
            </div>
          )}
        </div>
      )}

      {plants.length === 0 && zones.length === 0 && (
        <div className="text-center py-12 bg-white dark:bg-gray-800 rounded-lg shadow">
          <p className="text-gray-600 dark:text-gray-400 mb-4">
            Get started by creating your first zone!
          </p>
          <Link
            href="/dashboard/zones/new"
            className="inline-block bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors"
          >
            Create First Zone
          </Link>
        </div>
      )}
    </div>
  );
}
