"use client";

import { use, useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { uploadPlantImage, deletePlantImage } from "@/lib/utils/imageUpload";

type Plant = Database["public"]["Tables"]["plants"]["Row"];
type Zone = Database["public"]["Tables"]["zones"]["Row"];
type Home = Database["public"]["Tables"]["homes"]["Row"];
type DiaryEntry = Database["public"]["Tables"]["plant_diary_entries"]["Row"];
type PlantWithRelations = Plant & { zone: Zone & { home: Home } };

export default function PlantDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const [plant, setPlant] = useState<Plant | null>(null);
  const [zone, setZone] = useState<Zone | null>(null);
  const [home, setHome] = useState<Home | null>(null);
  const [diaryEntries, setDiaryEntries] = useState<DiaryEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [showDiaryForm, setShowDiaryForm] = useState(false);
  
  // Edit form states
  const [name, setName] = useState("");
  const [species, setSpecies] = useState("");
  const [description, setDescription] = useState("");
  const [wateringFrequency, setWateringFrequency] = useState("");
  const [uploadingImage, setUploadingImage] = useState(false);

  // Diary form states
  const [diaryType, setDiaryType] = useState<"watering" | "fertilizing" | "pruning" | "observation" | "other">("observation");
  const [diaryNotes, setDiaryNotes] = useState("");
  const [diaryImage, setDiaryImage] = useState<File | null>(null);
  const [addingDiary, setAddingDiary] = useState(false);

  const router = useRouter();

  useEffect(() => {
    loadPlant();
    loadDiaryEntries();
  }, [id]);

  const loadPlant = async () => {
    const { data, error } = await supabase
      .from("plants")
      .select(`
        *,
        zone:zones(
          *,
          home:homes(*)
        )
      `)
      .eq("id", id)
      .single<PlantWithRelations>();

    if (error) {
      console.error("Error loading plant:", error);
    } else if (data) {
      setPlant(data as Plant);
      const zoneData = data.zone as Zone & { home: Home };
      setZone(zoneData);
      setHome(zoneData?.home as Home);
      const p = data as Partial<Plant>;
      setName((p.name as string) || "");
      setSpecies((p.species as string) || "");
      setDescription((p.description as string) || "");
      setWateringFrequency((p.watering_frequency_days as number | undefined)?.toString() || "");
    }
    setLoading(false);
  };

  const loadDiaryEntries = async () => {
    const { data, error } = await supabase
      .from("plant_diary_entries")
      .select("*")
      .eq("plant_id", id)
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading diary entries:", error);
    } else if (data) {
      setDiaryEntries(data);
    }
  };

  const handleWater = async () => {
    const { error } = await supabase
      .from("plants")
      .update({
        last_watered: new Date().toISOString().split("T")[0],
      })
      .eq("id", id);

    if (error) {
      alert("Error updating watering date: " + error.message);
    } else {
      // Also add diary entry
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        await supabase
          .from("plant_diary_entries")
          .insert([{
            plant_id: id,
            user_id: user.id,
            entry_type: "watering",
            notes: "Watered plant",
          }]);
      }
      loadPlant();
      loadDiaryEntries();
    }
  };

  const handleSave = async () => {
    const { error } = await supabase
      .from("plants")
      .update({
        name,
        species: species || null,
        description: description || null,
        watering_frequency_days: wateringFrequency ? parseInt(wateringFrequency) : null,
      })
      .eq("id", id);

    if (error) {
      alert("Error updating plant: " + error.message);
    } else {
      setIsEditing(false);
      loadPlant();
    }
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !plant || !zone) return;

    setUploadingImage(true);
    
    // Delete old image if exists
    if (plant.image_url) {
      await deletePlantImage(plant.image_url);
    }

    const imageUrl = await uploadPlantImage(file, plant.id, zone.home_id);

    if (imageUrl) {
      const { error } = await supabase
        .from("plants")
        .update({ image_url: imageUrl })
        .eq("id", plant.id);

      if (error) {
        alert("Error updating image: " + error.message);
      } else {
        loadPlant();
      }
    } else {
      alert("Error uploading image");
    }

    setUploadingImage(false);
  };

  const handleArchive = async () => {
    if (!confirm("Archive this plant? You can restore it later.")) return;

    const { error } = await supabase
      .from("plants")
      .update({ status: "archived" })
      .eq("id", id);

    if (error) {
      alert("Error archiving plant: " + error.message);
    } else {
      router.push("/dashboard/plants");
    }
  };

  const handleDelete = async () => {
    if (!confirm("Permanently delete this plant and all its diary entries? This cannot be undone.")) return;

    // Delete all diary entry images
    for (const entry of diaryEntries) {
      if (entry.image_url) {
        await deletePlantImage(entry.image_url);
      }
    }

    // Delete all diary entries
    await supabase
      .from("plant_diary_entries")
      .delete()
      .eq("plant_id", id);

    // Delete plant image if exists
    if (plant?.image_url) {
      await deletePlantImage(plant.image_url);
    }

    // Delete plant
    const { error } = await supabase
      .from("plants")
      .delete()
      .eq("id", id);

    if (error) {
      alert("Error deleting plant: " + error.message);
    } else {
      router.push("/dashboard/plants");
    }
  };

  const handleAddDiaryEntry = async (e: React.FormEvent) => {
    e.preventDefault();
    setAddingDiary(true);

    const { data: { user } } = await supabase.auth.getUser();
    if (!user || !zone) return;

    let imageUrl = null;
    if (diaryImage && plant) {
      imageUrl = await uploadPlantImage(diaryImage, plant.id, zone.home_id);
    }

    const { error } = await supabase
      .from("plant_diary_entries")
      .insert([{
        plant_id: id,
        user_id: user.id,
        entry_type: diaryType,
        notes: diaryNotes,
        image_url: imageUrl,
      }]);

    if (error) {
      alert("Error adding diary entry: " + error.message);
    } else {
      setDiaryNotes("");
      setDiaryImage(null);
      setShowDiaryForm(false);
      loadDiaryEntries();
    }

    setAddingDiary(false);
  };

  const handleDeleteDiaryEntry = async (entryId: string, imageUrl: string | null) => {
    if (!confirm("Delete this diary entry?")) return;

    // Delete image if exists
    if (imageUrl) {
      await deletePlantImage(imageUrl);
    }

    const { error } = await supabase
      .from("plant_diary_entries")
      .delete()
      .eq("id", entryId);

    if (error) {
      alert("Error deleting diary entry: " + error.message);
    } else {
      loadDiaryEntries();
    }
  };

  const needsWatering = () => {
    if (!plant?.last_watered || !plant?.watering_frequency_days) return false;
    const lastWatered = new Date(plant.last_watered);
    const nextWatering = new Date(lastWatered);
    nextWatering.setDate(nextWatering.getDate() + plant.watering_frequency_days);
    return nextWatering <= new Date();
  };

  const getDaysSinceWatered = () => {
    if (!plant?.last_watered) return null;
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

  if (!plant) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-600 dark:text-gray-400 mb-4">Plant not found</p>
        <Link
          href="/dashboard/plants"
          className="text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
        >
          ← Back to Plants
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
          {zone && (
            <>
              <Link
                href={`/dashboard/zones/${zone.id}`}
                className="text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
                title="Back to Zone"
              >
                {zone.name}
              </Link>
              <span className="text-gray-400">›</span>
            </>
          )}
          <span className="text-gray-900 dark:text-white font-medium">{plant.name}</span>
        </div>
        {!isEditing && (
          <button
            onClick={() => setIsEditing(true)}
            className="text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200 p-2"
            title="Edit plant"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
            </svg>
          </button>
        )}
      </div>

      {/* Plant Image */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow overflow-hidden">
        {plant.image_url ? (
          <div className="relative aspect-[4/3] bg-gray-100 dark:bg-gray-700">
            <img
              src={plant.image_url}
              alt={plant.name}
              className="w-full h-full object-cover"
            />
          </div>
        ) : (
          <div className="aspect-[4/3] bg-gray-100 dark:bg-gray-700 flex items-center justify-center">
            <span className="text-6xl">🌿</span>
          </div>
        )}
        
        {isEditing && (
          <div className="p-4">
            <label className="block">
              <span className="text-sm text-gray-600 dark:text-gray-400">
                {uploadingImage ? "Uploading..." : "Change Photo"}
              </span>
              <input
                type="file"
                accept="image/*"
                onChange={handleImageUpload}
                disabled={uploadingImage}
                className="block w-full mt-2 text-sm text-gray-600 dark:text-gray-400
                  file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0
                  file:text-sm file:font-semibold file:bg-green-50 file:text-green-700
                  hover:file:bg-green-100 dark:file:bg-green-900 dark:file:text-green-300"
              />
            </label>
          </div>
        )}
      </div>

      {/* Plant Details */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        {isEditing ? (
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Plant Name
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
                Species
              </label>
              <input
                type="text"
                value={species}
                onChange={(e) => setSpecies(e.target.value)}
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
                className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Watering Frequency (days)
              </label>
              <input
                type="number"
                value={wateringFrequency}
                onChange={(e) => setWateringFrequency(e.target.value)}
                min="1"
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
                  setName(plant.name);
                  setSpecies(plant.species || "");
                  setDescription(plant.description || "");
                  setWateringFrequency(plant.watering_frequency_days?.toString() || "");
                }}
                className="flex-1 bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-semibold py-2 px-4 rounded-lg transition-colors"
              >
                Cancel
              </button>
            </div>
          </div>
        ) : (
          <div className="space-y-4">
            <div>
              <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
                {plant.name}
              </h1>
              {plant.species && (
                <p className="text-lg italic text-gray-600 dark:text-gray-400">
                  {plant.species}
                </p>
              )}
            </div>

            {zone && (
              <div className="flex items-center gap-2 text-gray-600 dark:text-gray-400">
                <span>📍</span>
                <span>{zone.name}</span>
              </div>
            )}

            {plant.description && (
              <p className="text-gray-700 dark:text-gray-300">
                {plant.description}
              </p>
            )}

            {/* Watering Info */}
            <div className="border-t border-gray-200 dark:border-gray-700 pt-4 space-y-2">
              {plant.last_watered && (
                <div className="flex items-center justify-between">
                  <span className="text-sm text-gray-600 dark:text-gray-400">
                    Last watered:
                  </span>
                  <span className="font-medium">
                    {getDaysSinceWatered() === 0
                      ? "Today"
                      : `${getDaysSinceWatered()} days ago`}
                  </span>
                </div>
              )}
              
              {plant.watering_frequency_days && (
                <div className="flex items-center justify-between">
                  <span className="text-sm text-gray-600 dark:text-gray-400">
                    Watering frequency:
                  </span>
                  <span className="font-medium">
                    Every {plant.watering_frequency_days} days
                  </span>
                </div>
              )}

              {needsWatering() && (
                <div className="bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-lg p-3">
                  <p className="text-yellow-800 dark:text-yellow-300 text-sm font-medium">
                    💧 This plant needs watering!
                  </p>
                </div>
              )}
            </div>

            {/* Action Buttons */}
            <div className="border-t border-gray-200 dark:border-gray-700 pt-4 space-y-2">
              <button
                onClick={handleWater}
                className="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-4 rounded-lg transition-colors"
              >
                💧 Mark as Watered
              </button>

              <button
                onClick={() => setShowDiaryForm(!showDiaryForm)}
                className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-4 rounded-lg transition-colors"
              >
                📝 Add Diary Entry
              </button>

              <div className="grid grid-cols-2 gap-2">
                <button
                  onClick={handleArchive}
                  className="bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-medium py-2 px-4 rounded-lg transition-colors"
                >
                  Archive
                </button>
                <button
                  onClick={handleDelete}
                  className="bg-red-100 dark:bg-red-900/30 hover:bg-red-200 dark:hover:bg-red-900/50 text-red-700 dark:text-red-400 font-medium py-2 px-4 rounded-lg transition-colors"
                >
                  Delete
                </button>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Diary Entry Form */}
      {showDiaryForm && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-4">
            Add Diary Entry
          </h2>
          <form onSubmit={handleAddDiaryEntry} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Entry Type
              </label>
              <select
                value={diaryType}
                onChange={(e) => setDiaryType(e.target.value as any)}
                className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
              >
                <option value="observation">Observation</option>
                <option value="watering">Watering</option>
                <option value="fertilizing">Fertilizing</option>
                <option value="pruning">Pruning</option>
                <option value="other">Other</option>
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Notes
              </label>
              <textarea
                value={diaryNotes}
                onChange={(e) => setDiaryNotes(e.target.value)}
                required
                rows={3}
                placeholder="What's happening with your plant?"
                className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Photo (optional)
              </label>
              <input
                type="file"
                accept="image/*"
                onChange={(e) => setDiaryImage(e.target.files?.[0] || null)}
                className="block w-full text-sm text-gray-600 dark:text-gray-400
                  file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0
                  file:text-sm file:font-semibold file:bg-green-50 file:text-green-700
                  hover:file:bg-green-100 dark:file:bg-green-900 dark:file:text-green-300"
              />
            </div>

            <div className="flex gap-2">
              <button
                type="submit"
                disabled={addingDiary}
                className="flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg disabled:opacity-50 transition-colors"
              >
                {addingDiary ? "Adding..." : "Add Entry"}
              </button>
              <button
                type="button"
                onClick={() => setShowDiaryForm(false)}
                className="flex-1 bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-semibold py-2 px-4 rounded-lg transition-colors"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Diary Entries */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-4">
          Plant Diary
        </h2>
        
        {diaryEntries.length === 0 ? (
          <p className="text-gray-600 dark:text-gray-400 text-center py-8">
            No diary entries yet. Add your first observation!
          </p>
        ) : (
          <div className="space-y-4">
            {diaryEntries.map((entry) => (
              <div
                key={entry.id}
                className="border border-gray-200 dark:border-gray-700 rounded-lg p-4"
              >
                <div className="flex items-start justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <span className="inline-block bg-green-100 dark:bg-green-900 text-green-800 dark:text-green-300 text-xs font-medium px-2.5 py-0.5 rounded">
                      {entry.entry_type}
                    </span>
                    <span className="text-sm text-gray-500">
                      {new Date(entry.created_at).toLocaleDateString()}
                    </span>
                  </div>
                  <button
                    onClick={() => handleDeleteDiaryEntry(entry.id, entry.image_url)}
                    className="text-red-600 hover:text-red-800 dark:text-red-400 dark:hover:text-red-300 p-1"
                    title="Delete entry"
                  >
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>

                {entry.image_url && (
                  <div className="mb-3">
                    <img
                      src={entry.image_url}
                      alt="Diary entry"
                      className="w-full rounded-lg max-h-64 object-cover"
                    />
                  </div>
                )}

                <p className="text-gray-700 dark:text-gray-300">
                  {entry.notes}
                </p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
