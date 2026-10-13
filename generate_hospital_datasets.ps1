# Generates distinct, rich synthetic hospital datasets for each medical center
$baseDir = "C:\Users\ukenthar.G\Desktop\smartcare-ai\data"

$hospitalsData = @{
    "metro_general_hospital" = @{
        name = "Metro General Hospital & Level-1 Trauma Center"
        facility_type = "Urban Level-1 Tertiary Academic Hospital"
        total_beds = 320
        annual_ed_visits = 85000
        trauma_level = "Level 1"
        wards = @(
            @{ id="ED"; name="Emergency & Trauma Resuscitation"; beds=50; ratio="1:3"; acuity="Critical / Resus" },
            @{ id="ICU"; name="Surgical & Medical Intensive Care"; beds=35; ratio="1:1"; acuity="Critical" },
            @{ id="MED-A"; name="Acute General Medicine Ward A"; beds=55; ratio="1:5"; acuity="Moderate" },
            @{ id="MED-B"; name="Acute General Medicine Ward B"; beds=55; ratio="1:5"; acuity="Moderate" },
            @{ id="TRAUMA-SURG"; name="Trauma & Orthopedic Surgery Floor"; beds=50; ratio="1:4"; acuity="High" },
            @{ id="OBS"; name="Rapid Diagnostic Observation Unit"; beds=45; ratio="1:6"; acuity="Low-Moderate" },
            @{ id="PED"; name="Pediatric Emergency & Inpatient"; beds=30; ratio="1:4"; acuity="Variable" }
        )
        complaints = @(
            @{ esi=1; desc="Gunshot Wound / Hemorrhagic Shock"; dept="Emergency" },
            @{ esi=1; desc="Acute STEMI / Ventricular Fibrillation"; dept="Emergency" },
            @{ esi=2; desc="Motor Vehicle Collision / Subdural Hematoma"; dept="Trauma-Surg" },
            @{ esi=2; desc="Acute Ischemic Stroke / tPA Candidate"; dept="Emergency" },
            @{ esi=2; desc="Septic Shock secondary to Lobar Pneumonia"; dept="ICU" },
            @{ esi=3; desc="Unstable Angina / Serial Troponin Protocol"; dept="Emergency" },
            @{ esi=3; desc="Severe Pancreatitis with Dehydration"; dept="General Medicine" },
            @{ esi=3; desc="Comminuted Femur Fracture / Pre-Op Traction"; dept="Trauma-Surg" },
            @{ esi=4; desc="Forearm Laceration with Tendon Sparing"; dept="Emergency" },
            @{ esi=4; desc="Exacerbation of Asthma / Duoneb Therapy"; dept="Observation" },
            @{ esi=5; desc="Suture Removal & Dressing Assessment"; dept="Emergency" }
        )
    }

    "st_jude_community_center" = @{
        name = "St. Jude Community Medical Center"
        facility_type = "Suburban Community Healthcare System"
        total_beds = 220
        annual_ed_visits = 42000
        trauma_level = "Level 3"
        wards = @(
            @{ id="ED"; name="Community Emergency Bay"; beds=35; ratio="1:4"; acuity="Moderate-Acute" },
            @{ id="ICU"; name="Mixed Medical-Surgical ICU"; beds=20; ratio="1:2"; acuity="Critical" },
            @{ id="MED-A"; name="Internal Medicine & Geriatrics"; beds=45; ratio="1:5"; acuity="Moderate" },
            @{ id="MED-B"; name="Cardiopulmonary Care Floor"; beds=40; ratio="1:5"; acuity="Moderate" },
            @{ id="SURG"; name="Elective General Surgery Recovery"; beds=35; ratio="1:5"; acuity="Moderate" },
            @{ id="OBS"; name="Short-Stay Ambulatory Unit"; beds=25; ratio="1:6"; acuity="Low" },
            @{ id="REHAB"; name="Inpatient Physical Rehabilitation"; beds=20; ratio="1:8"; acuity="Low" }
        )
        complaints = @(
            @{ esi=2; desc="Decompensated Congestive Heart Failure"; dept="Cardiopulmonary" },
            @{ esi=2; desc="Diabetic Ketoacidosis / Insulin Infusion"; dept="ICU" },
            @{ esi=3; desc="Acute Exacerbation of COPD / Wheezing"; dept="Internal Medicine" },
            @{ esi=3; desc="Bilateral Lower Lobe Community Pneumonia"; dept="Internal Medicine" },
            @{ esi=3; desc="Total Knee Arthroplasty Post-Op Day 1"; dept="Surgery" },
            @{ esi=4; desc="Elderly Fall / Contusion / Normal Head CT"; dept="Observation" },
            @{ esi=4; desc="Urinary Tract Infection / Oral Antibiotics"; dept="Internal Medicine" },
            @{ esi=4; desc="Mild Cellulitis / IV Vancomycin Round"; dept="Internal Medicine" },
            @{ esi=5; desc="Prescription Refill / Minor Upper Respiratory"; dept="Emergency" }
        )
    }

    "mercy_specialty_care" = @{
        name = "Mercy Regional Specialty Care & Surgical Hospital"
        facility_type = "Specialty Surgical & Oncology Center"
        total_beds = 180
        annual_ed_visits = 18000
        trauma_level = "Specialty / Elective Non-Trauma"
        wards = @(
            @{ id="ED"; name="Urgent Ambulatory Assessment Bay"; beds=25; ratio="1:4"; acuity="Moderate" },
            @{ id="ICU"; name="Cardiothoracic & Post-Op ICU"; beds=20; ratio="1:1"; acuity="Critical" },
            @{ id="ONC"; name="Medical Oncology & Infusion Floor"; beds=35; ratio="1:4"; acuity="Moderate-High" },
            @{ id="SURG-A"; name="Spine & Orthopedic Recovery"; beds=35; ratio="1:4"; acuity="Moderate" },
            @{ id="SURG-B"; name="Bariatric & Colorectal Recovery"; beds=40; ratio="1:4"; acuity="Moderate" },
            @{ id="OBS"; name="Extended Recovery Lounge (23-Hour)"; beds=15; ratio="1:5"; acuity="Low" },
            @{ id="PALL"; name="Palliative & Comfort Care Suite"; beds=10; ratio="1:3"; acuity="Palliative" }
        )
        complaints = @(
            @{ esi=2; desc="Chemotherapy Febrile Neutropenia (Temp 39.1C)"; dept="Oncology" },
            @{ esi=2; desc="Post-Pneumonectomy Arrhythmia Monitoring"; dept="Cardiothoracic ICU" },
            @{ esi=3; desc="Laparoscopic Sigmoid Colectomy Post-Op"; dept="Colorectal" },
            @{ esi=3; desc="Multi-Level Lumbar Spinal Fusion Recovery"; dept="Spine Surgery" },
            @{ esi=3; desc="Intractable Pain secondary to Bone Metastasis"; dept="Oncology" },
            @{ esi=4; desc="Post-Op Ileus / NGT Suction / Hydration"; dept="Surgical Recovery" },
            @{ esi=4; desc="PICC Line Dressing Change & Line Infection Check"; dept="Oncology" },
            @{ esi=5; desc="Routine Outpatient Drain Removal"; dept="Ambulatory" }
        )
    }
}

