-- Plant Directory Migration SQL
-- Run this in Supabase SQL Editor
-- Generated on 2025-11-11T17:06:44.137Z

-- Step 1: Get or create a home (replace YOUR_USER_ID with your actual user UUID)
DO $$
DECLARE
  v_home_id UUID;
BEGIN
  -- Try to get existing home
  SELECT id INTO v_home_id FROM homes LIMIT 1;
  
  -- If no home exists, create one (update YOUR_USER_ID with your actual UUID)
  IF v_home_id IS NULL THEN
    INSERT INTO homes (name, owner_id, description)
    VALUES ('Rue Neuville', 'cf1d0d90-bb56-4797-8a4b-1f105669f424', 'Migrated from Plant Directory Excel')
    RETURNING id INTO v_home_id;
  END IF;
  
  RAISE NOTICE 'Using home ID: %', v_home_id;
END $$;

-- Step 2: Insert Zones (Resources)
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000000-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Table Corner',
  'Combination of grey table, brown table and the stool',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Resources_Images/d334ebf8.Image.131022.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000001-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'TV Left',
  'Left side of TV next to stone wall',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Resources_Images/511108be.Image.181129.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000002-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'TV Right Stand',
  'Right side aluminium stand next to TV',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Resources_Images/1c2a9df9.Image.181536.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000003-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'TV Right Humid',
  'Right side aluminium stand next to TV with humidifier',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Zones_Images/1c2a9d10.Image.113109.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000004-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'High Table',
  'Area around the high table including the hangings',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Resources_Images/0d943811.Image.184517.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000005-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Sofa Table',
  'Good for maximum light but indirect',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Resources_Images/24de835d.Image.125201.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000006-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Main Heater',
  'Summer time usage',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Resources_Images/cbe1683c.Image.184605.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000007-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Small Heater',
  'Bright indirect light all year',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Zones_Images/ad64s6.Image.133113.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000008-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Dining Table',
  'Decorative purposes',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Zones_Images/sde564rg.Image.133228.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000009-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Buffet Top',
  'Low light plants only',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Zones_Images/98d7df7dg.Image.183233.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000010-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Buffet Bottom',
  'Height restriction, good morning light with tower reflection',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Zones_Images/456g45r.Image.183345.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000011-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Outside',
  'Front balcony',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Resources_Images/30922fbe.Image.181242.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000012-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Back Room',
  'ICU for plants',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Resources_Images/60ded78e.Image.091608.webp'
);
INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '100000000013-0000-4000-8000-00000000',
  (SELECT id FROM homes LIMIT 1),
  'Propagation',
  'Plants in water',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Zones_Images/41a63941.Image.183449.webp'
);

