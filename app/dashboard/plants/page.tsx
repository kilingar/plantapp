"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import Link from "next/link";
import { deletePlantImage } from "@/lib/utils/imageUpload";

type Plant = Database["public"]["Tables"]["plants"]["Row"] & {
  zone?: Database["public"]["Tables"]["zones"]["Row"];
};
type Home = Database["public"]["Tables"]["homes"]["Row"];

export default function PlantsPage() {
  const [plants, setPlants] = useState<Plant[]>([]);
  const [homes, setHomes] = useState<Home[]>([]);
  const [selectedHome, setSelectedHome] = useState<Home | null>(null);
  const [filterStatus, setFilterStatus] = useState<"active" | "archived" | "all">("active");
  const [loading, setLoading] = useState(true);
  const [selectedPlantIds, setSelectedPlantIds] = useState<Set<string>>(new Set());
  const [isMultiSelectMode, setIsMultiSelectMode] = useState(false);

  useEffect(() => {
    loadHomes();
  }, []);

  useEffect(() => {
    if (selectedHome) {
      loadPlants();
    }
  }, [selectedHome, filterStatus]);

  const loadHomes = async () => {
    const { data, error } = await supabase
      .from("homes")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading homes:", error);
    } else if (data) {
      setHomes(data);
      if (data.length > 0) {
        setSelectedHome(data[0]);
      }
    }
    setLoading(false);
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
    let query = supabase
      .from("plants")
      .select(`
        *,
        zone:zones(*)
      `)
      .in("zone_id", zoneIds);

    if (filterStatus !== "all") {
      query = query.eq("status", filterStatus);
    }

    const { data, error } = await query.order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading plants:", error);
    } else if (data) {
      setPlants(data as Plant[]);
    }
  };

  const needsWatering = (plant: Plant) => {
    if (!plant.last_watered || !plant.watering_frequency_days) return false;
    const lastWatered = new Date(plant.last_watered);
    const nextWatering = new Date(lastWatered);
    nextWatering.setDate(nextWatering.getDate() + plant.watering_frequency_days);
    return nextWatering <= new Date();
  };

  const getDaysSinceWatered = (plant: Plant) => {
    if (!plant.last_watered) return null;
    const lastWatered = new Date(plant.last_watered);
    const today = new Date();
    const diff = Math.floor((today.getTime() - lastWatered.getTime()) / (1000 * 60 * 60 * 24));
    return diff;
  };

  const deletePlant = async (plantId: string) => {
    if (!confirm("Delete this plant and all its diary entries?")) return;

    const plant = plants.find(p => p.id === plantId);

    // Delete all diary entry images
    const { data: diaryEntries } = await supabase
      .from("plant_diary_entries")
      .select("image_url")
      .eq("plant_id", plantId);

    if (diaryEntries) {
      for (const entry of diaryEntries) {
        if (entry.image_url) {
          await deletePlantImage(entry.image_url);
        }
      }
    }

    // Delete all diary entries
    await supabase
      .from("plant_diary_entries")
      .delete()
      .eq("plant_id", plantId);

    // Delete plant image
    if (plant?.image_url) {
      await deletePlantImage(plant.image_url);
    }

    // Delete plant
    const { error } = await supabase
      .from("plants")
      .delete()
      .eq("id", plantId);

    if (error) {
      alert("Error deleting plant: " + error.message);
    } else {
      loadPlants();
    }
  };

  const togglePlantSelection = (plantId: string) => {
    const newSelection = new Set(selectedPlantIds);
    if (newSelection.has(plantId)) {
      newSelection.delete(plantId);
    } else {
      newSelection.add(plantId);
    }
    setSelectedPlantIds(newSelection);
  };

  const toggleSelectAll = () => {
    if (selectedPlantIds.size === plants.length) {
      setSelectedPlantIds(new Set());
    } else {
      setSelectedPlantIds(new Set(plants.map(p => p.id)));
    }
  };

  const deleteSelectedPlants = async () => {
    if (selectedPlantIds.size === 0) return;
    
    if (!confirm(`Delete ${selectedPlantIds.size} plant(s) and all their diary entries? This cannot be undone.`)) {
      return;
    }

    for (const plantId of selectedPlantIds) {
      await deletePlant(plantId);
    }

    setSelectedPlantIds(new Set());
    setIsMultiSelectMode(false);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
      </div>
    );
  }

  if (homes.length === 0) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-600 dark:text-gray-400 mb-4">
          Create a home first before adding plants.
        </p>
        <Link
          href="/dashboard"
          className="text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
        >
          ← Back to Dashboard
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex flex-col gap-1">
          <div className="flex items-center gap-2">
            <Link
              href="/dashboard"
              className="flex items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
              title="Back to Dashboard"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
              </svg>
              <span className="text-sm">
                {selectedHome?.name}
              </span>
            </Link>
          </div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Plants</h1>
        </div>
        <div className="flex gap-2">
          {plants.length > 0 && (
            <button
              onClick={() => {
                setIsMultiSelectMode(!isMultiSelectMode);
                setSelectedPlantIds(new Set());
              }}
              className="bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-semibold py-2 px-4 rounded-lg transition-colors"
            >
              {isMultiSelectMode ? "Cancel" : "Select Multiple"}
            </button>
          )}
          <Link
            href="/dashboard/plants/new"
            className="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
          >
            + Add Plant
          </Link>
        </div>
      </div>

      {isMultiSelectMode && plants.length > 0 && (
        <div className="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <button
              onClick={toggleSelectAll}
              className="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 font-medium"
            >
              {selectedPlantIds.size === plants.length ? "Deselect All" : "Select All"}
            </button>
            <span className="text-gray-700 dark:text-gray-300">
              {selectedPlantIds.size} selected
            </span>
          </div>
          {selectedPlantIds.size > 0 && (
            <button
              onClick={deleteSelectedPlants}
              className="bg-red-600 hover:bg-red-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
            >
              Delete Selected ({selectedPlantIds.size})
            </button>
          )}
        </div>
      )}

      {/* Filters */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-4 space-y-4">
        {homes.length > 1 && (
          <div>
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

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Status
          </label>
          <div className="flex gap-2">
            <button
              onClick={() => setFilterStatus("active")}
              className={`flex-1 py-2 px-4 rounded-lg font-medium transition-colors ${
                filterStatus === "active"
                  ? "bg-green-600 text-white"
                  : "bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300"
              }`}
            >
              Active
            </button>
            <button
              onClick={() => setFilterStatus("archived")}
              className={`flex-1 py-2 px-4 rounded-lg font-medium transition-colors ${
                filterStatus === "archived"
                  ? "bg-green-600 text-white"
                  : "bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300"
              }`}
            >
              Archived
            </button>
            <button
              onClick={() => setFilterStatus("all")}
              className={`flex-1 py-2 px-4 rounded-lg font-medium transition-colors ${
                filterStatus === "all"
                  ? "bg-green-600 text-white"
                  : "bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300"
              }`}
            >
              All
            </button>
          </div>
        </div>
      </div>

      {/* Plants Grid */}
      {plants.length === 0 ? (
        <div className="text-center py-12 bg-white dark:bg-gray-800 rounded-lg shadow">
          <p className="text-gray-600 dark:text-gray-400 mb-4">
            No plants yet. Add your first plant!
          </p>
          <Link
            href="/dashboard/plants/new"
            className="inline-block bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors"
          >
            Add First Plant
          </Link>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-2">
          {plants.map((plant) => {
            const daysWatered = getDaysSinceWatered(plant);
            const needs = needsWatering(plant);

            return (
              <div
                key={plant.id}
                className={`bg-white dark:bg-gray-800 rounded-lg shadow hover:shadow-lg transition-all ${
                  isMultiSelectMode && selectedPlantIds.has(plant.id)
                    ? "ring-2 ring-blue-500"
                    : ""
                }`}
              >
                {isMultiSelectMode && (
                  <div className="p-4 bg-gray-50 dark:bg-gray-700/50 border-b border-gray-200 dark:border-gray-700">
                    <label className="flex items-center cursor-pointer">
                      <input
                        type="checkbox"
                        checked={selectedPlantIds.has(plant.id)}
                        onChange={() => togglePlantSelection(plant.id)}
                        className="w-5 h-5 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 focus:ring-2"
                      />
                      <span className="ml-2 text-sm font-medium text-gray-900 dark:text-white">
                        Select this plant
                      </span>
                    </label>
                  </div>
                )}

                <Link
                  href={`/dashboard/plants/${plant.id}`}
                  className="block"
                  onClick={(e) => {
                    if (isMultiSelectMode) {
                      e.preventDefault();
                      togglePlantSelection(plant.id);
                    }
                  }}
                >
                  {plant.image_url && (
                    <div className="w-full h-48 overflow-hidden">
                      <img
                        src={plant.image_url}
                        alt={plant.name}
                        className="w-full h-full object-cover"
                      />
                    </div>
                  )}
                  
                  <div className="p-6">
                    <div className="flex items-start justify-between mb-3">
                      <div className="flex-1">
                        <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-1">
                          🌿 {plant.name}
                        </h3>
                        {plant.species && (
                          <p className="text-sm text-gray-600 dark:text-gray-400 italic">
                            {plant.species}
                          </p>
                        )}
                      </div>
                      {needs && (
                        <span className="text-2xl" title="Needs watering">
                          💧
                        </span>
                      )}
                    </div>

                    {plant.zone && (
                      <p className="text-sm text-gray-600 dark:text-gray-400 mb-2">
                        📍 {plant.zone.name}
                      </p>
                    )}

                    {plant.description && (
                      <p className="text-sm text-gray-600 dark:text-gray-400 mb-3 line-clamp-2">
                        {plant.description}
                      </p>
                    )}

                    <div className="flex items-center justify-between text-xs text-gray-500 dark:text-gray-500">
                      <div>
                        {daysWatered !== null && (
                          <span>
                            Watered {daysWatered === 0 ? "today" : `${daysWatered}d ago`}
                          </span>
                        )}
                        {!plant.last_watered && <span>Not watered yet</span>}
                      </div>
                      {plant.status === "archived" && (
                        <span className="bg-gray-200 dark:bg-gray-700 px-2 py-1 rounded">
                          Archived
                        </span>
                      )}
                    </div>
                  </div>
                </Link>

                {!isMultiSelectMode && (
                  <div className="flex gap-2 px-6 pb-6">
                    <button
                      onClick={() => deletePlant(plant.id)}
                      className="w-full bg-red-100 dark:bg-red-900/30 hover:bg-red-200 dark:hover:bg-red-900/50 text-red-700 dark:text-red-400 font-medium py-2 px-4 rounded-lg transition-colors"
                    >
                      Delete
                    </button>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
