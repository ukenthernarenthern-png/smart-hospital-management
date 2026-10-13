# SmartCare AI: Intelligent Hospital Operations Platform
> **Hackathon Theme:** *Overcrowded Hospitals, Limited Resources: Doing More With What Exists*  
> **Core Philosophy:** *"Don’t Just Add Capacity. Make Existing Capacity Work Smarter. Think coordinated, predictive, and resource-efficient, not queue management."*

---

## 🏥 Overview

Hospitals routinely face overcrowded emergency departments, long delays, uneven bed utilization, and shortages of clinical staff or diagnostic equipment, while other departments hold unused capacity. Unpredictable arrivals, discharge delays, and fragmented information add to the strain. Because adding physical beds or hiring emergency staff is rarely immediate, coordinating existing resources is essential.

**SmartCare AI** is an intelligent hospital operations prototype designed to:
1. **Predict Resource Bottlenecks** before emergency bedlocks occur.
2. **Coordinate Available Capacity** dynamically across wards (Emergency, ICU, General Medicine, Surgical Recovery, Short-Stay Observation, Pediatrics).
3. **Recommend Proactive Clinical Actions** to improve throughput and patient flow without compromising patient safety.

---

## 🌟 Key Application Features

### 1. Operations Overview Dashboard
- **Key Capacity Metrics:** Real-time display of **Total Beds (280)**, **Occupied Beds**, **Available Beds**, **Expected Patient Arrivals (24h & 4h forecast)**, and **Median Waiting Times** (Door-to-Doctor and Bed Placement).
- **Interactive Scenarios Switcher:** Instant one-click toggling between:
  - 🟢 **Normal Day:** Steady-state operations (77.8% bed occupancy, 34 min ED wait time, green alerts).
  - 🟡 **Busy Day:** Elevated load (88.6% occupancy, 82 min ED wait time, CT scanner backlog, warning alerts).
  - 🔴 **Arrival Surge:** Critical influx (96.1% occupancy, 145 min ED wait time, ICU bedlock, code yellow emergency reallocation).
- **Dynamic Charts:** 
  - Hourly Patient Arrival Forecast vs Actual Arrivals with 95% confidence intervals.
  - Ward Bed Utilization Heatmap across 7 clinical units.
- **Real-Time Bottleneck Detector:** Heuristic dwell-time monitoring highlighting active department choke points.

### 2. Patient Flow & Clinical Triage
- **End-to-End Throughput Pipeline:** Visual tracking through 5 key stages:
  1. *Arrival & Registration*
  2. *Clinical Triage (Emergency Severity Index ESI 1 to 5)*
  3. *Diagnostics / Imaging (CT, MRI, Labs)*
  4. *Acute Emergency Treatment*
  5. *Admission Boarding vs Safe Discharge*
- **Acuity Hierarchy (ESI 1-5):** Enforces clinical priority where high-acuity resuscitation patients (ESI 1 & 2) bypass waiting queues.
- **Simulate Patient Influx:** Modal allowing judges/users to admit new custom patients live into the queue.

### 3. Dynamic Bed Management & Turnover Matrix
- **Interactive Ward Grid:** Filter beds by Ward (Emergency, ICU, Med A, Med B, Surgical, Observation, Pediatrics) and Status (Available, Occupied, Cleaning, Reserved).
- **Bed Status Actions:** Click on any bed tile to view patient clinical profile, expedite discharge, or accelerate Environmental Services (EVS) sanitization.
- **Discharge Readiness Tracker:** Highlights inpatients who are medically cleared by attending physicians and awaiting transit or pharmacy clearance.
- **Smart Bed Allocation Assistant:** Clinical matching engine that recommends the optimal ward and bed based on acuity level and cardiac telemetry requirements.

### 4. Resource Utilization
- **Diagnostic Imaging Backlog:** Live queue counters, cycle times (mins), and utilization percentages for CT Scanner 1 (ED), CT Scanner 2 (Inpatient), MRI 3.0T, Digital X-Ray, and Stat Blood Lab.
- **Clinical Staff Ratios:** Nurse-to-patient tracking conforming to clinical standards (ICU 1:1, ED 1:3, General Med 1:5).
- **Nursing Float Pool:** Dynamic re-assignment of floating nurses to relieve triage backlogs.
- **Internal Logistics Fleet:** Wheelchair, gurney, and transporter availability.

