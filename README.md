# 📘 Acronyms

An iOS application that allows users to search for the full forms of acronyms using a public API. This project demonstrates clean architecture, protocol-oriented programming, and modern concurrency using Swift's async/await.

![Platform](https://img.shields.io/badge/platform-iOS-lightgrey) ![Swift](https://img.shields.io/badge/Swift-5.0-orange) ![SwiftUI](https://img.shields.io/badge/SwiftUI-compatible-blue) ![License](https://img.shields.io/badge/license-MIT-green)

---

## 🚀 Features

Search acronyms using a remote API.

Debounced search input to reduce unnecessary network calls.

Error handling and loading state management.

Modular codebase following MVVM architecture.

Uses async/await with Swift Concurrency for networking and UI updates.

UIKit-based UI with UITableView for results display.



---
## Architecture
MVVM (Model-View-ViewModel): Keeps the view logic and business logic separate.

Networking Layer: A NetworkClient abstracts network calls.

Async/Await: Modern Swift concurrency for clean and responsive code.

MainActor Isolation: Ensures UI-bound state is updated on the main thread.

---

## 📲 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/rkamra-1404/Acronyms.git
2. Open the project in Xcode:
     open Acronyms.xcodeproj
3. Build and run the project:
    Select a simulator or connected device and click Run in Xcode.

## Project Structure
 ```bash
Acronyms/
├── Model/         # Data models
├── View/          # SwiftUI views
├── ViewModel/     # ViewModels for UI logic
├── Network/       # API service layer
└── Resources/     # Assets and app configuration
```

## Future Improvements
✅ Add XCTest-based unit testing

✅ Include UI snapshots for visual validation

⬇️ Implement local caching

📈 Show recent searches and autocomplete

💥 Improve error handling and offline support

📜 License
This project is licensed under the MIT License. See the LICENSE file for more information.

🙏 Acknowledgements
Apple Developer Documentation – For SwiftUI and Combine resources

Made with ❤️ by Rahul Kamra
