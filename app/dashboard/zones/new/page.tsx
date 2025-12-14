"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { uploadPlantImage } from "@/lib/utils/imageUpload";

type Home = Database["public"]["Tables"]["homes"]["Row"];

export default function NewZonePage() {
  const [homes, setHomes] = useState<Home[]>([]);
  const [selectedHomeId, setSelectedHomeId] = useState("");
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [image, setImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  useEffect(() => {
    loadHomes();
  }, []);

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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    if (!selectedHomeId) {
      setError("Please select a home");
      setLoading(false);
      return;
    }

    const { data: zoneData, error: zoneError } = await supabase
      .from("zones")
      .insert([
        {
          home_id: selectedHomeId,
          name,
          description: description || null,
        },
      ])
      .select()
      .single();

    if (zoneError) {
      console.error("Error creating zone:", zoneError);
      setError(zoneError.message);
      setLoading(false);
      return;
    }

    // Upload image if provided
    if (image && zoneData) {
      const imageUrl = await uploadPlantImage(image, zoneData.id, selectedHomeId);
      
      if (imageUrl) {
        await supabase
          .from("zones")
          .update({ image_url: imageUrl })
          .eq("id", zoneData.id);
      }
    }

    router.push("/dashboard/zones");
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

  if (homes.length === 0) {
    return (
      <div className="max-w-md mx-auto mt-8">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8">
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            No Homes Yet
          </h2>
          <p className="text-gray-600 dark:text-gray-400 mb-6">
            You need to create a home before adding zones.
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

  return (
    <div className="max-w-md mx-auto">
      <div className="mb-6">
        <Link
          href="/dashboard/zones"
          className="text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
        >
          ← Back to Zones
        </Link>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-6">
          Create New Zone
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
                onChange={(e) => setSelectedHomeId(e.target.value)}
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
              Zone Name *
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g., Living Room, Balcony, Kitchen"
              required
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
              placeholder="Add any notes about this zone..."
              rows={3}
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Photo (optional)
            </label>
            <input
              type="file"
              accept="image/*"
              capture="environment"
              onChange={handleImageChange}
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
            {imagePreview && (
              <div className="mt-2">
                <img
                  src={imagePreview}
                  alt="Zone preview"
                  className="w-full h-48 object-cover rounded-lg"
                />
              </div>
            )}
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg disabled:opacity-50 transition-colors"
          >
            {loading ? "Creating..." : "Create Zone"}
          </button>
        </form>
      </div>
    </div>
  );
}
