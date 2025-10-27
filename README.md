
# 🧭 TripPlanner iOS App

An intelligent travel planner app built with **Swift** and **SwiftUI**, powered by **FastAPI + Gemini** on the backend.  
It generates personalized trip itineraries with weather-aware insights to recommend the best travel dates.

---

## 🧩 Features

- 🗺️ Enter destination and trip duration  
- ☀️ AI recommends ideal travel days using real weather data  
- 📅 Generates structured daily itinerary  
- 🗺️ Interactive with daily activities marked in seperate maps
- 🧠 Efficient memory management to handle memory intensive maps

---

## 🏗️ Architecture Overview

SwiftUI View → TripService (URLSession) → FastAPI Backend → Gemini + Weather API

**Flow:**
1. User inputs trip details.
2. The app sends POST request to FastAPI endpoint `/trips/generate`.
3. Backend processes AI + weather logic.
4. JSON response is decoded into Swift models and displayed in map view along with routes marked.

---

## ⚙️ Tech Stack & Frameworks

| Framework / Library | Purpose | Reason for Choice |
|----------------------|----------|-------------------|
| **SwiftUI** | UI framework | Modern, declarative UI development, Faster render cycles |
| **Combine** | Data binding | Supports asynchronous reactive UI update |
| **URLSession** | Networking | Native, lighweight and reliable networking client |

---

## 🚀 Running the App

### 1. Clone the Repository
- Open a terminal and enter these commands:
- git clone https://github.com/Diwaakar84/TripPlanneriOS.git
- cd TripPlanneriOS

### 2. Running the app
- Open TripPlanneriOS.xcodeproj or .xcworkspace in Xcode.

### 3. Update the backend URL
- In Constants/Constants.swift, update:
  let baseURL = "http://<your-local-ip>:8000"
- Replace the existing URL with your local ip address.

### 4. Run the app
- Select a simulator or connected device → Press Run (⌘ + R).

---

## 📈 Current Progress
- ✅ SwiftUI UI and network layer complete
- ✅ Working backend connection via local IP
- 🔁 Display the plan from backend in the using memory efficient maps

---

## 🔮 Future Enhancements
- 🗓️ Include more options for the user to customize plan (dates, budget, etc)
- 🔔 Push notifications for weather changes
- 🧭 Offline mode with cached plans
- ▶️ Improve accessibility with smoother onboarding

---

## 🧠 System Design Decisions
- MVVM architecture — keeps TripService (data logic) separate from UI.
- Decodable models mirror backend schemas → easy versioning and stability.
- Dependency isolation — networking via native URLSession, no third-party frameworks.
- Extensible API structure — designed to support multiple endpoints in future (e.g. recommendations, budgets, etc.).
