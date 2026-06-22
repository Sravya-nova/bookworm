# Bookworm: A Literary Sanctuary

Bookworm is a high-fidelity Flutter application designed for both avid readers and aspiring authors. It transforms the digital reading experience into a curated, interactive sanctuary where users can discover new worlds, track their reading journey, and craft their own masterpieces.

## 🌟 Key Features

### 📖 For Readers
*   **Curated Home Feed**: Personalized "Continue Reading" shortcuts and hand-picked recommendations using the Gutendex API.
*   **Swipe to Discover**: A Tinder-style book curation interface in the **Explore** tab. Swipe right to acquire classics or search for specific titles and authors.
*   **Live Library**: Integration with the **Gutendex JSON API**, providing access to thousands of public domain titles.
*   **In-App Reading**: Seamlessly "open" books to read them in HTML, PDF, or EPUB formats via external system readers.
*   **Reading Insights**: A dedicated **Stats** dashboard featuring:
    *   Reading streaks and daily consistency tracking.
    *   2024 Reading Goals with progress indicators.
    *   Dynamic **Genre Breakdown** and **Recently Finished** carousels.

### ✍️ For Authors
*   **Writing Studio**: A dedicated space to manage active drafts and start new literary projects with a distraction-free notepad editor.
*   **Author Hub**: A business dashboard for creators to track:
    *   Total royalties and reader engagement.
    *   Global **Reader Distribution** visualized via custom-painted pie charts.
    *   Publication management and analytics.
*   **Professional Profiles**: Customizable author profiles highlighting bios, published works count, and follower metrics.

### 🌐 Community
*   **The Daily Journal**: A literary dispatch feed featuring community posts, book vlogs, and trending discussions.
*   **Deep Integration**: Direct links to top literary communities on **Reddit** and book recommendations on **X (Twitter)**.

## 🛠️ Tech Stack
*   **Framework**: Flutter (Material 3)
*   **Language**: Dart
*   **Networking**: `http` package for REST API integration.
*   **Data Sources**: 
    *   [Gutendex API](https://gutendex.com/): Core book metadata and search.
    *   [Open Library API](https://openlibrary.org/dev/docs/api/covers): High-quality cover art for classic literature.
*   **UI/UX**: 
    *   **Google Fonts**: Noto Serif (Classic feel) and Public Sans (Modern clarity).
    *   **Custom Graphics**: Hand-painted Pie Charts and Dot-Grid Editorial backgrounds.
*   **Utilities**: `url_launcher` for social deep-linking and book reading.

## 📂 Project Structure
*   `lib/data/`: API services and mock data providers.
*   `lib/models/`: Type-safe models for Books, Authors, and Stats.
*   `lib/screens/`: Feature-specific screens (Home, Explore, Writing, Hub, etc.).
*   `lib/widgets/`: Reusable high-fidelity UI components.
*   `lib/theme/`: Centralized "Literary Sanctuary" color palette and typography.

## 🚀 Getting Started
1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/bookworm.git
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the application**:
    ```bash
    flutter run
    ```

---
*Created with ❤️ for bibliophiles and wordsmiths.*
