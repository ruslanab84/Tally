# Tally — iOS Calculator & Converters

Дружелюбное iOS-приложение: калькулятор, конвертеры валют, единиц, температуры и т.д.

## Как открыть в Xcode

### 1. Создай новый проект

1. Открой Xcode
2. **File → New → Project**
3. Выбери **App** (iOS)
4. Заполни:
   - **Product Name:** `Tally`
   - **Team:** твой Apple ID
   - **Organization Identifier:** например `com.yourname`
   - **Interface:** SwiftUI
   - **Language:** Swift
5. Нажми **Create**, выбери папку

### 2. Добавь файлы

1. Удали дефолтный `ContentView.swift` из проекта
2. В Finder открой эту папку `Tally/`
3. Выдели ВСЕ файлы и папки:
   - `TallyApp.swift`
   - `Theme/` (папка)
   - `Views/` (папка)
   - `Models/` (папка)
4. Перетащи их в Xcode Navigator (левая панель)
5. В диалоге выбери:
   - ☑ Copy items if needed
   - ☑ Create groups
   - Target: Tally

### 3. Добавь шрифт JetBrains Mono

1. Скачай **JetBrains Mono** с https://fonts.google.com/specimen/JetBrains+Mono
2. Распакуй архив
3. Из папки `static/` возьми эти .ttf файлы:
   - `JetBrainsMono-Regular.ttf`
   - `JetBrainsMono-Medium.ttf`
   - `JetBrainsMono-SemiBold.ttf`
4. Перетащи их в Xcode Navigator
5. Убедись что ☑ **Copy items if needed** и ☑ **Target: Tally** выбраны
6. Открой `Info.plist` (или добавь в target → Info → Custom iOS Target Properties):

```
Fonts provided by application:
  - JetBrainsMono-Regular.ttf
  - JetBrainsMono-Medium.ttf
  - JetBrainsMono-SemiBold.ttf
```

Или добавь в `Info.plist` XML:
```xml
<key>UIAppFonts</key>
<array>
    <string>JetBrainsMono-Regular.ttf</string>
    <string>JetBrainsMono-Medium.ttf</string>
    <string>JetBrainsMono-SemiBold.ttf</string>
</array>
```

### 4. Запусти

1. Выбери симулятор (iPhone 15 Pro рекомендуется)
2. Нажми **⌘R** (Run)
3. Готово! 🎉

## Структура проекта

```
Tally/
├── TallyApp.swift           — @main, TabView, навигация
├── Theme/
│   └── Tokens.swift         — цвета, шрифты, радиусы, Environment
├── Models/
│   ├── Currency.swift       — 32 валюты со статическими курсами
│   ├── UnitCategory.swift   — 8 категорий единиц
│   └── HistoryItem.swift    — модели истории вычислений
└── Views/
    ├── HubView.swift        — главный экран с плитками
    ├── SimpleCalcView.swift — простой калькулятор
    ├── SciCalcView.swift    — научный (3 режима)
    ├── CurrencyView.swift   — конвертер валют
    ├── UnitsView.swift      — конвертер единиц
    ├── TempView.swift       — температура с градиентом
    ├── DateTimeView.swift   — дата/время + мировые часы
    ├── SizesView.swift      — размеры одежды
    ├── TipView.swift        — чаевые / разделить счёт
    ├── HistoryView.swift    — история вычислений
    └── SettingsView.swift   — настройки + тема
```

## Дизайн-токены

| Токен       | Light     | Dark      |
|-------------|-----------|-----------|
| bg          | #F2EFEA   | #0F0E0C   |
| surface     | #FFFFFF   | #1C1B19   |
| accent      | #FF8A00   | #FF8A00   |
| text        | #1A1A1A   | #FFFFFF   |
| radius      | 16-22px   | 16-22px   |
| fonts       | Inter (UI), JetBrains Mono (числа) |

## Minimum Deployment Target

**iOS 17.0** (использует `NavigationStack`, `@Observable`-ready patterns, `sensoryFeedback`)