$firstNames = @("James", "Emma", "Liam", "Olivia", "Noah", "Sophia", "Alexander", "Isabella", "William", "Ava", "Daniel", "Mia", "Benjamin", "Charlotte", "Matthew", "Amelia")
$lastNames = @("Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Wilson", "Anderson", "Taylor", "Thomas", "Moore", "Jackson", "Martin", "Lee")

foreach ($hKey in $hospitalsData.Keys) {
    $h = $hospitalsData[$hKey]
    $hDir = Join-Path $baseDir $hKey

    # 1. Facility Profile JSON
    $profileObj = @{
        hospital_id = $hKey
        hospital_name = $h.name
        facility_type = $h.facility_type
        total_licensed_beds = $h.total_beds
        trauma_designation = $h.trauma_level
        annual_ed_volume = $h.annual_ed_visits
        clinical_wards = $h.wards
        ehr_integration = @{
            system_protocol = "HL7 v2.5.1 / FHIR Release 4"
            fhir_endpoint = "https://fhir.$hKey.health.local/r4"
            supported_resources = @("Patient", "Encounter", "Observation", "Location", "DeviceRequest")
        }
        dataset_metadata = @{
            benchmark_source = "Clinical Operational Simulator (Modeled after MIMIC-IV-ED / CMS Hospital Benchmarks)"
            generated_at = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            records_format = "CSV and JSON schemas"
        }
    }
    $profileJson = $profileObj | ConvertTo-Json -Depth 6
    [System.IO.File]::WriteAllText((Join-Path $hDir "facility_profile.json"), $profileJson, [System.Text.Encoding]::UTF8)

    # 2. Bed Inventory CSV
    $bedCsvLines = @("Bed_ID,Ward_ID,Ward_Name,Bed_Number,Status,Target_Nurse_Ratio,Acuity_Level,Has_Telemetry,Oxygen_Port")
    $patientList = @()
    $patCsvLines = @("Patient_ID,MRN,Full_Name,Age,Gender,ESI_Acuity,Chief_Complaint,Assigned_Ward,Assigned_Bed,Current_Stage,Discharge_Ready,Admission_Timestamp")

    $pCounter = 1
    $targetOccupancy = 0.82

    foreach ($w in $h.wards) {
        $wardOccupied = [Math]::Round($w.beds * $targetOccupancy)
        $wardCleaning = [Math]::Max(1, [Math]::Round($w.beds * 0.06))

        for ($b = 1; $b -le $w.beds; $b++) {
            $bedId = "{0}-{1:D2}" -f $w.id, $b
            $hasTele = if ($w.acuity -like "*Critical*" -or $w.acuity -like "*High*") { "Yes" } else { "Optional" }
            $status = "Available"

            if ($b -le $wardOccupied) {
                $status = "Occupied"

                # Generate patient
                $fName = $firstNames[($pCounter - 1) % $firstNames.Count]
                $lName = $lastNames[($pCounter * 3) % $lastNames.Count]
                $age = 22 + (($pCounter * 7) % 65)
                $gender = if ($pCounter % 2 -eq 0) { "Female" } else { "Male" }
                $comp = $h.complaints[($pCounter - 1) % $h.complaints.Count]
                $patId = "PAT-{0}-{1:D4}" -f $hKey.Substring(0,3).ToUpper(), $pCounter
                $mrn = "MRN-{0}" -f (800000 + $pCounter)
                $isReady = if ($w.id -like "*MED*" -or $w.id -like "*OBS*" -or $w.id -like "*SURG*") { if ($pCounter % 5 -eq 0) { 1 } else { 0 } } else { 0 }
                $stage = if ($isReady -eq 1) { "Discharge-Ready" } elseif ($w.id -eq "ED") { "Emergency Treatment" } else { "Inpatient Care" }
                $admitTime = (Get-Date).AddHours(-($pCounter % 36)).ToString("yyyy-MM-dd HH:mm")

                $pObj = @{
                    id = $patId
                    mrn = $mrn
                    name = "$fName $lName"
                    age = $age
                    gender = $gender
                    esi_score = $comp.esi
                    chief_complaint = $comp.desc
                    department = $w.name
                    bed_id = $bedId
                    current_stage = $stage
                    discharge_ready = $isReady
                    admission_time = $admitTime
                }
                $patientList += $pObj

                $patCsvLines += '"{0}","{1}","{2}",{3},"{4}",{5},"{6}","{7}","{8}","{9}",{10},"{11}"' -f $patId, $mrn, "$fName $lName", $age, $gender, $comp.esi, $comp.desc, $w.name, $bedId, $stage, $isReady, $admitTime
                $pCounter++
            } elseif ($b -le ($wardOccupied + $wardCleaning)) {
                $status = "Cleaning"
            }

            $bedCsvLines += '"{0}","{1}","{2}",{3},"{4}","{5}","{6}","{7}","Yes"' -f $bedId, $w.id, $w.name, $b, $status, $w.ratio, $w.acuity, $hasTele
        }
    }

    # Write bed inventory CSV
    [System.IO.File]::WriteAllLines((Join-Path $hDir "bed_inventory.csv"), $bedCsvLines, [System.Text.Encoding]::UTF8)

    # Write patients CSV & JSON
    [System.IO.File]::WriteAllLines((Join-Path $hDir "patients.csv"), $patCsvLines, [System.Text.Encoding]::UTF8)
    $patientsJson = $patientList | ConvertTo-Json -Depth 6
    [System.IO.File]::WriteAllText((Join-Path $hDir "patients.json"), $patientsJson, [System.Text.Encoding]::UTF8)
}

Write-Host "Hospital datasets generated successfully for all 3 facilities in $baseDir"
