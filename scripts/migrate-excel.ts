import * as XLSX from 'xlsx';
import { createClient } from '@supabase/supabase-js';
import * as path from 'path';
import * as dotenv from 'dotenv';

// Load environment variables
dotenv.config({ path: '.env.local' });

// Initialize Supabase client
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
const supabase = createClient(supabaseUrl, supabaseKey);

interface TeamRow {
  ID: string;
  'Common Name': string;
  Description: string;
  Positioning: string;
  Photo: string;
  'Date planted': string;
  Cost: string;
  Added: string;
  Remarks: string;
}

interface ResourceRow {
  ID: string;
  Title: string;
  Description: string;
  Image: string;
  Lighting: string;
}

interface LogRow {
  ID: string;
  'Common Name': string;
  'Date Modified': string;
  Photo: string;
  Remarks: string;
  Positioning: string;
}

async function migrateData() {
  try {
    console.log('🌱 Starting Plant Directory migration...\n');

    // Read the Excel file
    const filePath = path.join(process.cwd(), 'Plant Directory.xlsx');
    const workbook = XLSX.readFile(filePath);

    // Read sheets
    const teamSheet = workbook.Sheets['Team'];
    const resourcesSheet = workbook.Sheets['Resources'];
    const logSheet = workbook.Sheets['Log'];

    const teamData: TeamRow[] = XLSX.utils.sheet_to_json(teamSheet);
    const resourcesData: ResourceRow[] = XLSX.utils.sheet_to_json(resourcesSheet);
    const logData: LogRow[] = XLSX.utils.sheet_to_json(logSheet);

    console.log(`📊 Found ${resourcesData.length} zones, ${teamData.length} plants, ${logData.length} log entries\n`);

    // Get or create a home (using the first available home)
    let homeId: string;
    const { data: existingHomes } = await supabase
      .from('homes')
      .select('id, name')
      .limit(1);

    if (existingHomes && existingHomes.length > 0) {
      homeId = existingHomes[0].id;
      console.log(`🏠 Using existing home: ${existingHomes[0].name} (${homeId})\n`);
    } else {
      // Create a default home for migration
      console.log('🏠 No existing home found, creating "My House"...');
      // Get current user to set as owner
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        console.error('❌ No authenticated user found');
        return;
      }

      const { data: newHome, error: homeError } = await supabase
        .from('homes')
        .insert({ 
          name: 'My House',
          owner_id: user.id,
          description: 'Migrated from Plant Directory Excel'
        })
        .select()
        .single();

      if (homeError || !newHome) {
        console.error('❌ Error creating home:', homeError);
        return;
      }
      homeId = newHome.id;
      console.log(`🏠 Created new home: ${newHome.name} (${homeId})\n`);
    }

    // Step 1: Migrate Zones (Resources)
    console.log('📍 Migrating zones...');
    const zoneIdMap = new Map<string, string>(); // old ID -> new UUID

    for (const resource of resourcesData) {
      const { data: zone, error } = await supabase
        .from('zones')
        .insert({
          home_id: homeId,
          name: resource.Title || 'Unnamed Zone',
          description: resource.Description || null,
          image_url: resource.Image || null, // Google Drive URL
        })
        .select()
        .single();

      if (error) {
        console.error(`  ❌ Error inserting zone "${resource.Title}":`, error.message);
      } else {
        zoneIdMap.set(resource.ID, zone.id);
        console.log(`  ✅ Migrated zone: ${resource.Title}`);
      }
    }

    console.log(`\n✅ Migrated ${zoneIdMap.size}/${resourcesData.length} zones\n`);

    // Step 2: Migrate Plants (Team)
    console.log('🌿 Migrating plants...');
    const plantIdMap = new Map<string, string>(); // old ID -> new UUID

    for (const plant of teamData) {
      // Find the zone ID
      const zoneId = zoneIdMap.get(plant.Positioning);
      if (!zoneId) {
        console.log(`  ⚠️  Skipping plant "${plant['Common Name']}" - zone not found`);
        continue;
      }

      const { data: newPlant, error } = await supabase
        .from('plants')
        .insert({
          zone_id: zoneId,
          name: plant['Common Name'] || 'Unknown Plant',
          species: null,
          description: plant.Description || null,
          acquisition_date: plant['Date planted'] || null,
          watering_frequency_days: null,
          last_watered: null,
          image_url: plant.Photo || null, // Google Drive URL
          status: 'active',
        })
        .select()
        .single();

      if (error) {
        console.error(`  ❌ Error inserting plant "${plant['Common Name']}":`, error.message);
      } else {
        plantIdMap.set(plant.ID, newPlant.id);
        console.log(`  ✅ Migrated plant: ${plant['Common Name']}`);
      }
    }

    console.log(`\n✅ Migrated ${plantIdMap.size}/${teamData.length} plants\n`);

    // Step 3: Migrate Diary Entries (Log)
    console.log('📔 Migrating diary entries...');
    let diaryCount = 0;

    for (const log of logData) {
      // Find the plant by common name (since Log uses Common Name, not ID)
      const matchingTeamPlant = teamData.find(p => p['Common Name'] === log['Common Name']);
      if (!matchingTeamPlant) {
        console.log(`  ⚠️  Skipping log for "${log['Common Name']}" - plant not found`);
        continue;
      }

      const plantId = plantIdMap.get(matchingTeamPlant.ID);
      if (!plantId) {
        console.log(`  ⚠️  Skipping log for "${log['Common Name']}" - plant not migrated`);
        continue;
      }

      // Get user ID for diary entry (required field)
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) continue;

      const { error } = await supabase
        .from('plant_diary_entries')
        .insert({
          plant_id: plantId,
          user_id: user.id,
          entry_type: 'observation', // Default type
          notes: log.Remarks || 'Diary entry',
          image_url: log.Photo || null, // Google Drive URL
          created_at: log['Date Modified'] || new Date().toISOString(),
        });

      if (error) {
        console.error(`  ❌ Error inserting diary entry for "${log['Common Name']}":`, error.message);
      } else {
        diaryCount++;
        console.log(`  ✅ Migrated diary entry for: ${log['Common Name']}`);
      }
    }

    console.log(`\n✅ Migrated ${diaryCount}/${logData.length} diary entries\n`);

    console.log('🎉 Migration complete!');
    console.log(`\n📊 Summary:`);
    console.log(`   Zones: ${zoneIdMap.size}`);
    console.log(`   Plants: ${plantIdMap.size}`);
    console.log(`   Diary Entries: ${diaryCount}`);

  } catch (error) {
    console.error('❌ Migration failed:', error);
  }
}

// Run the migration
migrateData();
