# GetFitApp

## Overview

GetFitApp is an Android fitness tracking application developed with Flutter and Dart. Created by a team of six UMD students as our Senior Capstone for the Spring 2025 semester. this project utilizes the Model-View-Presenter (MVP) architecture, integrates with Firebase for backend services, and was managed using agile scrum methodologies. The app enables users to log in, track their workouts, view progress, and engage with community features like leaderboards.

This repository highlights contributions including the implementation of the "Add Workout" and "Workout History" screens, as well as the initial setup and structuring of the Firebase database.

## Key Features

*   **User Authentication**: Securely create an account and log in to the application.
*   **Workout Logging**: Add detailed workout entries, including title, description, type (e.g., running, weight training), duration, distance, and an optional photo.
*   **Exercise Database**: Browse and search for a wide variety of exercises using an external API.
*   **Workout History**: View a chronological history of all logged workouts. Users can expand entries to see details, edit, or delete them.
*   **Personal Dashboard**: A home screen that welcomes the user and displays a customizable chart visualizing workout progress (e.g., reps per week).
*   **Favorites**: Save preferred exercises to a "Favorites" list for quick access and easy addition to a workout plan.
*   **Leaderboards**: Compete with other users on leaderboards for metrics like most workouts, most reps, and longest workout duration.
*   **Profile Customization**: Personalize your profile with a profile picture and a bio.
*   **Achievements & Badges**: Unlock badges and achievements for reaching milestones, such as completing your first workout or maintaining a streak.
*   **Checklist**: Manage personal fitness goals and to-do items with a built-in checklist.

## Tech Stack & Architecture

### Technology Stack

*   **Framework**: Flutter
*   **Language**: Dart
*   **Backend**: Firebase
    *   **Firestore**: For storing user data, workout logs, favorites, and checklists.
    *   **Firebase Storage**: For hosting user-uploaded workout images.
*   **External APIs**: Utilizes `api.api-ninjas.com` to fetch a comprehensive list of exercises.
*   **Development Methodology**: Agile Scrum

### Architecture

The project is structured using the **Model-View-Presenter (MVP)** pattern:

*   **Model (`lib/model/`)**: Contains the data logic. It defines data structures (like `Workout`, `Exercise`, `Badge`) and handles all communication with Firebase and external APIs.
*   **View (`lib/view/`)**: Consists of the UI widgets and screens. It is responsible for displaying data to the user and capturing user input, which it then passes to the Presenter.
*   **Presenter (`lib/presenter/`)**: Acts as the bridge between the Model and the View. It receives events from the View, retrieves data from the Model, formats it, and passes it back to the View for display.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
*   A configured Firebase project.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/marcsaffold17/GetFitApp.git
    ```

2.  **Navigate to the project directory:**
    ```sh
    cd GetFitApp/get_fit_app
    ```

3.  **Set up Firebase:**
    *   Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    *   Add an Android and/or iOS app to your Firebase project.
    *   Follow the setup instructions to download your configuration files:
        *   For Android: `google-services.json` (place it in `android/app/`).
        *   For Flutter: Follow the FlutterFire CLI instructions to generate `lib/firebase_options.dart`.

4.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

5.  **Run the application:**
    ```sh
    flutter run
    ```

## Project Contributions

My individual contributions include:

*   **Add Workout Functionality**: Developed the UI and backend logic for the screen where users can manually add new workouts, including fields for type, duration, distance, and photo uploads to Firebase Storage (`lib/view/insert_workout_view.dart`).
*   **Workout History Screen**: Implemented the feature to display a user's complete workout history, grouped by date. This includes the ability to view, edit, and delete past workouts from Firestore (`lib/view/WorkoutHistory.dart`).
*   **Database Setup**: Designed and implemented the core Firebase Firestore database schema for storing user information, login credentials, and workout plans (`lib/model/`).
