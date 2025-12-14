"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import Link from "next/link";
import { deletePlantImage } from "@/lib/utils/imageUpload";

type Zone = Database["public"]["Tables"]["zones"]["Row"];
type Home = Database["public"]["Tables"]["homes"]["Row"];

export default function ZonesPage() {
  const [zones, setZones] = useState<Zone[]>([]);
  const [homes, setHomes] = useState<Home[]>([]);
  const [selectedHome, setSelectedHome] = useState<Home | null>(null);
  const [loading, setLoading] = useState(true);
  const [selectedZoneIds, setSelectedZoneIds] = useState<Set<string>>(new Set());
  const [isMultiSelectMode, setIsMultiSelectMode] = useState(false);

  useEffect(() => {
    loadHomes();
  }, []);

  useEffect(() => {
    if (selectedHome) {
      loadZones();
    }
  }, [selectedHome]);

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

  const deleteZone = async (zoneId: string) => {
    if (!confirm("Are you sure you want to delete this zone? All plants in this zone will also be deleted.")) {
      return;
    }

    // Get zone details for image deletion
    const zone = zones.find(z => z.id === zoneId);
    
    // Delete zone image if exists
    if (zone?.image_url) {
      await deletePlantImage(zone.image_url);
    }

    // Get all plants in this zone to delete their images
    const { data: plants } = await supabase
      .from("plants")
      .select("id, image_url")
      .eq("zone_id", zoneId);

    if (plants) {
      for (const plant of plants) {
        // Delete plant image
        if (plant.image_url) {
          await deletePlantImage(plant.image_url);
        }

        // Delete all diary entries and their images for this plant
        const { data: diaryEntries } = await supabase
          .from("plant_diary_entries")
          .select("image_url")
          .eq("plant_id", plant.id);

        if (diaryEntries) {
          for (const entry of diaryEntries) {
            if (entry.image_url) {
              await deletePlantImage(entry.image_url);
            }
          }
        }

        // Delete diary entries
        await supabase
          .from("plant_diary_entries")
          .delete()
          .eq("plant_id", plant.id);
      }

      // Delete all plants in the zone
      await supabase.from("plants").delete().eq("zone_id", zoneId);
    }

    // Delete the zone
    const { error } = await supabase.from("zones").delete().eq("id", zoneId);

    if (error) {
      console.error("Error deleting zone:", error);
      alert("Error deleting zone: " + error.message);
    } else {
      loadZones();
    }
  };

  const toggleZoneSelection = (zoneId: string) => {
    const newSelection = new Set(selectedZoneIds);
    if (newSelection.has(zoneId)) {
      newSelection.delete(zoneId);
    } else {
      newSelection.add(zoneId);
    }
    setSelectedZoneIds(newSelection);
  };

  const toggleSelectAll = () => {
    if (selectedZoneIds.size === zones.length) {
      setSelectedZoneIds(new Set());
    } else {
      setSelectedZoneIds(new Set(zones.map(z => z.id)));
    }
  };

  const deleteSelectedZones = async () => {
    if (selectedZoneIds.size === 0) return;
    
    if (!confirm(`Delete ${selectedZoneIds.size} zone(s) and all their plants? This cannot be undone.`)) {
      return;
    }

    for (const zoneId of selectedZoneIds) {
      await deleteZone(zoneId);
    }

    setSelectedZoneIds(new Set());
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
          Create a home first before adding zones.
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
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Zones</h1>
        </div>
        <div className="flex gap-2">
          {zones.length > 0 && (
            <button
              onClick={() => {
                setIsMultiSelectMode(!isMultiSelectMode);
                setSelectedZoneIds(new Set());
              }}
              className="bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-semibold py-2 px-4 rounded-lg transition-colors"
            >
              {isMultiSelectMode ? "Cancel" : "Select Multiple"}
            </button>
          )}
          <Link
            href="/dashboard/zones/new"
            className="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
          >
            + Add Zone
          </Link>
        </div>
      </div>

      {isMultiSelectMode && zones.length > 0 && (
        <div className="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <button
              onClick={toggleSelectAll}
              className="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 font-medium"
            >
              {selectedZoneIds.size === zones.length ? "Deselect All" : "Select All"}
            </button>
            <span className="text-gray-700 dark:text-gray-300">
              {selectedZoneIds.size} selected
            </span>
          </div>
          {selectedZoneIds.size > 0 && (
            <button
              onClick={deleteSelectedZones}
              className="bg-red-600 hover:bg-red-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
            >
              Delete Selected ({selectedZoneIds.size})
            </button>
          )}
        </div>
      )}

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

      {zones.length === 0 ? (
        <div className="text-center py-12 bg-white dark:bg-gray-800 rounded-lg shadow">
          <p className="text-gray-600 dark:text-gray-400 mb-4">
            No zones yet. Create your first zone!
          </p>
          <Link
            href="/dashboard/zones/new"
            className="inline-block bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors"
          >
            Create First Zone
          </Link>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-2">
          {zones.map((zone) => (
            <div
              key={zone.id}
              className={`bg-white dark:bg-gray-800 rounded-lg shadow hover:shadow-lg transition-all overflow-hidden ${
                isMultiSelectMode && selectedZoneIds.has(zone.id)
                  ? "ring-2 ring-blue-500"
                  : ""
              }`}
            >
              {isMultiSelectMode && (
                <div className="p-4 bg-gray-50 dark:bg-gray-700/50 border-b border-gray-200 dark:border-gray-700">
                  <label className="flex items-center cursor-pointer">
                    <input
                      type="checkbox"
                      checked={selectedZoneIds.has(zone.id)}
                      onChange={() => toggleZoneSelection(zone.id)}
                      className="w-5 h-5 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 focus:ring-2"
                    />
                    <span className="ml-2 text-sm font-medium text-gray-900 dark:text-white">
                      Select this zone
                    </span>
                  </label>
                </div>
              )}

              <Link
                href={`/dashboard/zones/${zone.id}`}
                className="block"
                onClick={(e) => {
                  if (isMultiSelectMode) {
                    e.preventDefault();
                    toggleZoneSelection(zone.id);
                  }
                }}
              >
                {zone.image_url && (
                  <div className="w-full h-48 overflow-hidden">
                    <img
                      src={zone.image_url}
                      alt={zone.name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                )}
                <div className="p-6">
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                    📍 {zone.name}
                  </h3>
                  {zone.description && (
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      {zone.description}
                    </p>
                  )}
                </div>
              </Link>

              {!isMultiSelectMode && (
                <div className="flex gap-2 px-6 pb-6">
                  <button
                    onClick={() => deleteZone(zone.id)}
                    className="w-full bg-red-100 dark:bg-red-900/30 hover:bg-red-200 dark:hover:bg-red-900/50 text-red-700 dark:text-red-400 font-medium py-2 px-4 rounded-lg transition-colors"
                  >
                    Delete
                  </button>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
