"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import Link from "next/link";

type Home = Database["public"]["Tables"]["homes"]["Row"];

export default function SettingsPage() {
  const [homes, setHomes] = useState<Home[]>([]);
  const [selectedHome, setSelectedHome] = useState<Home | null>(null);
  const [googleDriveUrl, setGoogleDriveUrl] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    loadHomes();
  }, []);

  useEffect(() => {
    if (selectedHome) {
      setGoogleDriveUrl(selectedHome.google_drive_folder_url || "");
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

  const handleSave = async () => {
    if (!selectedHome) return;

    setSaving(true);
    const { error } = await supabase
      .from("homes")
      .update({ google_drive_folder_url: googleDriveUrl || null })
      .eq("id", selectedHome.id);

    if (error) {
      alert("Error saving settings: " + error.message);
    } else {
      alert("Settings saved! Images will now be " + 
        (googleDriveUrl ? "high quality (500KB max)" : "standard quality (100KB max)"));
      loadHomes();
    }
    setSaving(false);
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
          Create a home first.
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
    <div className="max-w-2xl mx-auto space-y-6">
      <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
        Settings
      </h1>

      {homes.length > 1 && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
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

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Photo Storage Settings
        </h2>
        
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Google Drive Folder URL (optional)
            </label>
            <input
              type="url"
              value={googleDriveUrl}
              onChange={(e) => setGoogleDriveUrl(e.target.value)}
              placeholder="https://drive.google.com/drive/folders/..."
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
            <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
              💡 <strong>Image Quality Settings:</strong>
            </p>
            <ul className="mt-1 text-sm text-gray-600 dark:text-gray-400 list-disc list-inside ml-4">
              <li><strong>Without Google Drive:</strong> Images compressed to ~100KB (faster uploads, saves storage)</li>
              <li><strong>With Google Drive:</strong> Images saved at ~500KB (better quality for backup)</li>
            </ul>
          </div>

          <div className="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4">
            <h3 className="text-sm font-semibold text-blue-900 dark:text-blue-300 mb-2">
              How to set up Google Drive backup:
            </h3>
            <ol className="text-sm text-blue-800 dark:text-blue-400 space-y-1 list-decimal list-inside">
              <li>Create a folder in Google Drive for your plant photos</li>
              <li>Right-click the folder → Share → Get link</li>
              <li>Copy the link and paste it here</li>
              <li>Higher quality images will be saved in the app</li>
            </ol>
            <p className="mt-2 text-xs text-blue-700 dark:text-blue-500">
              Note: This doesn't automatically upload to Google Drive. It just enables higher quality images in this app so you can manually backup later.
            </p>
          </div>

          <button
            onClick={handleSave}
            disabled={saving}
            className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg disabled:opacity-50 transition-colors"
          >
            {saving ? "Saving..." : "Save Settings"}
          </button>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Current Settings
        </h2>
        <dl className="space-y-2">
          <div className="flex justify-between">
            <dt className="text-sm text-gray-600 dark:text-gray-400">Home:</dt>
            <dd className="text-sm font-medium text-gray-900 dark:text-white">
              {selectedHome?.name}
            </dd>
          </div>
          <div className="flex justify-between">
            <dt className="text-sm text-gray-600 dark:text-gray-400">Image Quality:</dt>
            <dd className="text-sm font-medium text-gray-900 dark:text-white">
              {selectedHome?.google_drive_folder_url ? (
                <span className="text-green-600 dark:text-green-400">
                  High Quality (500KB)
                </span>
              ) : (
                <span className="text-blue-600 dark:text-blue-400">
                  Standard (100KB)
                </span>
              )}
            </dd>
          </div>
        </dl>
      </div>
    </div>
  );
}
