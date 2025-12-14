-- Add image_url column to zones table
ALTER TABLE zones ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Add comment
COMMENT ON COLUMN zones.image_url IS 'URL to zone image stored in Supabase Storage';
