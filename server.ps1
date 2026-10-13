# SmartCare AI - Native Windows HTTP Server & File Storage Engine
$port = 5000
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$dataDir = Join-Path $baseDir "data"

if (-not (Test-Path $dataDir)) {
    New-Item -ItemType Directory -Force -Path $dataDir | Out-Null
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:${port}/")

try {
    $listener.Start()
    Write-Host "=========================================================="
    Write-Host " SmartCare AI Server running on http://127.0.0.1:5000/"
    Write-Host " Base Directory: $baseDir"
    Write-Host " Data Storage Folder: $dataDir"
    Write-Host "=========================================================="
} catch {
    Write-Error ("Failed to start listener on port {0}: {1}" -f $port, $_)
    exit 1
}

function Send-JsonResponse($response, $obj, $statusCode = 200) {
    $json = $obj | ConvertTo-Json -Depth 10
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
    $response.StatusCode = $statusCode
    $response.ContentType = "application/json; charset=utf-8"
    $response.AddHeader("Access-Control-Allow-Origin", "*")
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.OutputStream.Close()
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        # CORS preflight
        $response.AddHeader("Access-Control-Allow-Origin", "*")
        $response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Accept")
        $response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")

        if ($request.HttpMethod -eq "OPTIONS") {
            $response.StatusCode = 200
            $response.OutputStream.Close()
            continue
        }

        $urlPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($urlPath) -or $urlPath -eq "/") {
            $urlPath = "index.html"
        }

        # 1. API: Health Check
        if ($urlPath -eq "api/system/health") {
            Send-JsonResponse $response @{
                status = "healthy"
                service = "SmartCare AI Operations Engine"
                storage_directory = $dataDir
                timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }
            continue
        }

        # 2. API: Save Data to Separate Laptop Files
        if ($urlPath -eq "api/save-data" -and $request.HttpMethod -eq "POST") {
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $rawBody = $reader.ReadToEnd()
            
            try {
                $payload = $rawBody | ConvertFrom-Json
                
                # A. Save patients.json
                if ($payload.patients) {
                    $patientsJson = $payload.patients | ConvertTo-Json -Depth 10
                    [System.IO.File]::WriteAllText((Join-Path $dataDir "patients.json"), $patientsJson, [System.Text.Encoding]::UTF8)
                    
                    # B. Also generate separate patients.csv on laptop
                    $csvLines = @("ID,MRN,Name,Age,ESI_Score,Chief_Complaint,Department,Bed_ID,Current_Stage,Discharge_Ready,Admission_Time")
                    foreach ($p in $payload.patients) {
                        $cleanComplaint = if ($p.chief_complaint) { $p.chief_complaint.Replace('"', '""') } else { "" }
                        $line = '"{0}","{1}","{2}",{3},{4},"{5}","{6}","{7}","{8}",{9},"{10}"' -f $p.id, $p.mrn, $p.name, $p.age, $p.esi_score, $cleanComplaint, $p.department, $p.bed_id, $p.current_stage, $p.discharge_ready, $p.admission_time
                        $csvLines += $line
                    }
                    [System.IO.File]::WriteAllLines((Join-Path $dataDir "patients.csv"), $csvLines, [System.Text.Encoding]::UTF8)
                }

                # C. Save action_logs.csv
                if ($payload.actionLogs) {
                    $logLines = @("Timestamp,Action,Description,Impact")
                    foreach ($l in $payload.actionLogs) {
                        $desc = if ($l.desc) { $l.desc.Replace('"', '""') } else { "" }
                        $impact = if ($l.impact) { $l.impact.Replace('"', '""') } else { "" }
                        $logLines += '"{0}","{1}","{2}","{3}"' -f $l.timestamp, $l.action, $desc, $impact
                    }
                    [System.IO.File]::WriteAllLines((Join-Path $dataDir "action_logs.csv"), $logLines, [System.Text.Encoding]::UTF8)
                }

                # D. Save beds.json
                if ($payload.beds) {
                    $bedsJson = $payload.beds | ConvertTo-Json -Depth 10
                    [System.IO.File]::WriteAllText((Join-Path $dataDir "beds.json"), $bedsJson, [System.Text.Encoding]::UTF8)
                }

                # E. Save hospital summary JSON
                $summary = @{
                    last_saved = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                    scenario = $payload.scenario
                    total_patients = if ($payload.patients) { $payload.patients.Count } else { 0 }
                    total_beds = if ($payload.beds) { $payload.beds.Count } else { 0 }
                    metrics = $payload.metrics
                }
                $summaryJson = $summary | ConvertTo-Json -Depth 5
                [System.IO.File]::WriteAllText((Join-Path $dataDir "hospital_summary.json"), $summaryJson, [System.Text.Encoding]::UTF8)

                Send-JsonResponse $response @{
                    success = $true
                    message = "Data successfully saved into separate files in $dataDir"
                    files_written = @("patients.json", "patients.csv", "action_logs.csv", "beds.json", "hospital_summary.json")
                    timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                }
            } catch {
                Send-JsonResponse $response @{
                    success = $false
                    error = $_.Exception.Message
                } 500
            }
            continue
        }

        # 3. API: Load Stored Data / Sync Directly from Excel (patients.csv)
        if ($urlPath -eq "api/load-data" -or $urlPath -eq "api/read-excel-data") {
            $patientsCsvFile = Join-Path $dataDir "patients.csv"
            $patientsJsonFile = Join-Path $dataDir "patients.json"

            if (Test-Path $patientsCsvFile) {
                # Reads CSV directly so ANY row added or edited in Microsoft Excel is immediately reflected!
                $csvData = Import-Csv -Path $patientsCsvFile
                $parsedPatients = @()
                foreach ($row in $csvData) {
                    $esi = 3
                    if ($row.ESI_Score) { [int]::TryParse($row.ESI_Score, [ref]$esi) | Out-Null }
                    elseif ($row.ESI_Acuity) { [int]::TryParse($row.ESI_Acuity, [ref]$esi) | Out-Null }

                    $age = 45
                    if ($row.Age) { [int]::TryParse($row.Age, [ref]$age) | Out-Null }

                    $isReady = 0
                    if ($row.Discharge_Ready) { [int]::TryParse($row.Discharge_Ready, [ref]$isReady) | Out-Null }

                    $pObj = @{
                        id = if ($row.ID) { $row.ID } elseif ($row.Patient_ID) { $row.Patient_ID } else { "PAT-" + [Guid]::NewGuid().ToString().Substring(0,5) }
                        mrn = if ($row.MRN) { $row.MRN } else { "MRN-Unknown" }
                        name = if ($row.Name) { $row.Name } elseif ($row.Full_Name) { $row.Full_Name } else { "Unnamed Patient" }
                        age = $age
                        esi_score = $esi
                        chief_complaint = if ($row.Chief_Complaint) { $row.Chief_Complaint } else { "Clinical evaluation" }
                        department = if ($row.Department) { $row.Department } elseif ($row.Assigned_Ward) { $row.Assigned_Ward } else { "Emergency" }
                        bed_id = if ($row.Bed_ID) { $row.Bed_ID } elseif ($row.Assigned_Bed) { $row.Assigned_Bed } else { "Waiting" }
                        current_stage = if ($row.Current_Stage) { $row.Current_Stage } else { "Treatment" }
                        discharge_ready = $isReady
                        admission_time = if ($row.Admission_Time) { $row.Admission_Time } elseif ($row.Admission_Timestamp) { $row.Admission_Timestamp } else { "Just now" }
                    }
                    $parsedPatients += $pObj
                }

                Send-JsonResponse $response @{
                    has_data = $true
                    source = "patients.csv (Microsoft Excel Spreadsheet)"
                    count = $parsedPatients.Count
                    patients = $parsedPatients
                    data_directory = $dataDir
                    last_modified = (Get-Item $patientsCsvFile).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                }
            } elseif (Test-Path $patientsJsonFile) {
                $rawP = [System.IO.File]::ReadAllText($patientsJsonFile, [System.Text.Encoding]::UTF8)
                $pData = $rawP | ConvertFrom-Json
                Send-JsonResponse $response @{
                    has_data = $true
                    source = "patients.json"
                    patients = $pData
                    data_directory = $dataDir
                }
            } else {
                Send-JsonResponse $response @{
                    has_data = $false
                    message = "No saved data files yet."
                }
            }
            continue
        }

        # 4. API: Upload / Overwrite CSV directly from UI
        if ($urlPath -eq "api/upload-csv" -and $request.HttpMethod -eq "POST") {
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $csvContent = $reader.ReadToEnd()
            $patientsCsvFile = Join-Path $dataDir "patients.csv"
            [System.IO.File]::WriteAllText($patientsCsvFile, $csvContent, [System.Text.Encoding]::UTF8)

            Send-JsonResponse $response @{
                success = $true
                message = "Excel/CSV uploaded and saved to $patientsCsvFile"
            }
            continue
        }

        # 4. Static File Delivery
        $filePath = Join-Path $baseDir $urlPath
        if (Test-Path $filePath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $mime = switch ($ext) {
                ".html" { "text/html; charset=utf-8" }
                ".htm"  { "text/html; charset=utf-8" }
                ".js"   { "application/javascript" }
                ".css"  { "text/css" }
                ".json" { "application/json; charset=utf-8" }
                ".csv"  { "text/csv; charset=utf-8" }
                ".png"  { "image/png" }
                ".jpg"  { "image/jpeg" }
                ".svg"  { "image/svg+xml" }
                default { "application/octet-stream" }
            }
            $response.ContentType = $mime
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.OutputStream.Write($msg, 0, $msg.Length)
        }
        $response.OutputStream.Close()
    } catch {
        # continue listener loop
    }
}