-- Step 3: Insert Plants (Team)
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000000-0000-4000-8000-00000000',
  '100000000001-0000-4000-8000-00000000',
  'Umbrella Plant',
  NULL,
  'Schefflera',
  '2021-02-01',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/9b726410.Photo.181042.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000001-0000-4000-8000-00000000',
  '100000000000-0000-4000-8000-00000000',
  'Monstera 1',
  NULL,
  'Monstera Deliciosa',
  '2022-02-01',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0b9099a5.Photo.154337.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000002-0000-4000-8000-00000000',
  '100000000005-0000-4000-8000-00000000',
  'Weeping fig',
  NULL,
  'Ficus Benjamina',
  '2019-11-01',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/a0cfa0d4.Photo.125210.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000003-0000-4000-8000-00000000',
  '100000000012-0000-4000-8000-00000000',
  'Banana',
  NULL,
  'Musa oriental',
  '2022-11-02',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b5cfcc65.Photo.063945.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000004-0000-4000-8000-00000000',
  '100000000005-0000-4000-8000-00000000',
  'Zebra plant',
  NULL,
  'Aphelandra',
  '2023-08-01',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/e7e7908a.Photo.112530.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000005-0000-4000-8000-00000000',
  '100000000001-0000-4000-8000-00000000',
  'String of hearts',
  NULL,
  'Cerophegia woodii',
  '2021-07-02',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000006-0000-4000-8000-00000000',
  '100000000008-0000-4000-8000-00000000',
  'Oxalis',
  NULL,
  'Oxalis triangularis',
  '2019-11-02',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/71811a3c.Photo.133359.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000007-0000-4000-8000-00000000',
  '100000000005-0000-4000-8000-00000000',
  'Verigated umbrella',
  NULL,
  'Schefflera gold capella',
  '2023-03-31',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/4420c9c2.Photo.104209.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000008-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Spiderwort',
  NULL,
  'Tradescantia',
  '2022-09-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/3a63e102.Photo.105025.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000009-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Crassula',
  NULL,
  'Crassula Arborescens',
  '2020-10-22',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000010-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Philodendron India plant',
  NULL,
  'Philodendron rugosum',
  '2023-05-04',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d50ecf8e.Photo.110054.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000011-0000-4000-8000-00000000',
  '100000000009-0000-4000-8000-00000000',
  'Arrowhead plant',
  NULL,
  'Syngonium podophyllum',
  '2023-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b94f1816.Photo.110231.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000012-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Alocasia',
  NULL,
  'Alocasia Amazonica',
  '2023-09-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e935766f.Photo.110422.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000013-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Purple Cala Lilly plant',
  NULL,
  'Zantedeschia aethiopica',
  '2023-10-13',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/14b47870.Photo.112055.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000014-0000-4000-8000-00000000',
  '100000000005-0000-4000-8000-00000000',
  'Dracena',
  NULL,
  'Dracaena burley',
  '2019-11-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66de3e37.Photo.115908.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000015-0000-4000-8000-00000000',
  '100000000001-0000-4000-8000-00000000',
  'Philodendron Brasil',
  NULL,
  'Philodendron scandens Brasil',
  '2023-08-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e64ecb86.Photo.134450.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000016-0000-4000-8000-00000000',
  '100000000000-0000-4000-8000-00000000',
  'calathea big',
  NULL,
  'calathea oppenheimiana',
  '2023-07-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58e81d2a.Photo.140701.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000017-0000-4000-8000-00000000',
  '100000000001-0000-4000-8000-00000000',
  'Variegated rubber',
  NULL,
  'Ficus elastica',
  '2022-03-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d3ddcea.Photo.143018.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000018-0000-4000-8000-00000000',
  '100000000001-0000-4000-8000-00000000',
  'Rubber small green 1',
  NULL,
  'Ficus elastica',
  '2023-04-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f696cf27.Photo.174143.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000019-0000-4000-8000-00000000',
  '100000000001-0000-4000-8000-00000000',
  'Rubber small green 2',
  NULL,
  'Ficus elastica',
  '2023-04-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/22638d49.Photo.174159.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000020-0000-4000-8000-00000000',
  '100000000001-0000-4000-8000-00000000',
  'Fiddle leaf',
  NULL,
  'Ficus lyrata',
  '2022-03-12',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0ea955c6.Photo.174210.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000021-0000-4000-8000-00000000',
  '100000000000-0000-4000-8000-00000000',
  'Monstera 2',
  NULL,
  'Monstera deliciosa',
  '2022-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b811ca6e.Photo.154448.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000022-0000-4000-8000-00000000',
  '100000000000-0000-4000-8000-00000000',
  'Arrowhead white and pink',
  NULL,
  'Syngonium Podophyllum',
  '2023-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/c86bb012.Photo.154804.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000023-0000-4000-8000-00000000',
  '100000000000-0000-4000-8000-00000000',
  'Marantha',
  NULL,
  'Maranta leuconeura',
  '2022-08-06',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000024-0000-4000-8000-00000000',
  '100000000000-0000-4000-8000-00000000',
  'Chinese money plant',
  NULL,
  'Pilea peperomioides',
  '2024-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/6192551c.Photo.155204.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000025-0000-4000-8000-00000000',
  '100000000000-0000-4000-8000-00000000',
  'Pothos neon',
  NULL,
  'Epipremnum aureum neon',
  '2021-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0224cb40.Photo.155712.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000026-0000-4000-8000-00000000',
  '100000000005-0000-4000-8000-00000000',
  'String of pearls 2',
  NULL,
  'Senecio rowleyanus',
  '2023-08-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f0a4a78.Photo.173600.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000027-0000-4000-8000-00000000',
  '100000000004-0000-4000-8000-00000000',
  'Purpurea',
  NULL,
  'Tradescantia pallida',
  '2024-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/540f78d0.Photo.174038.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000028-0000-4000-8000-00000000',
  '100000000004-0000-4000-8000-00000000',
  'Boat Lily 1',
  NULL,
  'Tradescantia Spathacea',
  '2022-02-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/782aceb9.Photo.174926.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000029-0000-4000-8000-00000000',
  '100000000004-0000-4000-8000-00000000',
  'Light green picchi chettu',
  NULL,
  'Turtle vine',
  '2022-02-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e05a6cba.Photo.175454.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000030-0000-4000-8000-00000000',
  '100000000004-0000-4000-8000-00000000',
  'Song of India',
  NULL,
  'Dracaena reflexa',
  '2022-02-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a26e2877.Photo.175712.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000031-0000-4000-8000-00000000',
  '100000000004-0000-4000-8000-00000000',
  'Pothos mix 2',
  NULL,
  'Epipremnum aureum',
  '2021-12-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d1f91042.Photo.180338.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000032-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Jade',
  NULL,
  'Jade elephant bush',
  '2023-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/798e70de.Photo.180401.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000033-0000-4000-8000-00000000',
  '100000000004-0000-4000-8000-00000000',
  'Donkey tail',
  NULL,
  'Sedum Morganianum',
  '2023-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e0d01120.Photo.181153.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000034-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Snake plant',
  NULL,
  'Dracaena trifasciata',
  '2024-02-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/deb5f154.Photo.181421.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000035-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Spider plant yellow',
  NULL,
  'Chlorophytum comosum',
  '2024-02-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/69cb226b.Photo.181818.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000036-0000-4000-8000-00000000',
  '100000000011-0000-4000-8000-00000000',
  'Rose',
  NULL,
  NULL,
  '2023-11-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f3d318c.Photo.090022.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000037-0000-4000-8000-00000000',
  '100000000011-0000-4000-8000-00000000',
  'Gandhari chilli',
  NULL,
  'Capsicum annuum',
  '2024-03-01',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e20757ec.Photo.052016.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000038-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'String of pearls 1.2',
  NULL,
  'Senecio rowleyanus',
  '2021-01-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a3e45ea5.Photo.182906.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000039-0000-4000-8000-00000000',
  '100000000013-0000-4000-8000-00000000',
  'String of pearls 1.1',
  NULL,
  'Senecio rowleyanus',
  '2021-01-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b315e84f.Photo.183201.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000040-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Banyan',
  NULL,
  NULL,
  '2023-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/ef97823a.Photo.183337.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000041-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Pink cactus',
  NULL,
  'Crassula marginalis rubra variegated',
  '2022-03-12',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/40ce622d.Photo.184039.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000042-0000-4000-8000-00000000',
  '100000000011-0000-4000-8000-00000000',
  'Kalanchoe 1.2',
  NULL,
  NULL,
  '2023-08-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/ace543c8.Photo.184425.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000043-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Dark green picchi chettu',
  NULL,
  'Turtle vine',
  '2024-02-15',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/6a8db0df.Photo.184632.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000044-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Peperomia',
  NULL,
  'Peperomia hope',
  '2023-05-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/6e817bae.Photo.184717.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000045-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Fig',
  NULL,
  'Ficus Americana tresor',
  '2023-07-15',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/5f550da7.Photo.185243.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000046-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Baby Sun rose',
  NULL,
  'Mesembryanthemum cordifolium',
  '2021-02-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/3fe0fded.Photo.185156.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000047-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Fig 2',
  NULL,
  'Ficus Americana tesor',
  '2024-04-27',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/277b1a85.Photo.060709.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000048-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Banyan 2',
  NULL,
  'Ficus banyan',
  '2023-07-03',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0fe4036b.Photo.185551.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000049-0000-4000-8000-00000000',
  '100000000011-0000-4000-8000-00000000',
  'Orange',
  NULL,
  'Citrus',
  '2019-06-09',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0008842e.Photo.072546.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000050-0000-4000-8000-00000000',
  '100000000011-0000-4000-8000-00000000',
  'Kalanchoe',
  NULL,
  'Kalanchoe',
  '2020-10-22',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/72c362c7.Photo.072731.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000051-0000-4000-8000-00000000',
  '100000000011-0000-4000-8000-00000000',
  'Tulip mix',
  NULL,
  NULL,
  '2023-11-01',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f373280f.Photo.073357.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000052-0000-4000-8000-00000000',
  '100000000011-0000-4000-8000-00000000',
  'Summer mix',
  NULL,
  NULL,
  '2024-04-01',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/13ac7a2c.Photo.073440.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000053-0000-4000-8000-00000000',
  '100000000003-0000-4000-8000-00000000',
  'Golden Fern',
  NULL,
  'Phlebodium Aureum Blue Star Golden Fern',
  '2024-03-09',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/40a2efcb.Photo.133221.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000054-0000-4000-8000-00000000',
  '100000000003-0000-4000-8000-00000000',
  'Boston fern',
  NULL,
  'Nephrolepis exaltata',
  '2023-10-12',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/736fdf42.Photo.134239.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000055-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Asparagus fern',
  NULL,
  NULL,
  '2022-03-12',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/350d9488.Photo.134559.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000056-0000-4000-8000-00000000',
  '100000000003-0000-4000-8000-00000000',
  'Asparagus fern thick',
  NULL,
  NULL,
  '2023-10-12',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/7e351c37.Photo.134742.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000057-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Small monstera',
  NULL,
  'monstera siltepecana',
  '2023-05-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/ce5d720f.Photo.140024.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000058-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Pothos silvery anne',
  NULL,
  NULL,
  '2022-03-12',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/610324a2.Photo.133422.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000059-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Rubber plant burgundy',
  NULL,
  'Ficus elastica',
  '2024-02-18',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/dce08b43.Photo.142426.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000060-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Pothos N’joy',
  NULL,
  NULL,
  '2023-05-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1bd8a03d.Photo.142752.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000061-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Spider plant 4',
  NULL,
  'Reverse variegated spider plant',
  '2023-07-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1afb00dc.Photo.143552.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000062-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Philodendron Brasil 1.1',
  NULL,
  'Philodendron scandens Brasil',
  '2024-04-28',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/039a107a.Photo.143956.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000063-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Ficus alii 1.2',
  NULL,
  NULL,
  '2021-06-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1a334068.Photo.144401.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000064-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Spineless yucca',
  NULL,
  NULL,
  '2022-11-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1bf88c75.Photo.144659.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000065-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Pothos mix 1',
  NULL,
  NULL,
  '2021-05-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/196f1def.Photo.145221.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000066-0000-4000-8000-00000000',
  '100000000002-0000-4000-8000-00000000',
  'Boat Lily 1.1',
  NULL,
  'Tradescantia Spathacea',
  '2023-11-19',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000067-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Alocasia cucullata',
  NULL,
  NULL,
  '2024-02-15',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9b46e90f.Photo.151457.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000068-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Adanson''s monstera',
  NULL,
  NULL,
  '2024-03-16',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.151706.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000069-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Tillandsia leiboldiana',
  NULL,
  'Tillandsia',
  '2020-11-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b03542f0.Photo.152014.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000070-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Weeping fig 1.1',
  NULL,
  'Ficus benjamina',
  '2020-10-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d31a645.Photo.152212.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000071-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Jasmine',
  NULL,
  NULL,
  '2021-09-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/741a7847.Photo.152455.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000072-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Pothos mix 3',
  NULL,
  NULL,
  '2024-03-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8d3bf7e7.Photo.152807.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000073-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Pothos marble',
  NULL,
  NULL,
  '2024-03-14',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/df38dce9.Photo.152936.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000074-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Ficus alii 1',
  NULL,
  NULL,
  '2019-11-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e16d475a.Photo.153049.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000075-0000-4000-8000-00000000',
  '100000000009-0000-4000-8000-00000000',
  'Inchplant',
  NULL,
  'Tradescantia zebrina',
  '2020-08-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/927dd3eb.Photo.153942.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000076-0000-4000-8000-00000000',
  '100000000009-0000-4000-8000-00000000',
  'Parlor palm',
  NULL,
  NULL,
  '2019-10-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a1763e7c.Photo.154103.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000077-0000-4000-8000-00000000',
  '100000000009-0000-4000-8000-00000000',
  'Pothos mix 4',
  NULL,
  'Epipremnum aureum',
  '2021-07-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/4d04068a.Photo.154256.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000078-0000-4000-8000-00000000',
  '100000000000-0000-4000-8000-00000000',
  'ZZ plant',
  NULL,
  'Zamioculcas zamiifolia',
  '2022-03-12',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e8a64f31.Photo.154439.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000079-0000-4000-8000-00000000',
  '100000000009-0000-4000-8000-00000000',
  'English ivy',
  NULL,
  'Hedera helix',
  '2019-10-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9a2674d7.Photo.154559.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000080-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Pothos golden',
  NULL,
  'Epipremnum aureum',
  '2024-04-28',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/62019b5f.Photo.155656.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000081-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Pilea',
  NULL,
  'Pilea cadierei',
  '2020-08-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/2b17b367.Photo.155929.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000082-0000-4000-8000-00000000',
  '100000000010-0000-4000-8000-00000000',
  'Calathea 1.1',
  NULL,
  'Calathea oppenheimia',
  '2024-04-28',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/08d3f531.Photo.160349.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000083-0000-4000-8000-00000000',
  '100000000013-0000-4000-8000-00000000',
  'Pothos marble 2',
  NULL,
  'Epipremnum Aureum ‘Marble Queen’',
  '2023-05-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9961c4c0.Photo.160648.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000084-0000-4000-8000-00000000',
  '100000000010-0000-4000-8000-00000000',
  'Pothos mix 5',
  NULL,
  'Pothos',
  '2022-05-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/4149d31f.Photo.160633.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000085-0000-4000-8000-00000000',
  '100000000010-0000-4000-8000-00000000',
  'Rainbow Tree',
  NULL,
  'Dracaena reflexa',
  '2020-08-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/74120824.Photo.160829.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000086-0000-4000-8000-00000000',
  '100000000008-0000-4000-8000-00000000',
  'Spider plant 1',
  NULL,
  'Chlorophytum comosum vittatum',
  '2022-01-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cecfd7e0.Photo.160944.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000087-0000-4000-8000-00000000',
  '100000000008-0000-4000-8000-00000000',
  'Spider plant 2',
  NULL,
  'Chlorophytum Comosum ocean',
  '2022-01-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/623ab1ce.Photo.161011.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000088-0000-4000-8000-00000000',
  '100000000008-0000-4000-8000-00000000',
  'Spider plant 3',
  NULL,
  'Chlorophytum Comosum Curly Bonnie',
  '2022-01-05',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/fc6b71d3.Photo.161035.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000089-0000-4000-8000-00000000',
  '100000000006-0000-4000-8000-00000000',
  'Song of India 2',
  NULL,
  'Dracaena reflexa',
  '2024-05-25',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e66ca1e6.Photo.134304.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000090-0000-4000-8000-00000000',
  '100000000007-0000-4000-8000-00000000',
  'Pothos n’joy 2',
  NULL,
  NULL,
  '2024-07-01',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66ad913a.Photo.071356.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000091-0000-4000-8000-00000000',
  '100000000004-0000-4000-8000-00000000',
  'Donkey tail 2',
  NULL,
  NULL,
  '2024-07-20',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0d850ff0.Photo.071424.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000092-0000-4000-8000-00000000',
  '100000000003-0000-4000-8000-00000000',
  'Golden fern 2',
  NULL,
  NULL,
  '2024-08-31',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1c2ddb5d.Photo.084036.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000093-0000-4000-8000-00000000',
  '100000000013-0000-4000-8000-00000000',
  'Umbrella plant babies',
  NULL,
  NULL,
  '2024-09-21',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a4483f88.Photo.085903.webp',
  'active'
);
INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '200000000094-0000-4000-8000-00000000',
  '100000000011-0000-4000-8000-00000000',
  'Automn mix',
  NULL,
  NULL,
  '2024-09-08',
  NULL,
  NULL,
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b7cc617b.Photo.090118.webp',
  'active'
);

