# Movie Browser

A production-quality Flutter application that allows users to search for movies using the OMDb API, view detailed information, and manage favorite movies. The app features robust offline fallback behavior, ensuring users can view previously loaded movie details even without a network connection.

## 🚀 Features
* **Movie Search:** Search for movies with a debounced input field.
* **Pagination:** Infinite scrolling for search results.
* **Search History:** Locally stored search history with the ability to remove items or clear all.
* **Offline Fallback:** Caches movie details locally. If the network fails, the app displays the cached version with a "Showing cached data" banner.
* **Favorites:** Save and manage favorite movies locally (swipe-to-delete support).
* **Localization:** Fully localized in English and Russian.

## 🛠 Tech Stack
* **Framework:** Flutter
* **State Management:** BLoC (`flutter_bloc`, `bloc_concurrency`)
* **Networking:** Dio
* **Local Storage:** Hive (`hive_ce`, `hive_ce_flutter`)
* **Code Generation:** `build_runner`
* **Localization:** Flutter Gen-L10n

## 🏗 Architecture
The project follows a pragmatic Clean Architecture approach to ensure maintainability and separation of concerns without over-engineering:
* **Presentation Layer:** Contains UI widgets and BLoC classes. UI depends only on state emitted by BLoCs.
* **Domain Layer:** Defines entities and repository interfaces/contracts.
* **Data Layer:** Handles external data sources. The `MovieRepository` acts as a single source of truth, coordinating between the `RemoteDataSource` (Dio) and `LocalDataSource` (Hive) to provide seamless offline caching.

## 🏃‍♂️ How to Run the Project

1. Get dependencies:
```bash
flutter pub get
```
Generate Hive adapters and Localization files:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```
flutter gen-l10n
Run the app with your OMDb API key:
```bash
flutter run --dart-define=OMDB_API_KEY=your_api_key_here
```
