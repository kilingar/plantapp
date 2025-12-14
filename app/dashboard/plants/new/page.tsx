"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";
import { uploadPlantImage } from "@/lib/utils/imageUpload";

type Zone = Database["public"]["Tables"]["zones"]["Row"];
type Home = Database["public"]["Tables"]["homes"]["Row"];

export default function NewPlantPage() {
  const [homes, setHomes] = useState<Home[]>([]);
  const [zones, setZones] = useState<Zone[]>([]);
  const [selectedHomeId, setSelectedHomeId] = useState("");
  const [selectedZoneId, setSelectedZoneId] = useState("");
  const [name, setName] = useState("");
  const [species, setSpecies] = useState("");
  const [description, setDescription] = useState("");
  const [acquisitionDate, setAcquisitionDate] = useState("");
  const [wateringFrequency, setWateringFrequency] = useState("");
  const [image, setImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();
  const searchParams = useSearchParams();

  useEffect(() => {
    loadHomes();
  }, []);

  useEffect(() => {
    if (selectedHomeId) {
      loadZones();
    }
  }, [selectedHomeId]);

  // Pre-select zone from URL parameter
  useEffect(() => {
    const zoneParam = searchParams.get("zone");
    if (zoneParam && zones.length > 0) {
      const zone = zones.find(z => z.id === zoneParam);
      if (zone) {
        setSelectedZoneId(zoneParam);
      }
    }
  }, [searchParams, zones]);

  const loadHomes = async () => {
    const { data, error } = await supabase
      .from("homes")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading homes:", error);
      setError("Failed to load homes");
    } else if (data) {
      setHomes(data);
      if (data.length > 0) {
        setSelectedHomeId(data[0].id);
      }
    }
  };

  const loadZones = async () => {
    if (!selectedHomeId) return;

    const { data, error } = await supabase
      .from("zones")
      .select("*")
      .eq("home_id", selectedHomeId)
      .order("name", { ascending: true });

    if (error) {
      console.error("Error loading zones:", error);
    } else if (data) {
      setZones(data);
      if (data.length > 0 && !selectedZoneId) {
        setSelectedZoneId(data[0].id);
      }
    }
  };

  const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setImage(file);
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    if (!selectedZoneId) {
      setError("Please select a zone");
      setLoading(false);
      return;
    }

    // First create the plant
    const { data: plantData, error: plantError } = await supabase
      .from("plants")
      .insert([
        {
          zone_id: selectedZoneId,
          name,
          species: species || null,
          description: description || null,
          acquisition_date: acquisitionDate || null,
          watering_frequency_days: wateringFrequency ? parseInt(wateringFrequency) : null,
          last_watered: null,
          status: "active",
        },
      ])
      .select()
      .single();

    if (plantError) {
      console.error("Error creating plant:", plantError);
      setError(plantError.message);
      setLoading(false);
      return;
    }

    // Upload image if provided
    if (image && plantData) {
      // Get home_id from the selected zone
      const zone = zones.find(z => z.id === selectedZoneId);
      const imageUrl = await uploadPlantImage(image, plantData.id, zone?.home_id);
      
      if (imageUrl) {
        // Update plant with image URL
        await supabase
          .from("plants")
          .update({ image_url: imageUrl })
          .eq("id", plantData.id);
      }
    }

    if (plantData) {
      router.push(`/dashboard/plants/${plantData.id}`);
    }
  };

  if (homes.length === 0) {
    return (
      <div className="max-w-md mx-auto mt-8">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8">
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            No Homes Yet
          </h2>
          <p className="text-gray-600 dark:text-gray-400 mb-6">
            You need to create a home before adding plants.
          </p>
          <Link
            href="/dashboard"
            className="block w-full text-center bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors"
          >
            Go to Dashboard
          </Link>
        </div>
      </div>
    );
  }

  if (zones.length === 0) {
    return (
      <div className="max-w-md mx-auto mt-8">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8">
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            No Zones Yet
          </h2>
          <p className="text-gray-600 dark:text-gray-400 mb-6">
            You need to create at least one zone before adding plants.
          </p>
          <Link
            href="/dashboard/zones/new"
            className="block w-full text-center bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors"
          >
            Create a Zone
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-md mx-auto">
      <div className="mb-6">
        <Link
          href="/dashboard/plants"
          className="text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
        >
          ← Back to Plants
        </Link>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-6">
          Add New Plant
        </h1>

        {error && (
          <div className="mb-4 p-3 bg-red-100 dark:bg-red-900 text-red-700 dark:text-red-200 rounded">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          {homes.length > 1 && (
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Home
              </label>
              <select
                value={selectedHomeId}
                onChange={(e) => {
                  setSelectedHomeId(e.target.value);
                  setSelectedZoneId("");
                }}
                required
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
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Zone *
            </label>
            <select
              value={selectedZoneId}
              onChange={(e) => setSelectedZoneId(e.target.value)}
              required
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            >
              {zones.map((zone) => (
                <option key={zone.id} value={zone.id}>
                  {zone.name}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Plant Name *
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g., My Monstera"
              required
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Species (optional)
            </label>
            <input
              type="text"
              value={species}
              onChange={(e) => setSpecies(e.target.value)}
              placeholder="e.g., Monstera deliciosa"
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Description (optional)
            </label>
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Any notes about this plant..."
              rows={3}
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Acquisition Date (optional)
            </label>
            <input
              type="date"
              value={acquisitionDate}
              onChange={(e) => setAcquisitionDate(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Watering Frequency (days, optional)
            </label>
            <input
              type="number"
              value={wateringFrequency}
              onChange={(e) => setWateringFrequency(e.target.value)}
              placeholder="e.g., 7"
              min="1"
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
            <p className="mt-1 text-xs text-gray-500">
              How often this plant needs watering (in days)
            </p>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Plant Photo (optional)
            </label>
            <input
              type="file"
              accept="image/*"
              onChange={handleImageChange}
              className="block w-full text-sm text-gray-600 dark:text-gray-400
                file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0
                file:text-sm file:font-semibold file:bg-green-50 file:text-green-700
                hover:file:bg-green-100 dark:file:bg-green-900 dark:file:text-green-300"
            />
            {imagePreview && (
              <div className="mt-3">
                <img
                  src={imagePreview}
                  alt="Preview"
                  className="w-full rounded-lg max-h-48 object-cover"
                />
              </div>
            )}
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg disabled:opacity-50 transition-colors"
          >
            {loading ? "Adding..." : "Add Plant"}
          </button>
        </form>
      </div>
    </div>
  );
}
