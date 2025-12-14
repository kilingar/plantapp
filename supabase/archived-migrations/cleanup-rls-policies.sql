-- =============================================
-- Clean up unused RLS policies
-- =============================================
-- Since we disabled RLS for client-side compatibility,
-- we can remove the policies to eliminate the warnings
-- =============================================

-- Drop policies from homes table
DROP POLICY IF EXISTS "Users can view homes they are members of" ON public.homes;
DROP POLICY IF EXISTS "Users can create homes" ON public.homes;
DROP POLICY IF EXISTS "Owners can update their homes" ON public.homes;
DROP POLICY IF EXISTS "Owners can delete their homes" ON public.homes;

-- Drop policies from home_members table
DROP POLICY IF EXISTS "Users can view home members of their homes" ON public.home_members;
DROP POLICY IF EXISTS "Home owners can add members" ON public.home_members;
DROP POLICY IF EXISTS "Home owners can remove members" ON public.home_members;

-- Drop policies from zones table
DROP POLICY IF EXISTS "Users can view zones in their homes" ON public.zones;
DROP POLICY IF EXISTS "Home members can create zones" ON public.zones;
DROP POLICY IF EXISTS "Home members can update zones" ON public.zones;
DROP POLICY IF EXISTS "Home owners can delete zones" ON public.zones;

-- Drop policies from plants table
DROP POLICY IF EXISTS "Users can view plants in their homes" ON public.plants;
DROP POLICY IF EXISTS "Home members can create plants" ON public.plants;
DROP POLICY IF EXISTS "Home members can update plants" ON public.plants;
DROP POLICY IF EXISTS "Home members can delete plants" ON public.plants;

-- Drop policies from plant_diary_entries table
DROP POLICY IF EXISTS "Users can view diary entries for plants in their homes" ON public.plant_diary_entries;
DROP POLICY IF EXISTS "Home members can create diary entries" ON public.plant_diary_entries;
DROP POLICY IF EXISTS "Users can update their own diary entries" ON public.plant_diary_entries;
DROP POLICY IF EXISTS "Users can delete their own diary entries" ON public.plant_diary_entries;
