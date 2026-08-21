# Travel & Tour Guide Application (Carmelina Beach Resort App)

A mobile travel guide and resort service management application designed for guests at Carmelina Beach Resort. Built with a modern **Client-Server** architecture, featuring a cross-platform Flutter mobile client and a Node.js/Express RESTful API backend integrated with MongoDB.

---

## Table of Contents
- [System Overview](#system-overview)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Key Features](#key-features)
- [Project Directory Structure](#project-directory-structure)
- [Configuration & Installation Guide](#configuration--installation-guide)
  - [1. Backend (Node.js & Express)](#1-backend-nodejs--express)
  - [2. Frontend (Flutter)](#2-frontend-flutter)
- [RESTful API Endpoints](#restful-api-endpoints)
- [UI/UX Design Guidelines](#uiux-design-guidelines)

---

## System Overview

The **Carmelina Beach Resort App** provides a smart, seamless vacation experience, enabling guests to easily browse resort information, book rooms, sign up for activities, reserve dining tables, and access additional resort services directly from their mobile devices.

- **Minimalist & Intuitive Design**: Optimized for mobile user experience with smooth interactive UI components.
- **Real-Time Data Sync**: Synchronizes bookings, dining reservations, and activity sign-ups directly with the backend API.
- **Comprehensive Support**: Includes smart search, category filtering, booking history tracking, and a direct Quick Support channel (Chat/Hotline).

---

## Architecture & Tech Stack

### 1. Frontend (Mobile Client)
- **Framework**: [Flutter](https://flutter.dev/) (Dart SDK `^3.8.1`)
- **State Management & Local Storage**: `shared_preferences`, `sqflite`, `path_provider`
- **UI Components & Helper Packages**:
  - `intl`: Date, time, and currency formatting
  - `scroll_loop_auto_scroll`: Auto-scrolling banner loops
  - `image_picker`: Avatar and image selection/upload
  - `uuid`: Unique identifier generation

### 2. Backend (RESTful API Server)
- **Runtime Environment**: Node.js
- **Framework**: Express.js (`^4.17.1`)
- **Database**: MongoDB with Mongoose ODM (`^5.13.23`)
- **Authentication & Security**: JWT (`jsonwebtoken`), password hashing (`bcrypt`), environment variables (`dotenv`)
- **Dev Tools**: `nodemon`

---

## Key Features

| Screen | Detailed Features |
| :--- | :--- |
| **Home Screen** | • Personalized Recommendation Carousel<br>• Quick Service Grid (Rooms, Dining, Activities, Excursions, Services, Settings)<br>• Smart Service Search Bar<br>• Floating Quick Support Button (Chat/Hotline) |
| **Booking Screen** | • Room & service selection with date/time calendar picking<br>• Booking Invoice management (View, Edit, Delete items)<br>• Direct booking confirmation submission to backend |
| **Activities Screen** | • Category Filtering: Sports, Culture, Relaxation<br>• Highlighted Event Notifications (BBQ Party, Beach Events...)<br>• Detailed information modal & instant booking |
| **Restaurant Screen** | • Restaurant Categorization: Seafood, Buffet, Café<br>• Detailed food menus with prices<br>• Table reservation with custom time slot, party size, and seating area |
| **Services Screen** | • Transport, airport shuttle, tour guides, laundry, water sports gear rentals<br>• Fast service request submission |
| **Excursions Screen** | • Explore off-resort attractions and local guided tours |
| **Account & History** | • User Registration & Login<br>• Account profile management & app settings<br>• Booking History management & status tracking |

---

## Project Directory Structure

```text
travel_tour_guide_app/
├── backend-app/                   # RESTful API Backend
│   ├── src/
│   │   ├── config/                # MongoDB Database Configuration
│   │   ├── controllers/           # Business logic handlers for APIs
│   │   ├── middleware/            # JWT Auth & Error Handling Middleware
│   │   ├── models/                # Mongoose Schemas (User, Booking, Service...)
│   │   ├── routes/                # Express API Route declarations
│   │   ├── app.js                 # Express server entry point
│   │   └── seed.js                # Initial database seed script
│   ├── .env                       # Environment variables configuration
│   └── package.json
│
├── frontend/                      # Flutter Mobile Application
│   ├── lib/
│   │   ├── data/                  # API Service layer & SQLite local storage
│   │   ├── models/                # Dart Data Models
│   │   ├── screens/               # App Screen UI Widgets
│   │   ├── widgets/               # Reusable UI Components
│   │   └── main.dart              # Flutter application entry point
│   ├── assets/                    # Image & static assets
│   └── pubspec.yaml               # Flutter dependencies configuration
│
└── ResortAppDocumentation.markdown # Comprehensive UI/UX Design & User Flow Doc
```

---

## Configuration & Installation Guide

### Prerequisites
- **Node.js**: `>= v14.x`
- **MongoDB**: Local MongoDB instance or MongoDB Atlas cluster
- **Flutter SDK**: `>= 3.8.1`
- **Android Studio / Xcode**: Installed Emulator or physical device setup

---

### 1. Backend Setup (Node.js & Express)

1. **Navigate to the backend directory**:
   ```bash
   cd backend-app
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure Environment Variables**:
   Create or edit the `.env` file in the root of `backend-app`:
   ```env
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/carmelina_resort
   JWT_SECRET=your_secret_key_here
   ```

4. **Seed Sample Data (Optional)**:
   ```bash
   node src/seed.js
   ```

5. **Start the Server**:
   - Development Mode (with Nodemon):
     ```bash
     npm run dev
     ```
   - Production Mode:
     ```bash
     npm start
     ```
   *(Server runs by default on `http://localhost:3000`)*

---

### 2. Frontend Setup (Flutter)

1. **Navigate to the frontend directory**:
   ```bash
   cd frontend
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   - Mobile Device / Emulator:
     ```bash
     flutter run
     ```
   - Web Browser (if enabled):
     ```bash
     flutter run -d chrome
     ```

---

## RESTful API Endpoints

The backend server provides the following endpoints:

| API Group | Method | Endpoint | Description |
| :--- | :--- | :--- | :--- |
| **Services** | `GET` | `/api/services` | Retrieve list of resort services |
| | `POST` | `/api/service-bookings` | Submit a service reservation |
| **Activities** | `GET` | `/api/activities` | Retrieve activities & resort events |
| | `POST` | `/api/activity-bookings` | Sign up for an activity |
| **Restaurants** | `GET` | `/api/restaurants` | Retrieve restaurants and menu items |
| | `POST` | `/api/restaurant-bookings` | Reserve a restaurant table |
| **Bookings** | `POST` | `/api/bookings` | Create main room / combined booking |
| | `GET` | `/api/bookings` | Fetch user booking history |
| **Recommendations** | `GET` | `/api/recommendations` | Fetch personalized service suggestions |

---

## UI/UX Design Guidelines

The application strictly follows defined design standards:
- **Color Palette**:
  - Primary: Blue (`#1976D2`)
  - Background: Light Gray (`#F5F7FA`) / White (`#FFFFFF`)
  - Text & Accents: Dark Gray (`#757575`), Success (`#4CAF50`), Alert (`#F44336`)
- **Typography**:
  - Titles: 16px Bold
  - Descriptions: 12px – 14px Regular
- **Micro-animations**:
  - Fade-in for list and carousel loading
  - Button scale feedback on press
  - Pulse effects for urgent event notifications
- **Accessibility**: High contrast ratio >= 4.5:1, touch target sizes >= 48x48px.
