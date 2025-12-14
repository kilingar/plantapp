"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import Link from "next/link";

type Home = Database["public"]["Tables"]["homes"]["Row"];
type Profile = Database["public"]["Tables"]["profiles"]["Row"];
type HomeMember = Database["public"]["Tables"]["home_members"]["Row"] & {
  profiles?: Profile;
};

export default function AdminPage() {
  const [isSuperAdmin, setIsSuperAdmin] = useState(false);
  const [loading, setLoading] = useState(true);
  const [homes, setHomes] = useState<Home[]>([]);
  const [selectedHome, setSelectedHome] = useState<Home | null>(null);
  const [members, setMembers] = useState<HomeMember[]>([]);
  const [allUsers, setAllUsers] = useState<Profile[]>([]);

  useEffect(() => {
    checkAdminAccess();
  }, []);

  useEffect(() => {
    if (isSuperAdmin) {
      loadAllHomes();
      loadAllUsers();
    }
  }, [isSuperAdmin]);

  useEffect(() => {
    if (selectedHome) {
      loadHomeMembers();
    }
  }, [selectedHome]);

  const checkAdminAccess = async () => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      setLoading(false);
      return;
    }

    const { data: profile } = await supabase
      .from("profiles")
      .select("super_admin")
      .eq("id", user.id)
      .single();

    // Supabase typed response can be inferred as never; cast safely
    if ((profile as { super_admin?: boolean } | null)?.super_admin) {
      setIsSuperAdmin(true);
    }
    setLoading(false);
  };

  const loadAllHomes = async () => {
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
  };

  const loadAllUsers = async () => {
    const { data, error } = await supabase
      .from("profiles")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading users:", error);
    } else if (data) {
      setAllUsers(data);
    }
  };

  const loadHomeMembers = async () => {
    if (!selectedHome) return;

    const { data, error } = await supabase
      .from("home_members")
      .select(`
        *,
        profiles:user_id (*)
      `)
      .eq("home_id", selectedHome.id);

    if (error) {
      console.error("Error loading members:", error);
    } else if (data) {
      setMembers(data as any);
    }
  };

  const getHomesCount = async (userId: string) => {
    const { count } = await supabase
      .from("home_members")
      .select("*", { count: "exact", head: true })
      .eq("user_id", userId);
    return count || 0;
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
      </div>
    );
  }

  if (!isSuperAdmin) {
    return (
      <div className="max-w-2xl mx-auto mt-8">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8 text-center">
          <div className="text-5xl mb-4">🔒</div>
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            Access Denied
          </h2>
          <p className="text-gray-600 dark:text-gray-400 mb-6">
            You don't have permission to access this page.
          </p>
          <Link
            href="/dashboard"
            className="inline-block bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors"
          >
            Go to Dashboard
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Super Admin Panel
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            System overview and debugging tools
          </p>
        </div>
        <Link
          href="/dashboard"
          className="text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
        >
          ← Back to Dashboard
        </Link>
      </div>

      {/* Stats Overview */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <div className="text-3xl font-bold text-green-600 dark:text-green-400">
            {homes.length}
          </div>
          <div className="text-sm text-gray-600 dark:text-gray-400 mt-1">
            Total Homes
          </div>
        </div>
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <div className="text-3xl font-bold text-blue-600 dark:text-blue-400">
            {allUsers.length}
          </div>
          <div className="text-sm text-gray-600 dark:text-gray-400 mt-1">
            Total Users
          </div>
        </div>
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <div className="text-3xl font-bold text-purple-600 dark:text-purple-400">
            {allUsers.filter(u => u.super_admin).length}
          </div>
          <div className="text-sm text-gray-600 dark:text-gray-400 mt-1">
            Super Admins
          </div>
        </div>
      </div>

      {/* All Homes */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
        <div className="p-6 border-b border-gray-200 dark:border-gray-700">
          <h2 className="text-xl font-bold text-gray-900 dark:text-white">
            All Homes
          </h2>
        </div>
        <div className="p-6">
          {homes.length === 0 ? (
            <p className="text-gray-600 dark:text-gray-400 text-center py-8">
              No homes found
            </p>
          ) : (
            <div className="space-y-2">
              {homes.map((home) => (
                <button
                  key={home.id}
                  onClick={() => setSelectedHome(home)}
                  className={`w-full text-left p-4 rounded-lg transition-colors ${
                    selectedHome?.id === home.id
                      ? "bg-green-50 dark:bg-green-900/30 border-2 border-green-500"
                      : "bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600"
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <div>
                      <h3 className="font-semibold text-gray-900 dark:text-white">
                        {home.name}
                      </h3>
                      {home.description && (
                        <p className="text-sm text-gray-600 dark:text-gray-400">
                          {home.description}
                        </p>
                      )}
                      <p className="text-xs text-gray-500 dark:text-gray-500 mt-1">
                        ID: {home.id}
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="text-sm text-gray-600 dark:text-gray-400">
                        Created {new Date(home.created_at).toLocaleDateString()}
                      </p>
                      {home.google_drive_folder_url && (
                        <span className="inline-block mt-1 text-xs px-2 py-1 bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400 rounded">
                          Google Drive
                        </span>
                      )}
                    </div>
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Home Members */}
      {selectedHome && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
          <div className="p-6 border-b border-gray-200 dark:border-gray-700">
            <h2 className="text-xl font-bold text-gray-900 dark:text-white">
              Members of "{selectedHome.name}"
            </h2>
          </div>
          <div className="p-6">
            {members.length === 0 ? (
              <p className="text-gray-600 dark:text-gray-400 text-center py-8">
                No members found
              </p>
            ) : (
              <div className="space-y-3">
                {members.map((member) => (
                  <div
                    key={member.id}
                    className="p-4 bg-gray-50 dark:bg-gray-700 rounded-lg"
                  >
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium text-gray-900 dark:text-white">
                          {(member.profiles as any)?.full_name || "No name"}
                        </p>
                        <p className="text-sm text-gray-600 dark:text-gray-400">
                          {(member.profiles as any)?.email}
                        </p>
                        <div className="flex gap-2 mt-2">
                          <span className={`text-xs px-2 py-1 rounded ${
                            member.role === "owner"
                              ? "bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400"
                              : "bg-gray-200 dark:bg-gray-600 text-gray-700 dark:text-gray-300"
                          }`}>
                            {member.role}
                          </span>
                          {(member.profiles as any)?.super_admin && (
                            <span className="text-xs px-2 py-1 rounded bg-purple-100 dark:bg-purple-900/30 text-purple-700 dark:text-purple-400">
                              Super Admin
                            </span>
                          )}
                        </div>
                      </div>
                      <div className="text-sm text-gray-600 dark:text-gray-400">
                        Joined {new Date(member.created_at).toLocaleDateString()}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      )}

      {/* All Users */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
        <div className="p-6 border-b border-gray-200 dark:border-gray-700">
          <h2 className="text-xl font-bold text-gray-900 dark:text-white">
            All Users
          </h2>
        </div>
        <div className="p-6">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 dark:bg-gray-700">
                <tr>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    User
                  </th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Email
                  </th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Admin
                  </th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Joined
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                {allUsers.map((user) => (
                  <tr key={user.id} className="hover:bg-gray-50 dark:hover:bg-gray-700">
                    <td className="px-4 py-3 text-sm text-gray-900 dark:text-white">
                      {user.full_name || "No name"}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600 dark:text-gray-400">
                      {user.email}
                    </td>
                    <td className="px-4 py-3 text-sm">
                      {user.super_admin ? (
                        <span className="px-2 py-1 text-xs rounded bg-purple-100 dark:bg-purple-900/30 text-purple-700 dark:text-purple-400">
                          Yes
                        </span>
                      ) : (
                        <span className="text-gray-400">No</span>
                      )}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600 dark:text-gray-400">
                      {new Date(user.created_at).toLocaleDateString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
