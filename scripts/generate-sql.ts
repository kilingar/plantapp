import * as XLSX from 'xlsx';
import * as path from 'path';
import * as fs from 'fs';

// Read the Excel file and generate SQL
function generateSQL() {
  console.log('🌱 Reading Plant Directory.xlsx...\n');

  const filePath = path.join(process.cwd(), 'Plant Directory.xlsx');
  const workbook = XLSX.readFile(filePath);

  // Read sheets
  const teamSheet = workbook.Sheets['Team'];
  const resourcesSheet = workbook.Sheets['Resources'];
  const logSheet = workbook.Sheets['Log'];

  const teamData: any[] = XLSX.utils.sheet_to_json(teamSheet);
  const resourcesData: any[] = XLSX.utils.sheet_to_json(resourcesSheet);
  const logData: any[] = XLSX.utils.sheet_to_json(logSheet);

  console.log(`📊 Found ${resourcesData.length} zones, ${teamData.length} plants, ${logData.length} log entries\n`);

  let sql = `-- Plant Directory Migration SQL
-- Run this in Supabase SQL Editor
-- Generated on ${new Date().toISOString()}

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
    VALUES ('My House', 'YOUR_USER_ID', 'Migrated from Plant Directory Excel')
    RETURNING id INTO v_home_id;
  END IF;
  
  RAISE NOTICE 'Using home ID: %', v_home_id;
END $$;

-- Step 2: Insert Zones (Resources)
`;

  // Generate zone inserts
  resourcesData.forEach((resource, index) => {
    const zoneName = (resource.Title || 'Unnamed Zone').replace(/'/g, "''");
    const description = resource.Description ? `'${resource.Description.replace(/'/g, "''")}'` : 'NULL';
    const imageUrl = resource.Image ? `'${resource.Image}'` : 'NULL';
    
    sql += `INSERT INTO zones (id, home_id, name, description, image_url)
VALUES (
  '${generateUUID(index, 'zone')}',
  (SELECT id FROM homes LIMIT 1),
  '${zoneName}',
  ${description},
  ${imageUrl}
);\n`;
  });

  sql += `\n-- Step 3: Insert Plants (Team)\n`;

  // Create a map of positioning to zone IDs
  const zoneMap: { [key: string]: string } = {};
  resourcesData.forEach((resource, index) => {
    zoneMap[resource.ID] = generateUUID(index, 'zone');
  });

  // Generate plant inserts
  teamData.forEach((plant, index) => {
    const zoneId = zoneMap[plant.Positioning];
    if (!zoneId) return; // Skip if zone not found

    const name = (plant['Common Name'] || 'Unknown Plant').replace(/'/g, "''");
    const description = plant.Description ? `'${plant.Description.replace(/'/g, "''")}'` : 'NULL';
    const imageUrl = plant.Photo ? `'${plant.Photo}'` : 'NULL';
    
    // Convert Excel date (days since 1900) to PostgreSQL date
    let acquisitionDate = 'NULL';
    if (plant['Date planted']) {
      const excelDate = parseFloat(plant['Date planted']);
      if (!isNaN(excelDate)) {
        const date = new Date((excelDate - 25569) * 86400 * 1000); // Convert to JS date
        acquisitionDate = `'${date.toISOString().split('T')[0]}'`;
      }
    }

    sql += `INSERT INTO plants (id, zone_id, name, species, description, acquisition_date, watering_frequency_days, last_watered, image_url, status)
VALUES (
  '${generateUUID(index, 'plant')}',
  '${zoneId}',
  '${name}',
  NULL,
  ${description},
  ${acquisitionDate},
  NULL,
  NULL,
  ${imageUrl},
  'active'
);\n`;
  });

  sql += `\n-- Step 4: Insert Diary Entries (Log)\n`;

  // Create a map of Team.ID to plant UUIDs
  const plantIdMap: { [key: string]: string } = {};
  teamData.forEach((plant, index) => {
    plantIdMap[plant.ID] = generateUUID(index, 'plant');
  });

  // Generate diary entry inserts
  let logIndex = 0;
  let skippedCount = 0;
  logData.forEach((log) => {
    // Log uses "Common Name" which corresponds to Team's "ID"
    const teamId = log['Common Name']?.toString();
    const plantId = teamId ? plantIdMap[teamId] : null;
    if (!plantId) {
      skippedCount++;
      return; // Skip if plant not found
    }

    const notes = log.Remarks ? `'${log.Remarks.replace(/'/g, "''")}'` : `'Diary entry'`;
    const imageUrl = log.Photo ? `'${log.Photo}'` : 'NULL';
    
    // Convert Excel date (days since 1900) to PostgreSQL timestamp
    let createdAt = 'NOW()';
    if (log['Date Modified']) {
      const excelDate = parseFloat(log['Date Modified']);
      if (!isNaN(excelDate)) {
        const date = new Date((excelDate - 25569) * 86400 * 1000); // Convert to JS date
        createdAt = `'${date.toISOString()}'`;
      }
    }

    sql += `INSERT INTO plant_diary_entries (id, plant_id, user_id, entry_type, notes, image_url, created_at)
VALUES (
  '${generateUUID(logIndex++, 'diary')}',
  '${plantId}',
  (SELECT id FROM profiles LIMIT 1),
  'observation',
  ${notes},
  ${imageUrl},
  ${createdAt}
);\n`;
  });

  sql += `\n-- Migration complete!
-- Summary:
--   Zones: ${resourcesData.length}
--   Plants: ${teamData.length}
--   Diary Entries: ${logIndex} (${skippedCount} skipped - plant not found)
`;

  // Write to file
  const outputPath = path.join(process.cwd(), 'migration-data.sql');
  fs.writeFileSync(outputPath, sql);

  console.log(`✅ SQL generated successfully!`);
  console.log(`📝 File saved to: migration-data.sql`);
  console.log(`📊 Diary entries: ${logIndex} inserted, ${skippedCount} skipped`);
  console.log(`\n🔧 Next steps:`);
  console.log(`   1. Open Supabase SQL Editor`);
  console.log(`   2. Replace 'YOUR_USER_ID' with your actual user UUID`);
  console.log(`   3. Copy and paste the SQL from migration-data.sql`);
  console.log(`   4. Run the query`);
}

// Generate deterministic UUIDs based on index (proper UUID format)
function generateUUID(index: number, prefix: string): string {
  // Create a proper UUID v4 format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
  const prefixCode = prefix === 'zone' ? '1' : prefix === 'plant' ? '2' : '3';
  const indexStr = index.toString().padStart(11, '0');
  return `${prefixCode}${indexStr}-0000-4000-8000-000000000000`.substring(0, 36);
}

generateSQL();
