"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { User } from "@supabase/supabase-js";
import { useRouter } from "next/navigation";
import Link from "next/link";
import LoadingSpinner from "@/lib/components/LoadingSpinner";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [isSuperAdmin, setIsSuperAdmin] = useState(false);
  const router = useRouter();

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      setLoading(false);
      if (!session) {
        router.push("/auth/login");
      } else {
        checkSuperAdmin(session.user.id);
      }
    });

    // Listen for auth changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
      if (!session) {
        router.push("/auth/login");
      } else {
        checkSuperAdmin(session.user.id);
      }
    });

    return () => subscription.unsubscribe();
  }, [router]);

  const checkSuperAdmin = async (userId: string) => {
    const { data } = await supabase
      .from("profiles")
      .select("super_admin")
      .eq("id", userId)
      .single();
    
    if (data?.super_admin) {
      setIsSuperAdmin(true);
    }
  };

  const handleSignOut = async () => {
    await supabase.auth.signOut();
    router.push("/");
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <LoadingSpinner />
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Mobile Header */}
      <header className="bg-white dark:bg-gray-800 shadow-sm sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-4 py-4 flex items-center justify-between">
          <Link href="/dashboard" className="flex items-center gap-2">
            <span className="text-2xl">🌱</span>
            <span className="font-bold text-lg text-green-800 dark:text-green-400">
              Plant Diary
            </span>
          </Link>
          
          <div className="flex items-center gap-4">
            {isSuperAdmin && (
              <Link
                href="/admin"
                className="text-sm px-3 py-1 bg-purple-100 dark:bg-purple-900/30 text-purple-700 dark:text-purple-400 rounded-full hover:bg-purple-200 dark:hover:bg-purple-900/50 transition-colors"
              >
                Admin
              </Link>
            )}
            <button
              onClick={handleSignOut}
              className="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200"
            >
              Sign Out
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 py-6">{children}</main>

      {/* Bottom Navigation for Mobile */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 md:hidden">
        <div className="grid grid-cols-4 gap-1">
          <Link
            href="/dashboard"
            className="flex flex-col items-center py-3 px-2 text-gray-600 dark:text-gray-400 hover:text-green-600 dark:hover:text-green-400"
          >
            <svg
              className="w-6 h-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
              />
            </svg>
            <span className="text-xs mt-1">Home</span>
          </Link>

          <Link
            href="/dashboard/zones"
            className="flex flex-col items-center py-3 px-2 text-gray-600 dark:text-gray-400 hover:text-green-600 dark:hover:text-green-400"
          >
            <svg
              className="w-6 h-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M4 5a1 1 0 011-1h4a1 1 0 011 1v7a1 1 0 01-1 1H5a1 1 0 01-1-1V5zM14 5a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1h-4a1 1 0 01-1-1V5zM4 16a1 1 0 011-1h4a1 1 0 011 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-3zM14 13a1 1 0 011-1h4a1 1 0 011 1v6a1 1 0 01-1 1h-4a1 1 0 01-1-1v-6z"
              />
            </svg>
            <span className="text-xs mt-1">Zones</span>
          </Link>

          <Link
            href="/dashboard/plants"
            className="flex flex-col items-center py-3 px-2 text-gray-600 dark:text-gray-400 hover:text-green-600 dark:hover:text-green-400"
          >
            <span className="text-2xl">🌿</span>
            <span className="text-xs mt-1">Plants</span>
          </Link>

          <Link
            href="/dashboard/settings"
            className="flex flex-col items-center py-3 px-2 text-gray-600 dark:text-gray-400 hover:text-green-600 dark:hover:text-green-400"
          >
            <svg
              className="w-6 h-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
              />
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
              />
            </svg>
            <span className="text-xs mt-1">Settings</span>
          </Link>
        </div>
      </nav>

      {/* Spacer for mobile bottom nav */}
      <div className="h-20 md:hidden"></div>
    </div>
  );
}