-- Step 4: Insert Diary Entries (Log)
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000000-0000-4000-8000-00000000',
  '200000000001-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Two leaves kept in water and once rooted were put in clay pot',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/0b9099a5.Photo.130842.webp',
  '2024-05-01T00:00:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000001-0000-4000-8000-00000000',
  '200000000000-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/9b726410.Photo.181042.webp',
  '2024-05-01T00:00:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000002-0000-4000-8000-00000000',
  '200000000003-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Main plant died this winter. Two smaller plants inside it. Has mealy bugs issue',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/b5cfcc65.Photo.091617.webp',
  '2024-05-02T00:00:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000003-0000-4000-8000-00000000',
  '200000000004-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Needs a lot of bright light. Tolerate good amount of sunlight. Very dramatically. Losses leaves all the time.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/e7e7908a.Photo.112530.webp',
  '2024-05-02T13:25:36.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000004-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Started with 3 leaves',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  '2024-05-02T15:22:36.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000005-0000-4000-8000-00000000',
  '200000000006-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/71811a3c.Photo.133359.webp',
  '2024-05-02T15:34:05.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000006-0000-4000-8000-00000000',
  '200000000006-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Bulb. Responds to any change immediately',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/71811a3c.Photo.133359.webp',
  '2024-05-02T15:36:41.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000007-0000-4000-8000-00000000',
  '200000000006-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/71811a3c.Photo.133922.webp',
  '2024-05-02T15:39:27.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000008-0000-4000-8000-00000000',
  '200000000007-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Cutting from Sneha Kaushik. Started with 2 leaves.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/4420c9c2.Photo.104209.webp',
  '2024-05-03T12:42:17.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000009-0000-4000-8000-00000000',
  '200000000007-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Spider mites infested',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/7d3ed05e.Photo.104319.webp',
  '2024-05-03T12:42:30.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000010-0000-4000-8000-00000000',
  '200000000008-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Very Fragile',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/3a63e102.Photo.105025.webp',
  '2024-05-03T12:50:53.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000011-0000-4000-8000-00000000',
  '200000000008-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Fell off the hanging pot on 12 April. Repotted 15 days later',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/13c43e27.Photo.105238.webp',
  '2024-05-03T12:51:27.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000012-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-05-03T12:57:01.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000013-0000-4000-8000-00000000',
  '200000000010-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India. Grows fast. Needs support for vertical growth. Tolerates medium light.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d50ecf8e.Photo.110054.webp',
  '2024-05-03T13:01:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000014-0000-4000-8000-00000000',
  '200000000011-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b94f1816.Photo.110231.webp',
  '2024-05-03T13:02:38.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000015-0000-4000-8000-00000000',
  '200000000011-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b94f1816.Photo.110231.webp',
  '2024-05-03T13:02:48.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000016-0000-4000-8000-00000000',
  '200000000012-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Dramatic plant. Sensitive to everything. Goes dormant even if you sneeze.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e935766f.Photo.110422.webp',
  '2024-05-03T13:04:28.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000017-0000-4000-8000-00000000',
  '200000000013-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Similar to peace lily plant. Fully died during India visit. Back to life spring 2024. Gift from harika',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/14b47870.Photo.112055.webp',
  '2024-05-03T13:21:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000018-0000-4000-8000-00000000',
  '200000000014-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66de3e37.Photo.115908.webp',
  '2024-05-03T13:59:14.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000019-0000-4000-8000-00000000',
  '200000000015-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e64ecb86.Photo.134450.webp',
  '2024-05-03T15:44:58.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000020-0000-4000-8000-00000000',
  '200000000016-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Needs high humidity and more soil',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58e81d2a.Photo.140701.webp',
  '2024-05-03T16:07:09.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000021-0000-4000-8000-00000000',
  '200000000017-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d3ddcea.Photo.143018.webp',
  '2024-05-03T16:30:28.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000022-0000-4000-8000-00000000',
  '200000000018-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  NULL,
  '2024-05-03T16:32:04.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000023-0000-4000-8000-00000000',
  '200000000019-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  NULL,
  '2024-05-03T16:33:08.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000024-0000-4000-8000-00000000',
  '200000000020-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  NULL,
  '2024-05-03T16:39:49.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000025-0000-4000-8000-00000000',
  '200000000001-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Two leaves kept in water and once rooted were put in clay pot',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0b9099a5.Photo.154337.webp',
  '2024-05-03T17:43:42.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000026-0000-4000-8000-00000000',
  '200000000021-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b811ca6e.Photo.154448.webp',
  '2024-05-03T17:44:56.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000027-0000-4000-8000-00000000',
  '200000000022-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India. Wild growth. Easy',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/c86bb012.Photo.154804.webp',
  '2024-05-03T17:48:11.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000028-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-05-03T17:50:19.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000029-0000-4000-8000-00000000',
  '200000000024-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/6192551c.Photo.155204.webp',
  '2024-05-03T17:52:10.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000030-0000-4000-8000-00000000',
  '200000000024-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Low light Started with extremely small plant with 5 leaves.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/6192551c.Photo.155204.webp',
  '2024-05-03T17:53:58.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000031-0000-4000-8000-00000000',
  '200000000025-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'What metal pot. Neon and marble. No variegation',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0224cb40.Photo.155712.webp',
  '2024-05-03T17:57:17.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000032-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Bloomed',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/35d451ea.Photo.162259.webp',
  '2023-09-23T18:22:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000033-0000-4000-8000-00000000',
  '200000000026-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f0a4a78.Photo.173600.webp',
  '2024-05-03T19:36:08.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000034-0000-4000-8000-00000000',
  '200000000027-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/540f78d0.Photo.174038.webp',
  '2024-05-03T19:40:44.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000035-0000-4000-8000-00000000',
  '200000000018-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f696cf27.Photo.174143.webp',
  '2024-05-03T19:41:48.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000036-0000-4000-8000-00000000',
  '200000000019-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/22638d49.Photo.174159.webp',
  '2024-05-03T19:42:04.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000037-0000-4000-8000-00000000',
  '200000000020-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0ea955c6.Photo.174210.webp',
  '2024-05-03T19:42:15.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000038-0000-4000-8000-00000000',
  '200000000020-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'First new growth of the season',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/98d9c7fd.Photo.174229.webp',
  '2024-05-03T19:42:12.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000039-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  '2024-05-03T19:43:01.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000040-0000-4000-8000-00000000',
  '200000000028-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Full sunlight. Warm temperature. From India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/782aceb9.Photo.174926.webp',
  '2024-05-03T19:49:32.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000041-0000-4000-8000-00000000',
  '200000000029-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Goes fully dormant in winter. Report the remaining leaves in spring. From India.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e05a6cba.Photo.175454.webp',
  '2024-05-03T19:55:01.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000042-0000-4000-8000-00000000',
  '200000000030-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Needs extreme direct light and warmth. From India.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a26e2877.Photo.175712.webp',
  '2024-05-03T19:57:16.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000043-0000-4000-8000-00000000',
  '200000000031-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Newly recovering from winter repotting shock. Should not be touched during dormant time',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d1f91042.Photo.180338.webp',
  '2024-05-03T20:03:46.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000044-0000-4000-8000-00000000',
  '200000000032-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Damaged due to mealy bugs. Soaked in soap solution and repotted.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/798e70de.Photo.180401.webp',
  '2024-05-03T20:04:07.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000045-0000-4000-8000-00000000',
  '200000000033-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'cactus',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e0d01120.Photo.181153.webp',
  '2024-05-03T20:12:01.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000046-0000-4000-8000-00000000',
  '200000000034-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/deb5f154.Photo.181421.webp',
  '2024-05-03T20:14:26.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000047-0000-4000-8000-00000000',
  '200000000035-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India. Was in direct sunlight',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/69cb226b.Photo.181818.webp',
  '2024-05-03T20:18:25.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000048-0000-4000-8000-00000000',
  '200000000036-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Forms ash on plant',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f3d318c.Photo.181941.webp',
  '2024-05-03T20:19:46.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000049-0000-4000-8000-00000000',
  '200000000037-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Sowed seeds and have put in glass house',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e20757ec.Photo.182007.webp',
  '2024-05-03T20:20:13.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000050-0000-4000-8000-00000000',
  '200000000038-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Planned from propagation box. In greenhouse atmosphere',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a3e45ea5.Photo.182906.webp',
  '2024-05-03T20:29:12.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000051-0000-4000-8000-00000000',
  '200000000039-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Attempt to save the plant',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b315e84f.Photo.183201.webp',
  '2024-05-03T20:32:07.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000052-0000-4000-8000-00000000',
  '200000000040-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Indian banyan plant.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/ef97823a.Photo.183337.webp',
  '2024-05-03T20:33:44.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000053-0000-4000-8000-00000000',
  '200000000041-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Goes dormant in winter. Needs full sun to become pink',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/40ce622d.Photo.184039.webp',
  '2024-05-03T20:40:44.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000054-0000-4000-8000-00000000',
  '200000000042-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Main plant was infested by scales. Branches were cut off and repotted. Like outdoor weather.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/ace543c8.Photo.184425.webp',
  '2024-05-03T20:44:30.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000055-0000-4000-8000-00000000',
  '200000000043-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Old plant killed by mealy bugs. New cuttings taken from India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/6a8db0df.Photo.184632.webp',
  '2024-05-03T20:46:44.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000056-0000-4000-8000-00000000',
  '200000000044-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Picked up from arbs et fleur and rooted.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/6e817bae.Photo.184717.webp',
  '2024-05-03T20:47:22.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000057-0000-4000-8000-00000000',
  '200000000045-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Bought from Sunday market in Charleroi. Have cut the branches to try propagation and strengthen the base',
  NULL,
  '2024-05-03T20:51:33.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000058-0000-4000-8000-00000000',
  '200000000046-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Gets pink flowers. Needs full sun. Seems to be sick',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/3fe0fded.Photo.185156.webp',
  '2024-05-03T20:52:02.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000059-0000-4000-8000-00000000',
  '200000000047-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Cut branches for propagation',
  NULL,
  '2024-05-03T20:52:42.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000060-0000-4000-8000-00000000',
  '200000000045-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Bought from Sunday market in Charleroi. Have cut the branches to try propagation and strengthen the base',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/5f550da7.Photo.185243.webp',
  '2024-05-03T20:52:48.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000061-0000-4000-8000-00000000',
  '200000000047-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Cut branches for propagation',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/277b1a85.Photo.185339.webp',
  '2024-05-03T20:53:46.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000062-0000-4000-8000-00000000',
  '200000000048-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From crl market. Needs full sun',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0fe4036b.Photo.185551.webp',
  '2024-05-03T20:55:56.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000063-0000-4000-8000-00000000',
  '200000000049-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Wedding gift by Billy Vivian. Pruned every spring for stronger growth. Has scale issues. Thunderstorm had strong impact.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0008842e.Photo.072546.webp',
  '2024-05-04T09:25:54.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000064-0000-4000-8000-00000000',
  '200000000050-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/72c362c7.Photo.072731.webp',
  '2024-05-04T09:27:40.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000065-0000-4000-8000-00000000',
  '200000000051-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Mix of plants for winter season.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f373280f.Photo.073357.webp',
  '2024-05-04T09:34:05.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000066-0000-4000-8000-00000000',
  '200000000052-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Summer mix plants',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/13ac7a2c.Photo.073440.webp',
  '2024-05-04T09:34:48.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000067-0000-4000-8000-00000000',
  '200000000053-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Needs high humidity and moist soil. Gift.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/40a2efcb.Photo.133221.webp',
  '2024-05-05T15:32:28.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000068-0000-4000-8000-00000000',
  '200000000054-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'High humidity. High water',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/736fdf42.Photo.134239.webp',
  '2024-05-05T15:42:46.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000069-0000-4000-8000-00000000',
  '200000000055-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Was bigger. Dried out due to low humidity',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/350d9488.Photo.134559.webp',
  '2024-05-05T15:46:03.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000070-0000-4000-8000-00000000',
  '200000000056-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Reacts well to light. Needs humidity.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/7e351c37.Photo.134742.webp',
  '2024-05-05T15:47:48.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000071-0000-4000-8000-00000000',
  '200000000057-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'High humidity and bright light. Needs moss pole support.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/ce5d720f.Photo.140024.webp',
  '2024-05-05T16:00:31.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000072-0000-4000-8000-00000000',
  '200000000058-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Needs humidity. Plant is in stress. Leaves curl in stress and low humidity. Trying to fix.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/610324a2.Photo.141809.webp',
  '2024-05-05T16:18:16.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000073-0000-4000-8000-00000000',
  '200000000058-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/bf526daf.Photo.142035.webp',
  '2024-05-05T16:19:48.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000074-0000-4000-8000-00000000',
  '200000000059-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/dce08b43.Photo.142426.webp',
  '2024-05-05T16:24:33.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000075-0000-4000-8000-00000000',
  '200000000060-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1bd8a03d.Photo.142752.webp',
  '2024-05-05T16:27:57.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000076-0000-4000-8000-00000000',
  '200000000061-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1afb00dc.Photo.143552.webp',
  '2024-05-05T16:36:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000077-0000-4000-8000-00000000',
  '200000000062-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Cutting from original',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/039a107a.Photo.143956.webp',
  '2024-05-05T16:40:02.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000078-0000-4000-8000-00000000',
  '200000000063-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Slow plant',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1a334068.Photo.144401.webp',
  '2024-05-05T16:44:07.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000079-0000-4000-8000-00000000',
  '200000000064-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From krushna',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1bf88c75.Photo.144659.webp',
  '2024-05-05T16:47:05.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000080-0000-4000-8000-00000000',
  '200000000065-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Neon pothos, marble pothos, golden pothos',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/196f1def.Photo.145221.webp',
  '2024-05-05T16:52:28.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000081-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-05-05T16:55:18.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000082-0000-4000-8000-00000000',
  '200000000067-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India. Started with 2 leaves',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9b46e90f.Photo.151457.webp',
  '2024-05-05T17:15:06.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000083-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.151706.webp',
  '2024-05-05T17:17:12.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000084-0000-4000-8000-00000000',
  '200000000069-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Not doing well',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b03542f0.Photo.152014.webp',
  '2024-05-05T17:20:21.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000085-0000-4000-8000-00000000',
  '200000000070-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Also contains non variegated weeping pig',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d31a645.Photo.152212.webp',
  '2024-05-05T17:22:18.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000086-0000-4000-8000-00000000',
  '200000000071-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/741a7847.Photo.152455.webp',
  '2024-05-05T17:25:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000087-0000-4000-8000-00000000',
  '200000000072-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Pothos golden and neon. Repotted after original plant went into shock.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8d3bf7e7.Photo.152807.webp',
  '2024-05-05T17:28:13.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000088-0000-4000-8000-00000000',
  '200000000073-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Keeping marble pothos in separate pot as it needs more light compared to others.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/df38dce9.Photo.152936.webp',
  '2024-05-05T17:29:42.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000089-0000-4000-8000-00000000',
  '200000000074-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Slow',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e16d475a.Photo.153049.webp',
  '2024-05-05T17:30:56.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000090-0000-4000-8000-00000000',
  '200000000075-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Needs cleanup every spring',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/927dd3eb.Photo.153942.webp',
  '2024-05-05T17:39:51.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000091-0000-4000-8000-00000000',
  '200000000076-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a1763e7c.Photo.154103.webp',
  '2024-05-05T17:41:09.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000092-0000-4000-8000-00000000',
  '200000000077-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Neon, golden',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/4d04068a.Photo.154256.webp',
  '2024-05-05T17:43:01.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000093-0000-4000-8000-00000000',
  '200000000078-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Less water',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e8a64f31.Photo.154439.webp',
  '2024-05-05T17:44:47.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000094-0000-4000-8000-00000000',
  '200000000079-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Main plant dead. This one under high control',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9a2674d7.Photo.154559.webp',
  '2024-05-05T17:46:06.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000095-0000-4000-8000-00000000',
  '200000000077-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/1f9fd69e.Photo.154642.webp',
  '2024-05-05T17:46:33.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000096-0000-4000-8000-00000000',
  '200000000031-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/61032dfc.Photo.154727.webp',
  '2024-05-05T17:47:08.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000097-0000-4000-8000-00000000',
  '200000000080-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India. Assumed to be a monstera. But it was pothos. Only one leaf survived propagation stage',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/62019b5f.Photo.155656.webp',
  '2024-05-05T17:57:05.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000098-0000-4000-8000-00000000',
  '200000000081-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Didn’t die doesn’t survive. New location with good light seems to be working',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/2b17b367.Photo.155929.webp',
  '2024-05-05T17:59:34.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000099-0000-4000-8000-00000000',
  '200000000081-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/a4bc8c2f.Photo.160118.webp',
  '2024-05-05T18:01:05.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000100-0000-4000-8000-00000000',
  '200000000082-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/08d3f531.Photo.160349.webp',
  '2024-05-05T18:03:55.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000101-0000-4000-8000-00000000',
  '200000000083-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  NULL,
  '2024-05-05T18:05:09.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000102-0000-4000-8000-00000000',
  '200000000084-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Golden, silvery Anne, marble, neon',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/4149d31f.Photo.160633.webp',
  '2024-05-05T18:06:38.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000103-0000-4000-8000-00000000',
  '200000000083-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9961c4c0.Photo.160648.webp',
  '2024-05-05T18:06:54.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000104-0000-4000-8000-00000000',
  '200000000085-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/74120824.Photo.160829.webp',
  '2024-05-05T18:08:36.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000105-0000-4000-8000-00000000',
  '200000000086-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cecfd7e0.Photo.160944.webp',
  '2024-05-05T18:09:50.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000106-0000-4000-8000-00000000',
  '200000000087-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/623ab1ce.Photo.161011.webp',
  '2024-05-05T18:10:17.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000107-0000-4000-8000-00000000',
  '200000000088-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/fc6b71d3.Photo.161035.webp',
  '2024-05-05T18:10:40.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000108-0000-4000-8000-00000000',
  '200000000003-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Main plant died this winter. Two smaller plants inside it. Has mealy bugs issue',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b5cfcc65.Photo.063945.webp',
  '2024-05-08T08:39:50.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000109-0000-4000-8000-00000000',
  '200000000057-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'New support added',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/89551b69.Photo.120738.webp',
  '2024-05-09T14:06:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000110-0000-4000-8000-00000000',
  '200000000037-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Sowed seeds and have put in glass house',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e20757ec.Photo.052016.webp',
  '2024-05-15T07:20:22.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000111-0000-4000-8000-00000000',
  '200000000021-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b811ca6e.Photo.154448.webp',
  '2024-05-15T08:34:12.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000112-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-05-15T08:34:27.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000113-0000-4000-8000-00000000',
  '200000000021-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b811ca6e.Photo.154448.webp',
  '2024-05-15T08:37:38.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000114-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-05-15T08:37:47.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000115-0000-4000-8000-00000000',
  '200000000027-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/540f78d0.Photo.174038.webp',
  '2024-05-15T08:39:13.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000116-0000-4000-8000-00000000',
  '200000000000-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/9b726410.Photo.181042.webp',
  '2024-05-15T08:42:48.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000117-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  '2024-05-15T08:42:56.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000118-0000-4000-8000-00000000',
  '200000000015-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e64ecb86.Photo.134450.webp',
  '2024-05-15T08:43:09.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000119-0000-4000-8000-00000000',
  '200000000017-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d3ddcea.Photo.143018.webp',
  '2024-05-15T08:44:09.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000120-0000-4000-8000-00000000',
  '200000000018-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f696cf27.Photo.174143.webp',
  '2024-05-15T08:44:28.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000121-0000-4000-8000-00000000',
  '200000000019-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/22638d49.Photo.174159.webp',
  '2024-05-15T08:44:49.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000122-0000-4000-8000-00000000',
  '200000000020-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0ea955c6.Photo.174210.webp',
  '2024-05-15T08:44:57.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000123-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-05-15T08:46:04.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000124-0000-4000-8000-00000000',
  '200000000059-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/dce08b43.Photo.142426.webp',
  '2024-05-15T08:46:39.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000125-0000-4000-8000-00000000',
  '200000000061-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1afb00dc.Photo.143552.webp',
  '2024-05-15T08:46:50.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000126-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-05-15T08:47:17.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000127-0000-4000-8000-00000000',
  '200000000060-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Pruned and repotted in same pot soil',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/cb55b975.Photo.122931.webp',
  '2024-05-15T14:28:21.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000128-0000-4000-8000-00000000',
  '200000000021-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b811ca6e.Photo.154448.webp',
  '2024-05-17T07:26:20.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000129-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-05-17T07:26:33.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000130-0000-4000-8000-00000000',
  '200000000000-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/9b726410.Photo.181042.webp',
  '2024-05-17T07:26:50.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000131-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  '2024-05-17T07:26:57.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000132-0000-4000-8000-00000000',
  '200000000015-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e64ecb86.Photo.134450.webp',
  '2024-05-17T07:27:05.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000133-0000-4000-8000-00000000',
  '200000000017-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d3ddcea.Photo.143018.webp',
  '2024-05-17T07:27:11.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000134-0000-4000-8000-00000000',
  '200000000018-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f696cf27.Photo.174143.webp',
  '2024-05-17T07:27:17.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000135-0000-4000-8000-00000000',
  '200000000019-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/22638d49.Photo.174159.webp',
  '2024-05-17T07:27:24.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000136-0000-4000-8000-00000000',
  '200000000020-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0ea955c6.Photo.174210.webp',
  '2024-05-17T07:27:30.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000137-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-05-17T07:27:52.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000138-0000-4000-8000-00000000',
  '200000000059-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/dce08b43.Photo.142426.webp',
  '2024-05-17T07:28:24.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000139-0000-4000-8000-00000000',
  '200000000061-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1afb00dc.Photo.143552.webp',
  '2024-05-17T07:28:35.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000140-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-05-17T07:29:04.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000141-0000-4000-8000-00000000',
  '200000000085-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/74120824.Photo.160829.webp',
  '2024-05-17T15:52:17.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000142-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-05-17T15:52:38.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000143-0000-4000-8000-00000000',
  '200000000061-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1afb00dc.Photo.143552.webp',
  '2024-05-17T20:08:17.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000144-0000-4000-8000-00000000',
  '200000000059-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/dce08b43.Photo.142426.webp',
  '2024-05-17T20:08:58.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000145-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-05-17T20:10:53.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000146-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  '2024-05-17T20:11:41.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000147-0000-4000-8000-00000000',
  '200000000015-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e64ecb86.Photo.134450.webp',
  '2024-05-17T20:11:52.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000148-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-05-17T20:12:52.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000149-0000-4000-8000-00000000',
  '200000000027-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/540f78d0.Photo.174038.webp',
  '2024-05-17T20:13:43.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000150-0000-4000-8000-00000000',
  '200000000014-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66de3e37.Photo.115908.webp',
  '2024-05-17T20:14:53.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000151-0000-4000-8000-00000000',
  '200000000026-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f0a4a78.Photo.173600.webp',
  '2024-05-17T20:54:17.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000152-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.151706.webp',
  '2024-05-17T20:57:13.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000153-0000-4000-8000-00000000',
  '200000000071-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/741a7847.Photo.152455.webp',
  '2024-05-17T20:58:37.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000154-0000-4000-8000-00000000',
  '200000000086-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cecfd7e0.Photo.160944.webp',
  '2024-05-17T21:33:24.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000155-0000-4000-8000-00000000',
  '200000000087-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/623ab1ce.Photo.161011.webp',
  '2024-05-17T21:33:37.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000156-0000-4000-8000-00000000',
  '200000000088-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/fc6b71d3.Photo.161035.webp',
  '2024-05-17T21:33:49.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000157-0000-4000-8000-00000000',
  '200000000076-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a1763e7c.Photo.154103.webp',
  '2024-05-17T21:34:12.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000158-0000-4000-8000-00000000',
  '200000000050-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/72c362c7.Photo.072731.webp',
  '2024-05-17T21:35:06.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000159-0000-4000-8000-00000000',
  '200000000082-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/08d3f531.Photo.160349.webp',
  '2024-05-17T21:35:31.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000160-0000-4000-8000-00000000',
  '200000000047-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Cut branches for propagation',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/277b1a85.Photo.060709.webp',
  '2024-05-22T08:07:15.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000161-0000-4000-8000-00000000',
  '200000000007-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Cutting from Sneha Kaushik. Started with 2 leaves.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/4420c9c2.Photo.104209.webp',
  '2024-05-25T15:32:17.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000162-0000-4000-8000-00000000',
  '200000000058-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Needs humidity. Plant is in stress. Leaves curl in stress and low humidity. Trying to fix.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/610324a2.Photo.133422.webp',
  '2024-05-25T15:34:26.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000163-0000-4000-8000-00000000',
  '200000000058-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Prepared a garlic packet based moss pole filled with coco chunks. Added all silvery ann to the pot',
  NULL,
  '2024-05-25T15:34:52.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000164-0000-4000-8000-00000000',
  '200000000089-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e66ca1e6.Photo.134304.webp',
  '2024-05-25T15:43:08.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000165-0000-4000-8000-00000000',
  '200000000021-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b811ca6e.Photo.154448.webp',
  '2024-05-30T12:21:15.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000166-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-05-30T12:21:32.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000167-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-06-02T20:31:28.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000168-0000-4000-8000-00000000',
  '200000000085-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/74120824.Photo.160829.webp',
  '2024-06-02T20:31:47.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000169-0000-4000-8000-00000000',
  '200000000000-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/9b726410.Photo.181042.webp',
  '2024-06-02T20:31:54.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000170-0000-4000-8000-00000000',
  '200000000018-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f696cf27.Photo.174143.webp',
  '2024-06-02T20:32:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000171-0000-4000-8000-00000000',
  '200000000015-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e64ecb86.Photo.134450.webp',
  '2024-06-02T20:32:07.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000172-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  '2024-06-02T20:32:14.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000173-0000-4000-8000-00000000',
  '200000000017-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d3ddcea.Photo.143018.webp',
  '2024-06-02T20:32:19.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000174-0000-4000-8000-00000000',
  '200000000020-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0ea955c6.Photo.174210.webp',
  '2024-06-02T20:32:32.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000175-0000-4000-8000-00000000',
  '200000000019-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/22638d49.Photo.174159.webp',
  '2024-06-02T20:32:45.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000176-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-06-02T20:32:51.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000177-0000-4000-8000-00000000',
  '200000000059-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/dce08b43.Photo.142426.webp',
  '2024-06-02T20:33:56.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000178-0000-4000-8000-00000000',
  '200000000061-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1afb00dc.Photo.143552.webp',
  '2024-06-02T20:34:14.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000179-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-06-02T20:34:32.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000180-0000-4000-8000-00000000',
  '200000000027-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/540f78d0.Photo.174038.webp',
  '2024-06-02T20:34:49.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000181-0000-4000-8000-00000000',
  '200000000026-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f0a4a78.Photo.173600.webp',
  '2024-06-02T20:35:29.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000182-0000-4000-8000-00000000',
  '200000000014-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66de3e37.Photo.115908.webp',
  '2024-06-02T20:38:33.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000183-0000-4000-8000-00000000',
  '200000000089-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e66ca1e6.Photo.134304.webp',
  '2024-06-02T20:39:58.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000184-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.151706.webp',
  '2024-06-02T20:40:17.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000185-0000-4000-8000-00000000',
  '200000000071-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/741a7847.Photo.152455.webp',
  '2024-06-02T20:40:44.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000186-0000-4000-8000-00000000',
  '200000000087-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/623ab1ce.Photo.161011.webp',
  '2024-06-02T20:41:03.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000187-0000-4000-8000-00000000',
  '200000000086-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cecfd7e0.Photo.160944.webp',
  '2024-06-02T20:41:14.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000188-0000-4000-8000-00000000',
  '200000000076-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a1763e7c.Photo.154103.webp',
  '2024-06-02T20:41:27.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000189-0000-4000-8000-00000000',
  '200000000088-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/fc6b71d3.Photo.161035.webp',
  '2024-06-02T20:41:56.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000190-0000-4000-8000-00000000',
  '200000000082-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/08d3f531.Photo.160349.webp',
  '2024-06-02T20:42:19.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000191-0000-4000-8000-00000000',
  '200000000050-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/72c362c7.Photo.072731.webp',
  '2024-06-02T20:42:35.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000192-0000-4000-8000-00000000',
  '200000000083-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9961c4c0.Photo.160648.webp',
  '2024-06-02T20:42:48.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000193-0000-4000-8000-00000000',
  '200000000077-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Repotted and rearranged vines',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/534341f7.Photo.184824.webp',
  '2024-06-01T20:47:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000194-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  NULL,
  '2024-06-04T18:59:15.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000195-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.151706.webp',
  '2024-06-04T19:00:34.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000196-0000-4000-8000-00000000',
  '200000000078-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Less water',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e8a64f31.Photo.154439.webp',
  '2024-06-05T12:32:14.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000197-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-06-05T12:35:17.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000198-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-06-05T12:37:47.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000199-0000-4000-8000-00000000',
  '200000000032-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Damaged due to mealy bugs. Soaked in soap solution and repotted.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/798e70de.Photo.180401.webp',
  '2024-06-05T12:39:03.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000200-0000-4000-8000-00000000',
  '200000000011-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b94f1816.Photo.110231.webp',
  '2024-06-05T12:56:04.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000201-0000-4000-8000-00000000',
  '200000000085-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/74120824.Photo.160829.webp',
  '2024-06-29T08:58:08.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000202-0000-4000-8000-00000000',
  '200000000021-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b811ca6e.Photo.154448.webp',
  '2024-06-29T08:58:29.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000203-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-06-29T08:58:43.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000204-0000-4000-8000-00000000',
  '200000000001-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Repotted into new action pot. Needs plate.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/5ba30057.Photo.192225.webp',
  '2024-07-06T21:21:42.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000205-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Root bound. Change to bigger pot',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/f4e99e12.Photo.193731.webp',
  '2024-07-06T21:37:10.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000206-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.070148.webp',
  '2024-07-08T09:01:53.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000207-0000-4000-8000-00000000',
  '200000000085-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/74120824.Photo.160829.webp',
  '2024-07-20T14:54:45.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000208-0000-4000-8000-00000000',
  '200000000021-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b811ca6e.Photo.154448.webp',
  '2024-07-20T14:55:13.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000209-0000-4000-8000-00000000',
  '200000000023-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b0c9fb14.Photo.155012.webp',
  '2024-07-20T14:55:35.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000210-0000-4000-8000-00000000',
  '200000000000-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/9b726410.Photo.181042.webp',
  '2024-07-20T14:56:12.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000211-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  '2024-07-20T14:56:20.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000212-0000-4000-8000-00000000',
  '200000000015-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e64ecb86.Photo.134450.webp',
  '2024-07-20T14:56:31.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000213-0000-4000-8000-00000000',
  '200000000017-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d3ddcea.Photo.143018.webp',
  '2024-07-20T14:56:42.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000214-0000-4000-8000-00000000',
  '200000000018-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f696cf27.Photo.174143.webp',
  '2024-07-20T14:56:53.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000215-0000-4000-8000-00000000',
  '200000000019-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/22638d49.Photo.174159.webp',
  '2024-07-20T14:57:03.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000216-0000-4000-8000-00000000',
  '200000000020-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0ea955c6.Photo.174210.webp',
  '2024-07-20T14:57:11.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000217-0000-4000-8000-00000000',
  '200000000059-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/dce08b43.Photo.142426.webp',
  '2024-07-20T14:58:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000218-0000-4000-8000-00000000',
  '200000000061-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1afb00dc.Photo.143552.webp',
  '2024-07-20T14:58:16.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000219-0000-4000-8000-00000000',
  '200000000014-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66de3e37.Photo.115908.webp',
  '2024-07-20T14:59:45.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000220-0000-4000-8000-00000000',
  '200000000026-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f0a4a78.Photo.173600.webp',
  '2024-07-20T14:59:52.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000221-0000-4000-8000-00000000',
  '200000000027-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/540f78d0.Photo.174038.webp',
  '2024-07-20T14:59:58.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000222-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-07-20T15:02:29.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000223-0000-4000-8000-00000000',
  '200000000089-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e66ca1e6.Photo.134304.webp',
  '2024-07-20T15:02:37.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000224-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-07-20T15:02:45.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000225-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.070148.webp',
  '2024-07-20T15:02:58.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000226-0000-4000-8000-00000000',
  '200000000071-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/741a7847.Photo.152455.webp',
  '2024-07-20T15:03:14.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000227-0000-4000-8000-00000000',
  '200000000086-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cecfd7e0.Photo.160944.webp',
  '2024-07-20T15:03:52.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000228-0000-4000-8000-00000000',
  '200000000087-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/623ab1ce.Photo.161011.webp',
  '2024-07-20T15:04:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000229-0000-4000-8000-00000000',
  '200000000088-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/fc6b71d3.Photo.161035.webp',
  '2024-07-20T15:04:27.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000230-0000-4000-8000-00000000',
  '200000000076-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a1763e7c.Photo.154103.webp',
  '2024-07-20T15:04:43.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000231-0000-4000-8000-00000000',
  '200000000082-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/08d3f531.Photo.160349.webp',
  '2024-07-20T15:05:02.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000232-0000-4000-8000-00000000',
  '200000000050-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/72c362c7.Photo.072731.webp',
  '2024-07-20T15:05:23.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000233-0000-4000-8000-00000000',
  '200000000083-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9961c4c0.Photo.160648.webp',
  '2024-07-20T16:06:55.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000234-0000-4000-8000-00000000',
  '200000000000-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Team_Images/9b726410.Photo.181042.webp',
  '2024-07-24T09:12:55.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000235-0000-4000-8000-00000000',
  '200000000015-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e64ecb86.Photo.134450.webp',
  '2024-07-24T09:13:03.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000236-0000-4000-8000-00000000',
  '200000000083-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9961c4c0.Photo.160648.webp',
  '2024-07-24T09:13:44.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000237-0000-4000-8000-00000000',
  '200000000060-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Cut and put back. Some were split',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/cc7d0a84.Photo.071350.webp',
  '2024-07-20T14:57:03.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000238-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/58d946bb.Photo.132230.webp',
  '2024-07-24T09:13:57.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000239-0000-4000-8000-00000000',
  '200000000090-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Split and put from plant 1',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66ad913a.Photo.071356.webp',
  '2024-07-24T09:14:02.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000240-0000-4000-8000-00000000',
  '200000000062-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/d4ada3e9.Photo.071403.webp',
  '2024-07-20T14:58:37.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000241-0000-4000-8000-00000000',
  '200000000017-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9d3ddcea.Photo.143018.webp',
  '2024-07-24T09:14:08.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000242-0000-4000-8000-00000000',
  '200000000057-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/9c9add79.Photo.071409.webp',
  '2024-07-20T14:59:31.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000243-0000-4000-8000-00000000',
  '200000000018-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/f696cf27.Photo.174143.webp',
  '2024-07-24T09:14:16.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000244-0000-4000-8000-00000000',
  '200000000034-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/deb5f154.Photo.071414.webp',
  '2024-07-24T09:14:19.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000245-0000-4000-8000-00000000',
  '200000000091-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Split from original',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0d850ff0.Photo.071424.webp',
  '2024-07-24T09:14:29.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000246-0000-4000-8000-00000000',
  '200000000020-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/0ea955c6.Photo.174210.webp',
  '2024-07-24T09:14:29.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000247-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-07-24T09:14:32.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000248-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-07-24T09:14:40.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000249-0000-4000-8000-00000000',
  '200000000071-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Excessive loss of plants happened',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/26a52d2f.Photo.071446.webp',
  '2024-07-20T15:05:17.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000250-0000-4000-8000-00000000',
  '200000000090-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Split and put from plant 1',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66ad913a.Photo.071356.webp',
  '2024-07-24T09:16:25.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000251-0000-4000-8000-00000000',
  '200000000019-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/22638d49.Photo.174159.webp',
  '2024-07-24T09:19:01.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000252-0000-4000-8000-00000000',
  '200000000059-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/dce08b43.Photo.142426.webp',
  '2024-07-25T13:54:34.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000253-0000-4000-8000-00000000',
  '200000000061-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1afb00dc.Photo.143552.webp',
  '2024-07-25T13:55:09.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000254-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.151706.webp',
  '2024-07-25T13:55:39.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000255-0000-4000-8000-00000000',
  '200000000027-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/540f78d0.Photo.174038.webp',
  '2024-07-25T13:56:06.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000256-0000-4000-8000-00000000',
  '200000000034-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/deb5f154.Photo.181421.webp',
  '2024-07-25T13:56:45.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000257-0000-4000-8000-00000000',
  '200000000026-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f0a4a78.Photo.173600.webp',
  '2024-07-25T13:57:00.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000258-0000-4000-8000-00000000',
  '200000000014-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/66de3e37.Photo.115908.webp',
  '2024-07-25T13:57:21.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000259-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-07-25T14:01:07.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000260-0000-4000-8000-00000000',
  '200000000078-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Complete soil change. Balls at the bottom. Lot of rotten roots',
  NULL,
  '2024-08-31T10:31:32.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000261-0000-4000-8000-00000000',
  '200000000005-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Trimmed and added back',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/89c2d90d.Photo.083347.webp',
  '2024-08-31T10:33:09.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000262-0000-4000-8000-00000000',
  '200000000012-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'No more leaves.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/b43052db.Photo.083519.webp',
  '2024-08-31T10:34:50.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000263-0000-4000-8000-00000000',
  '200000000068-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b58a2a62.Photo.151706.webp',
  '2024-08-31T10:36:16.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000264-0000-4000-8000-00000000',
  '200000000055-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Was bigger. Dried out due to low humidity',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/350d9488.Photo.134559.webp',
  '2024-08-31T10:37:34.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000265-0000-4000-8000-00000000',
  '200000000055-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Log_Images/06564cdf.Photo.083800.webp',
  '2024-08-31T10:37:37.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000266-0000-4000-8000-00000000',
  '200000000057-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'High humidity and bright light. Needs moss pole support.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/ce5d720f.Photo.140024.webp',
  '2024-08-31T10:38:55.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000267-0000-4000-8000-00000000',
  '200000000092-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Two bulbs taken out of the existing plant',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/1c2ddb5d.Photo.084036.webp',
  '2024-08-31T10:40:45.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000268-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-09-21T15:42:17.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000269-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-09-21T15:42:25.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000270-0000-4000-8000-00000000',
  '200000000089-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e66ca1e6.Photo.134304.webp',
  '2024-09-21T15:42:32.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000271-0000-4000-8000-00000000',
  '200000000036-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Forms ash on plant',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f3d318c.Photo.181941.webp',
  '2024-09-22T10:53:30.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000272-0000-4000-8000-00000000',
  '200000000037-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Sowed seeds and have put in glass house',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/e20757ec.Photo.052016.webp',
  '2024-09-22T10:53:53.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000273-0000-4000-8000-00000000',
  '200000000042-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Main plant was infested by scales. Branches were cut off and repotted. Like outdoor weather.',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/ace543c8.Photo.184425.webp',
  '2024-09-22T10:54:13.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000274-0000-4000-8000-00000000',
  '200000000066-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cc94c276.Photo.145512.webp',
  '2024-09-22T10:54:48.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000275-0000-4000-8000-00000000',
  '200000000034-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/deb5f154.Photo.181421.webp',
  '2024-09-22T10:56:22.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000276-0000-4000-8000-00000000',
  '200000000009-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/d92accf7.Photo.105655.webp',
  '2024-09-22T10:56:41.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000277-0000-4000-8000-00000000',
  '200000000067-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'From India. Started with 2 leaves',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/9b46e90f.Photo.151457.webp',
  '2024-09-22T10:57:21.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000278-0000-4000-8000-00000000',
  '200000000093-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'After cutting the umbrella, let the branches in water for some days and now moved to soil',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a4483f88.Photo.085903.webp',
  '2024-09-22T10:59:13.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000279-0000-4000-8000-00000000',
  '200000000036-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Two rose bushes in one',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/8f3d318c.Photo.090022.webp',
  '2024-09-22T11:00:31.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000280-0000-4000-8000-00000000',
  '200000000094-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/b7cc617b.Photo.090118.webp',
  '2024-09-22T11:01:26.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000281-0000-4000-8000-00000000',
  '200000000071-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/741a7847.Photo.152455.webp',
  '2024-09-22T22:48:45.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000282-0000-4000-8000-00000000',
  '200000000087-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/623ab1ce.Photo.161011.webp',
  '2024-09-26T13:13:37.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000283-0000-4000-8000-00000000',
  '200000000088-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/fc6b71d3.Photo.161035.webp',
  '2024-09-26T13:13:57.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000284-0000-4000-8000-00000000',
  '200000000086-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/cecfd7e0.Photo.160944.webp',
  '2024-09-26T13:14:19.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000285-0000-4000-8000-00000000',
  '200000000082-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/08d3f531.Photo.160349.webp',
  '2024-11-09T01:18:53.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000286-0000-4000-8000-00000000',
  '200000000082-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/08d3f531.Photo.160349.webp',
  '2025-04-27T21:11:24.999Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000287-0000-4000-8000-00000000',
  '200000000076-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/a1763e7c.Photo.154103.webp',
  '2025-04-27T21:11:32.000Z'
);
INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '300000000288-0000-4000-8000-00000000',
  '200000000050-0000-4000-8000-00000000',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  'Diary entry',
  'https://hyjdkviqmxkfpgspxljh.supabase.co/storage/v1/object/public/plant-images/Plants_Images/72c362c7.Photo.072731.webp',
  '2025-04-27T21:11:48.999Z'
);

-- Migration complete!
-- Summary:
--   Zones: 14
--   Plants: 95
--   Diary Entries: 289 (17 skipped - plant not found)
