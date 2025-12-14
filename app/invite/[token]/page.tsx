"use client";

import { use, useEffect, useState } from "react";
import { supabase } from "@/lib/supabase/client";
import { Database } from "@/lib/supabase/database.types";
import { useRouter } from "next/navigation";
import Link from "next/link";

type Invitation = Database["public"]["Tables"]["invitations"]["Row"] & {
  homes?: { name: string };
};

export default function InvitePage({
  params,
}: {
  params: Promise<{ token: string }>;
}) {
  const { token } = use(params);
  const [invitation, setInvitation] = useState<Invitation | null>(null);
  const [loading, setLoading] = useState(true);
  const [processing, setProcessing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);
  const router = useRouter();

  useEffect(() => {
    loadInvitation();
  }, [token]);

  const loadInvitation = async () => {
    const { data, error } = await supabase
      .from("invitations")
      .select(`
        *,
        homes (name)
      `)
      .eq("token", token)
      .eq("status", "pending")
      .single();

    if (error || !data) {
      setError("Invalid or expired invitation");
    } else {
      // Check if invitation is expired
      if (new Date(data.expires_at) < new Date()) {
        setError("This invitation has expired");
        await supabase
          .from("invitations")
          .update({ status: "expired" })
          .eq("id", data.id);
      } else {
        setInvitation(data as any);
      }
    }
    setLoading(false);
  };

  const handleAccept = async () => {
    if (!invitation) return;

    setProcessing(true);
    setError(null);

    const { data: { user } } = await supabase.auth.getUser();
    
    if (!user) {
      // Redirect to login with return URL
      router.push(`/login?redirect=/invite/${token}`);
      return;
    }

    // Check if user's email matches the invitation
    if (user.email?.toLowerCase() !== invitation.email.toLowerCase()) {
      setError(`This invitation is for ${invitation.email}. Please log in with that email address.`);
      setProcessing(false);
      return;
    }

    // Check if already a member
    const { data: existingMember } = await supabase
      .from("home_members")
      .select("*")
      .eq("home_id", invitation.home_id)
      .eq("user_id", user.id)
      .single();

    if (existingMember) {
      setError("You are already a member of this home");
      setProcessing(false);
      return;
    }

    // Add user as member
    const { error: memberError } = await supabase
      .from("home_members")
      .insert([{
        home_id: invitation.home_id,
        user_id: user.id,
        role: "member",
      }]);

    if (memberError) {
      setError("Error accepting invitation: " + memberError.message);
      setProcessing(false);
      return;
    }

    // Update invitation status
    await supabase
      .from("invitations")
      .update({ status: "accepted" })
      .eq("id", invitation.id);

    setSuccess(true);
    setTimeout(() => {
      router.push("/dashboard");
    }, 2000);
  };

  const handleDecline = async () => {
    if (!invitation) return;

    setProcessing(true);

    await supabase
      .from("invitations")
      .update({ status: "declined" })
      .eq("id", invitation.id);

    router.push("/dashboard");
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <div className="max-w-md w-full bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8 text-center">
          <div className="text-red-500 text-5xl mb-4">⚠️</div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            Invitation Error
          </h1>
          <p className="text-gray-600 dark:text-gray-400 mb-6">{error}</p>
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

  if (success) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <div className="max-w-md w-full bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8 text-center">
          <div className="text-green-500 text-5xl mb-4">✅</div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            Welcome!
          </h1>
          <p className="text-gray-600 dark:text-gray-400 mb-6">
            You've successfully joined {(invitation?.homes as any)?.name}. Redirecting to dashboard...
          </p>
        </div>
      </div>
    );
  }

  if (!invitation) {
    return null;
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <div className="max-w-md w-full bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8">
        <div className="text-center mb-6">
          <div className="text-5xl mb-4">🏡</div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
            You're Invited!
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            You've been invited to collaborate on
          </p>
          <p className="text-xl font-semibold text-green-600 dark:text-green-400 mt-2">
            {(invitation.homes as any)?.name}
          </p>
        </div>

        <div className="bg-gray-50 dark:bg-gray-700 rounded-lg p-4 mb-6">
          <p className="text-sm text-gray-600 dark:text-gray-400">
            As a member, you'll be able to:
          </p>
          <ul className="mt-2 space-y-1 text-sm text-gray-700 dark:text-gray-300">
            <li>✓ View and manage plants</li>
            <li>✓ Add diary entries</li>
            <li>✓ Upload photos</li>
            <li>✓ Track watering schedules</li>
          </ul>
        </div>

        {error && (
          <div className="mb-4 p-3 bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400 rounded">
            {error}
          </div>
        )}

        <div className="flex gap-3">
          <button
            onClick={handleAccept}
            disabled={processing}
            className="flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg disabled:opacity-50 transition-colors"
          >
            {processing ? "Accepting..." : "Accept Invitation"}
          </button>
          <button
            onClick={handleDecline}
            disabled={processing}
            className="flex-1 bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-semibold py-3 px-6 rounded-lg disabled:opacity-50 transition-colors"
          >
            Decline
          </button>
        </div>

        <p className="mt-4 text-xs text-gray-500 dark:text-gray-400 text-center">
          Invitation expires on {new Date(invitation.expires_at).toLocaleDateString()}
        </p>
      </div>
    </div>
  );
}
