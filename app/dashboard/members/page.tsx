"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import Link from "next/link";

type Home = Database["public"]["Tables"]["homes"]["Row"];
type HomeMember = Database["public"]["Tables"]["home_members"]["Row"] & {
  profiles?: { email: string; full_name: string | null };
};
type Invitation = Database["public"]["Tables"]["invitations"]["Row"];

export default function MembersPage() {
  const [homes, setHomes] = useState<Home[]>([]);
  const [selectedHome, setSelectedHome] = useState<Home | null>(null);
  const [members, setMembers] = useState<HomeMember[]>([]);
  const [invitations, setInvitations] = useState<Invitation[]>([]);
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<{ type: "success" | "error"; text: string } | null>(null);
  const [currentUserId, setCurrentUserId] = useState<string>("");
  const [userRole, setUserRole] = useState<"owner" | "member">("member");

  useEffect(() => {
    loadHomes();
    getCurrentUser();
  }, []);

  useEffect(() => {
    if (selectedHome) {
      loadMembers();
      loadInvitations();
      loadUserRole();
    }
  }, [selectedHome]);

  const getCurrentUser = async () => {
    const { data: { user } } = await supabase.auth.getUser();
    if (user) {
      setCurrentUserId(user.id);
    }
  };

  const loadUserRole = async () => {
    if (!selectedHome) return;
    
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;

    const { data } = await supabase
      .from("home_members")
      .select("role")
      .eq("home_id", selectedHome.id)
      .eq("user_id", user.id)
      .single();

    // Supabase typed response can sometimes infer to never; safely cast
    if (data) {
      const d = data as { role?: "owner" | "member" };
      if (d.role) setUserRole(d.role);
    }
  };

  const loadHomes = async () => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;

    const { data, error } = await supabase
      .from("home_members")
      .select("homes(*)")
      .eq("user_id", user.id);

    if (error) {
      console.error("Error loading homes:", error);
    } else if (data) {
      const homesList = data.map((item: any) => item.homes).filter(Boolean);
      setHomes(homesList);
      if (homesList.length > 0) {
        setSelectedHome(homesList[0]);
      }
    }
  };

  const loadMembers = async () => {
    if (!selectedHome) return;

    const { data, error } = await supabase
      .from("home_members")
      .select(`
        *,
        profiles:user_id (email, full_name)
      `)
      .eq("home_id", selectedHome.id);

    if (error) {
      console.error("Error loading members:", error);
    } else if (data) {
      setMembers(data as any);
    }
  };

  const loadInvitations = async () => {
    if (!selectedHome) return;

    const { data, error } = await supabase
      .from("invitations")
      .select("*")
      .eq("home_id", selectedHome.id)
      .in("status", ["pending"])
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Error loading invitations:", error);
    } else if (data) {
      setInvitations(data);
    }
  };

  const generateInviteToken = () => {
    return Array.from(crypto.getRandomValues(new Uint8Array(32)))
      .map(b => b.toString(16).padStart(2, '0'))
      .join('');
  };

  const handleInvite = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedHome || !email) return;

    setLoading(true);
    setMessage(null);

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      setMessage({ type: "error", text: "You must be logged in to invite members" });
      setLoading(false);
      return;
    }

    // Check if user is already a member
    const { data: existingMember } = await supabase
      .from("home_members")
      .select("*")
      .eq("home_id", selectedHome.id)
      .eq("user_id", user.id)
      .single();

    if (existingMember) {
      setMessage({ type: "error", text: "User is already a member" });
      setLoading(false);
      return;
    }

    // Check if there's a pending invitation
    const { data: existingInvite } = await supabase
      .from("invitations")
      .select("*")
      .eq("home_id", selectedHome.id)
      .eq("email", email.toLowerCase())
      .eq("status", "pending")
      .single();

    if (existingInvite) {
      setMessage({ type: "error", text: "An invitation has already been sent to this email" });
      setLoading(false);
      return;
    }

    const token = generateInviteToken();
    const inviteUrl = `${window.location.origin}/invite/${token}`;

    const { error } = await supabase
      .from("invitations")
      .insert([
        {
          home_id: selectedHome.id,
          email: email.toLowerCase(),
          token,
          invited_by: user.id,
        }
      ]);

    if (error) {
      setMessage({ type: "error", text: "Error creating invitation: " + error.message });
    } else {
      setMessage({ 
        type: "success", 
        text: `Invitation created! Share this link: ${inviteUrl}` 
      });
      setEmail("");
      loadInvitations();
    }

    setLoading(false);
  };

  const handleRemoveMember = async (memberId: string, userId: string) => {
    if (!confirm("Remove this member from the home?")) return;

    const { error } = await supabase
      .from("home_members")
      .delete()
      .eq("id", memberId);

    if (error) {
      alert("Error removing member: " + error.message);
    } else {
      loadMembers();
    }
  };

  const handleCancelInvitation = async (inviteId: string) => {
    const { error } = await supabase
      .from("invitations")
      .update({ status: "expired" })
      .eq("id", inviteId);

    if (error) {
      alert("Error canceling invitation: " + error.message);
    } else {
      loadInvitations();
    }
  };

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
    setMessage({ type: "success", text: "Invitation link copied to clipboard!" });
  };

  if (homes.length === 0) {
    return (
      <div className="max-w-2xl mx-auto mt-8">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8 text-center">
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            No Homes Yet
          </h2>
          <p className="text-gray-600 dark:text-gray-400 mb-6">
            Create a home first to manage members.
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
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
          Manage Members
        </h1>
        <Link
          href="/dashboard"
          className="text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 font-medium"
        >
          ← Back to Dashboard
        </Link>
      </div>

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

      {/* Invite Member Form */}
      {userRole === "owner" && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-4">
            Invite Member
          </h2>

          {message && (
            <div className={`mb-4 p-3 rounded ${
              message.type === "success" 
                ? "bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400"
                : "bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400"
            }`}>
              {message.text}
              {message.type === "success" && message.text.includes("http") && (
                <button
                  onClick={() => copyToClipboard(message.text.split(": ")[1])}
                  className="ml-2 underline"
                >
                  Copy Link
                </button>
              )}
            </div>
          )}

          <form onSubmit={handleInvite} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Email Address
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="colleague@example.com"
                required
                className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent dark:bg-gray-700 dark:text-white"
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg disabled:opacity-50 transition-colors"
            >
              {loading ? "Creating Invitation..." : "Send Invitation"}
            </button>
          </form>
        </div>
      )}

      {/* Pending Invitations */}
      {userRole === "owner" && invitations.length > 0 && (
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-4">
            Pending Invitations
          </h2>
          <div className="space-y-3">
            {invitations.map((invite) => (
              <div
                key={invite.id}
                className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-700 rounded-lg"
              >
                <div>
                  <p className="font-medium text-gray-900 dark:text-white">
                    {invite.email}
                  </p>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    Sent {new Date(invite.created_at).toLocaleDateString()}
                  </p>
                  <button
                    onClick={() => copyToClipboard(`${window.location.origin}/invite/${invite.token}`)}
                    className="text-sm text-green-600 dark:text-green-400 hover:underline"
                  >
                    Copy invitation link
                  </button>
                </div>
                <button
                  onClick={() => handleCancelInvitation(invite.id)}
                  className="text-red-600 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300"
                >
                  Cancel
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Current Members */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-4">
          Members ({members.length})
        </h2>
        <div className="space-y-3">
          {members.map((member) => (
            <div
              key={member.id}
              className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-700 rounded-lg"
            >
              <div>
                <p className="font-medium text-gray-900 dark:text-white">
                  {(member.profiles as any)?.full_name || (member.profiles as any)?.email}
                  {member.user_id === currentUserId && " (You)"}
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-400">
                  {(member.profiles as any)?.email}
                </p>
                <span className={`inline-block mt-1 text-xs px-2 py-1 rounded ${
                  member.role === "owner"
                    ? "bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400"
                    : "bg-gray-200 dark:bg-gray-600 text-gray-700 dark:text-gray-300"
                }`}>
                  {member.role}
                </span>
              </div>
              {userRole === "owner" && member.role !== "owner" && member.user_id !== currentUserId && (
                <button
                  onClick={() => handleRemoveMember(member.id, member.user_id)}
                  className="text-red-600 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300"
                >
                  Remove
                </button>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
