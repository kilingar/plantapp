-- =============================================
-- Supabase Storage Setup for Plant Images
-- =============================================
-- The bucket and policies already exist!
-- You can skip running this file.
-- =============================================

-- If you need to recreate, go to:
-- Storage > Configuration > Policies
-- and manually delete the old policies first

-- 1. Create the 'plant-images' storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('plant-images', 'plant-images', true)
ON CONFLICT (id) DO NOTHING;
