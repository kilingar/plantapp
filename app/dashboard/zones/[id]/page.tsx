"use client";

import { use, useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { uploadPlantImage, deletePlantImage } from "@/lib/utils/imageUpload";

type Zone = Database["public"]["Tables"]["zones"]["Row"];
type Plant = Database["public"]["Tables"]["plants"]["Row"];
type Home = Database["public"]["Tables"]["homes"]["Row"];

export default function ZoneDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const [zone, setZone] = useState<Zone | null>(null);
  const [home, setHome] = useState<Home | null>(null);
  const [plants, setPlants] = useState<Plant[]>([]);
  const [loading, setLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [uploadingImage, setUploadingImage] = useState(false);
  const router = useRouter();

  useEffect(() => {
    loadZone();
    loadPlants();
  }, [id]);

  const loadZone = async () => {
    const { data, error } = await supabase
      .from("zones")
      .select(`
        *,
        home:homes(*)
      `)
      .eq("id", id)
      .single();

    if (error) {
      console.error("Error loading zone:", error);
    } else if (data) {
      setZone(data);
      setHome(data.home as Home);
      setName(data.name);
      setDescription(data.description || "");
    }
    setLoading(false);
  };

  const loadPlants = async () => {
    const { data, error } = await supabase
      .from("plants")
      .select("*")
      .eq("zone_id", id)
      .eq("status", "active")
      .order("name", { ascending: true });

    if (error) {
      console.error("Error loading plants:", error);
    } else if (data) {
      setPlants(data);
    }
  };

  const handleSave = async () => {
    const { error } = await supabase
      .from("zones")
      .update({
        name,
        description: description || null,
      })
      .eq("id", id);

    if (error) {
      alert("Error updating zone: " + error.message);
    } else {
      setIsEditing(false);
      loadZone();
    }
  };

  const handleDelete = async () => {
    if (plants.length > 0) {
      alert("Cannot delete zone with plants. Please move or delete the plants first.");
      return;
    }

    if (!confirm("Permanently delete this zone? This cannot be undone.")) return;

    // Delete image if exists
    if (zone?.image_url) {
      await deletePlantImage(zone.image_url);
    }

    const { error } = await supabase
      .from("zones")
      .delete()
      .eq("id", id);

    if (error) {
      alert("Error deleting zone: " + error.message);
    } else {
      router.push("/dashboard/zones");
    }
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !zone) return;

    setUploadingImage(true);
    
    // Delete old image if exists
    if (zone.image_url) {
      await deletePlantImage(zone.image_url);
    }

    const imageUrl = await uploadPlantImage(file, zone.id, zone.home_id);

    if (imageUrl) {
      const { error } = await supabase
        .from("zones")
        .update({ image_url: imageUrl })
        .eq("id", zone.id);

      if (error) {
        alert("Error updating image: " + error.message);
      } else {
        loadZone();
      }
    } else {
      alert("Error uploading image");
    }

    setUploadingImage(false);
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
    return Math.floor((today.getTime() - lastWatered.getTime()) / (1000 * 60 * 60 * 24));
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
      </div>
    );
  }

  if (!zone) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-600 dark:text-gray-400 mb-4">Zone not found</p>
        <Link
          href="/dashboard/zones"
          className="text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
        >
          ← Back to Zones
        </Link>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Breadcrumb Navigation */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2 text-sm">
          {home && (
            <>
              <Link
                href="/dashboard"
                className="text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
                title="Back to Dashboard"
              >
                {home.name}
              </Link>
              <span className="text-gray-400">›</span>
            </>
          )}
          <Link
            href="/dashboard/zones"
            className="text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
            title="Back to Zones"
          >
            Zones
          </Link>
          <span className="text-gray-400">›</span>
          <span className="text-gray-900 dark:text-white font-medium">{zone.name}</span>
        </div>
        {!isEditing && (
          <button
            onClick={() => setIsEditing(true)}
            className="text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200 p-2"
            title="Edit zone"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
            </svg>
          </button>
        )}
      </div>

      {/* Zone Details */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        {isEditing ? (
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Zone Name
              </label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Description
              </label>
              <textarea
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                rows={3}
                placeholder="Optional description..."
                className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
              />
            </div>

            <div className="flex gap-2">
              <button
                onClick={handleSave}
                className="flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
              >
                Save Changes
              </button>
              <button
                onClick={() => {
                  setIsEditing(false);
                  setName(zone.name);
                  setDescription(zone.description || "");
                }}
                className="flex-1 bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-semibold py-2 px-4 rounded-lg transition-colors"
              >
                Cancel
              </button>
            </div>

            <div className="border-t border-gray-200 dark:border-gray-700 pt-4">
              <button
                onClick={handleDelete}
                className="w-full bg-red-100 dark:bg-red-900/30 hover:bg-red-200 dark:hover:bg-red-900/50 text-red-700 dark:text-red-400 font-medium py-2 px-4 rounded-lg transition-colors"
              >
                Delete Zone
              </button>
            </div>
          </div>
        ) : (
          <div className="space-y-4">
            {/* Zone Image */}
            {zone.image_url && (
              <div className="relative">
                <img
                  src={zone.image_url}
                  alt={zone.name}
                  className="w-full h-64 object-cover rounded-lg"
                />
              </div>
            )}

            {/* Upload/Change Photo */}
            <div>
              <label className="block">
                <span className="sr-only">Choose zone photo</span>
                <input
                  type="file"
                  accept="image/*"
                  capture="environment"
                  onChange={handleImageUpload}
                  disabled={uploadingImage}
                  className="block w-full text-sm text-gray-500 dark:text-gray-400
                    file:mr-4 file:py-2 file:px-4
                    file:rounded-lg file:border-0
                    file:text-sm file:font-semibold
                    file:bg-green-50 file:text-green-700
                    hover:file:bg-green-100
                    dark:file:bg-green-900/30 dark:file:text-green-400
                    dark:hover:file:bg-green-900/50
                    disabled:opacity-50"
                />
              </label>
              {uploadingImage && (
                <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
                  Uploading...
                </p>
              )}
            </div>

            <div>
              <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
                {zone.name}
              </h1>
              {zone.description && (
                <p className="text-gray-700 dark:text-gray-300">
                  {zone.description}
                </p>
              )}
            </div>

            <div className="flex items-center gap-4 text-sm text-gray-600 dark:text-gray-400">
              <div className="flex items-center gap-2">
                <span className="text-2xl">🌿</span>
                <span>{plants.length} {plants.length === 1 ? 'plant' : 'plants'}</span>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Plants in Zone */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-bold text-gray-900 dark:text-white">
            Plants in this Zone
          </h2>
          <Link
            href={`/dashboard/plants/new?zone=${id}`}
            className="text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium text-sm"
          >
            + Add Plant
          </Link>
        </div>

        {plants.length === 0 ? (
          <div className="text-center py-8">
            <p className="text-gray-600 dark:text-gray-400 mb-4">
              No plants in this zone yet
            </p>
            <Link
              href={`/dashboard/plants/new?zone=${id}`}
              className="inline-block bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-6 rounded-lg transition-colors"
            >
              Add Your First Plant
            </Link>
          </div>
        ) : (
          <div className="grid gap-4 sm:grid-cols-2">
            {plants.map((plant) => (
              <Link
                key={plant.id}
                href={`/dashboard/plants/${plant.id}`}
                className="block bg-gray-50 dark:bg-gray-700 rounded-lg p-4 hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors"
              >
                <div className="flex gap-3">
                  {plant.image_url ? (
                    <div className="flex-shrink-0 w-16 h-16 rounded-lg overflow-hidden bg-gray-200 dark:bg-gray-600">
                      <img
                        src={plant.image_url}
                        alt={plant.name}
                        className="w-full h-full object-cover"
                      />
                    </div>
                  ) : (
                    <div className="flex-shrink-0 w-16 h-16 rounded-lg bg-gray-200 dark:bg-gray-600 flex items-center justify-center text-2xl">
                      🌿
                    </div>
                  )}

                  <div className="flex-1 min-w-0">
                    <h3 className="font-semibold text-gray-900 dark:text-white truncate">
                      {plant.name}
                    </h3>
                    {plant.species && (
                      <p className="text-sm text-gray-600 dark:text-gray-400 italic truncate">
                        {plant.species}
                      </p>
                    )}
                    
                    {plant.last_watered && (
                      <div className="mt-1">
                        {needsWatering(plant) ? (
                          <span className="inline-flex items-center text-xs text-yellow-700 dark:text-yellow-400">
                            💧 Needs water
                          </span>
                        ) : (
                          <span className="text-xs text-gray-500">
                            Watered {getDaysSinceWatered(plant)} days ago
                          </span>
                        )}
                      </div>
                    )}
                  </div>
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