### 5. AI Recommendations (Clinical Decision Support)
- **Actionable Interventions:** One-click execution of proactive measures:
  - *Fast-Track Medically Cleared Discharges* (immediately frees up acute beds).
  - *Dynamic Bed Flex* (converts observation beds to inpatient overflow during surges).
  - *Divert CT Scans* (balances radiology queues between Scanner 1 and Scanner 2).
  - *Deploy Float Pool Nurses* (slashes triage wait time).
- **Impact Feedback & Audit Trail:** Interactive execution updates capacity numbers in real time, lowers waiting times, and records an event into the chronological Operations Audit Log.

### 6. Forecasting & Model Transparency (Ethical AI Compliance)
- **No False Claims:** Clearly documents the deterministic queueing models and heuristic algorithms used in the prototype:
  - **Poisson Arrival Process:** Modeling non-homogeneous arrival intensities $\lambda(t)$ by time of day.
  - **Little's Law:** Queue dwell-time calculation ($W = L / \lambda$).
  - **Safe Capacity Constraints:** Hard clinical rules ensuring patient acuity matches ward care level.

---

## 🚀 How to Run and Test the Project

### Option A: Instant Zero-Install Browser Launch (Recommended)
This web application is completely self-contained. You do **not** need Node.js, npm, or any external build tools.

1. Navigate to the project directory:
   ```
   C:\Users\ukenthar.G\.gemini\antigravity\scratch\smartcare-ai\
   ```
2. Double-click **`index.html`** or right-click &rarr; **Open with Google Chrome / Microsoft Edge**.
3. The platform will launch immediately with full interactive capabilities, responsive animations, scenario simulation, and live charts!

---

### Option B: Python Flask + SQLite Backend API
If you have Python installed and want to run the full REST API backend:

1. Open PowerShell or Command Prompt in the `backend/` directory:
   ```powershell
   cd C:\Users\ukenthar.G\.gemini\antigravity\scratch\smartcare-ai\backend
   ```
2. Install dependencies:
   ```powershell
   pip install -r requirements.txt
   ```
3. Initialize the SQLite database and seed demo data:
   ```powershell
   python seed_data.py
   ```
4. Start the Flask server:
   ```powershell
   python app.py
   ```
5. Open your browser and visit:
   ```
   http://127.0.0.1:5000
   ```

*Note: The frontend includes a top-bar mode indicator that automatically detects if Flask is active or operates in client simulation mode.*

---

## 📂 Project Directory Structure

```text
smartcare-ai/
│
├── index.html               # Complete interactive single-page application (Tailwind CSS + Chart.js)
├── README.md                # Project documentation and pitch guide
├── start_app.bat            # One-click Windows launch script
│
└── backend/
    ├── app.py               # Flask REST API server & routing
    ├── database.py          # SQLite database connection & schema
    ├── models.py            # Heuristic Little's Law, Poisson forecast & scenario engine
    ├── seed_data.py         # Realistic fictional hospital dataset generator
    ├── requirements.txt     # Python backend dependencies (Flask, Flask-CORS)
    └── smartcare.db         # SQLite database file (created upon first run)
```

---

## 🧪 Interactive Testing Checklist for Hackathon Judges

1. **Test Scenario Switching:** Click **"Normal Day"**, **"Busy Day"**, and **"Arrival Surge"** in the top bar. Verify that all 6 KPI cards, ward occupancies, alerts, and bottleneck lists update dynamically.
2. **Execute Recommendations:** Navigate to **AI Recommendations** or use the Overview cards. Click **"Trigger Discharge Huddle"** or **"Balance Radiology Queue"**. Observe the occupied bed count drop, available beds increase, and the action recorded in the audit log.
3. **Simulate Patient Influx:** Click the **"Simulate Patient"** button in the header. Enter a patient name, select acuity **ESI-2**, and submit. Verify that the patient appears in the Patient Flow table and alerts the trauma bay.
4. **Smart Bed Matching:** Click **"Match Bed"** in the header. Select clinical criteria (e.g. Critical acuity, Telemetry required) and click **"Find Optimal Ward & Bed"** to see the algorithmic recommendation.
5. **Bed Matrix Interaction:** Navigate to **Bed Management**. Filter by ward or status. Click any bed card to inspect patient details, finalize discharge, or expedite EVS room cleaning.
6. **Mobile / Tablet Responsiveness:** Resize your browser window to test the responsive layout.
