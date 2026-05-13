# Project Overview

This is an iOS application built with Swift and SwiftUI.

Application name: CalcPro

The app includes:
- Currency converter
- Unit converter
- Calculator
- Offline conversion support
- Dark mode support

---

# Tech Stack

- Swift 6
- SwiftUI
- MVVM Architecture
- Combine
- UserDefaults
- REST API
- XCTest

---

# Project Structure

- Views/
- ViewModels/
- Models/
- Services/
- Utils/
- Resources/

Business logic should not be placed inside Views.

---

# Architecture Rules

Use MVVM architecture.

Rules:
- Views contain UI only
- ViewModels contain presentation logic
- Services handle API and data processing
- Models represent data structures

Avoid massive ViewModels.

---

# UI Rules

- Use native SwiftUI components
- Follow Apple Human Interface Guidelines
- Support dark mode
- Support dynamic font sizes
- Keep UI minimal and modern

Primary colors:
- Black
- Orange

Use smooth animations where appropriate.

---

# Naming Conventions

Views:
- HomeView
- SciCalcView
- CurrencyView
- UnitsView
- TempView
- DateTimeView
- SizesView
- TipView
- FinanceView
- MIView
- EngineeringView

ViewModels:
- Currency
- CurrencyService
- EngineeringCategory
- HistoryItem
- UnitCategory

Services:
- CurrencyService
- NetworkService

---

# Networking

- Use async/await
- Use URLSession
- All networking code must be inside Services layer
- Handle API errors gracefully

---

# State Management

- Use @State for local state
- Use @StateObject for ViewModels
- Use @EnvironmentObject only when necessary

Avoid unnecessary global state.

---

# Performance Rules

- Avoid unnecessary re-renders
- Use LazyVStack where appropriate
- Optimize image sizes
- Avoid blocking the main thread

---

# Code Style

- Prefer readable code over clever code
- Use small reusable components
- Keep functions short
- Avoid force unwraps
- Use extensions for reusable logic

---

# Error Handling

- Show user-friendly error messages
- Log critical errors
- Never crash the app intentionally

---

# Testing

- Use XCTest
- Test ViewModels and Services
- Mock network calls in tests

Run tests:

```bash
xcodebuild test
```

---

# Build Commands

Run app:

```bash
open CalcPro.xcodeproj
```

Build project:

```bash
xcodebuild build
```

---

# Notes for Claude

- Generate production-ready SwiftUI code
- Prefer modern iOS APIs
- Keep UI clean and responsive
- Use reusable components
- Avoid UIKit unless necessary
- Follow Apple's best practices
- Explain non-obvious logic briefly
- Keep architecture scalable

---

# Git Rules

Commit message format:

```text
feat: add currency converter
fix: resolve dark mode issue
refactor: improve calculator logic
```

---

# Future Features

Planned:
- Crypto converter
- Widgets
- Apple Watch support
- Siri shortcuts
- iCloud sync
- Localization

Languages:
- English
- Russian
- Azerbaijani
- Spanish
- Portugal
- Turkish
- France
