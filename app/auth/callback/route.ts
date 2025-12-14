import { NextResponse } from 'next/server';

export async function GET(request: Request) {
  const requestUrl = new URL(request.url);
  const code = requestUrl.searchParams.get('code');

  if (code) {
    // Exchange the code for a session - handled by Supabase automatically
    // Redirect to dashboard
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  // If no code, redirect to login
  return NextResponse.redirect(new URL('/auth/login', request.url));
}
