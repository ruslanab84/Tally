import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case en, ru, de, es, fr

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: return "English"
        case .ru: return "Русский"
        case .de: return "Deutsch"
        case .es: return "Español"
        case .fr: return "Français"
        }
    }

    var flag: String {
        switch self {
        case .en: return "🇺🇸"
        case .ru: return "🇷🇺"
        case .de: return "🇩🇪"
        case .es: return "🇪🇸"
        case .fr: return "🇫🇷"
        }
    }
}

// MARK: - Localized Strings

struct Loc {
    // Tabs
    let tabHome: String
    let tabHistory: String
    let tabSettings: String

    // Common
    let done: String
    let cancel: String
    let from: String
    let to: String

    // Hub
    let hubSubtitle: String
    let hubRecent: String

    // Hub tiles
    let tileSimple: String
    let tileSimpleSub: String
    let tileScientific: String
    let tileScientificSub: String
    let tileCurrency: String
    let tileCurrencySub: String
    let tileUnits: String
    let tileUnitsSub: String
    let tileTemp: String
    let tileTempSub: String
    let tileDateTime: String
    let tileDateTimeSub: String
    let tileClothing: String
    let tileClothingSub: String
    let tileTip: String
    let tileTipSub: String
    let tileFinance: String
    let tileFinanceSub: String
    let tileBMI: String
    let tileBMISub: String
    let tileEngineering: String
    let tileEngineeringSub: String

    // Calculator
    let navCalculator: String

    // Scientific
    let navScientific: String
    let sciModeSci: String
    let sciModeProg: String
    let sciModeGraph: String
    let graphRange: String
    let graphStep: String

    // Currency
    let navCurrency: String
    let popular: String
    let allCurrencies: String
    let selectCurrency: String
    let searchCurrencies: String

    // Units / Engineering
    let navUnits: String
    let navEngineering: String
    let allConversions: String
    let categories: String

    // Temperature
    let navTemp: String
    let celsius: String
    let fahrenheit: String
    let kelvin: String
    let reference: String
    let tempExtremeCold: String
    let tempBelowFreezing: String
    let tempCold: String
    let tempCool: String
    let tempComfortable: String
    let tempWarm: String
    let tempHot: String
    let tempExtremeHeat: String

    // Date & Time
    let navDateTime: String
    let difference: String
    let worldClock: String
    let today: String
    let tomorrow: String
    let yesterday: String
    let days: String
    let months: String
    let weeks: String

    // Sizes
    let navClothing: String
    let shirts: String
    let pants: String
    let shoes: String
    let kids: String
    let mens: String
    let womens: String
    let selectYourSize: String
    let conversions: String

    // Tip
    let navTip: String
    let billAmount: String
    let tip: String
    let total: String
    let splitBetween: String
    let people: String
    let eachPays: String

    // Finance
    let navFinance: String
    let loan: String
    let deposit: String
    let loanAmount: String
    let annualRate: String
    let term: String
    let monthlyPayment: String
    let principal: String
    let totalInterest: String
    let totalPaid: String
    let interest: String
    let paymentSchedule: String
    let monthly: String
    let yearly: String
    let year: String
    let balance: String
    let initialDeposit: String
    let monthlyContribution: String
    let capitalization: String
    let quarter: String
    let semiAnnual: String
    let annual: String
    let finalAmount: String
    let totalDeposited: String
    let interestEarned: String
    let effectiveRate: String
    let yearlyGrowth: String
    let deposited: String
    let added: String
    let capitaliz: String

    // BMI
    let navBMI: String
    let metric: String
    let imperial: String
    let man: String
    let woman: String
    let age: String
    let weight: String
    let height: String
    let yourBMI: String
    let estBodyFat: String
    let healthyRange: String
    let underweight: String
    let normal: String
    let overweight: String
    let obese: String
    let underweightDesc: String
    let normalDesc: String
    let overweightDesc: String
    let obeseDesc: String
    let essentialFat: String
    let athletes: String
    let fitness: String
    let average: String
    let aboveAverage: String
    let bmiChildNote: String
    let bmiElderlyNote: String

    // History
    let navHistory: String
    let searchHistory: String

    // Settings
    let navSettings: String
    let appearance: String
    let theme: String
    let light: String
    let dark: String
    let system: String
    let accent: String
    let appIcon: String
    let defaultVal: String
    let language: String
    let appLanguage: String
    let numberFormat: String
    let decimalPrecision: String
    let digits: String
    let calculator: String
    let hapticFeedback: String
    let sound: String
    let livePreview: String
    let angleUnits: String
    let degrees: String
    let conversionsSection: String
    let defaultCurrency: String
    let favoriteUnits: String
    let selected: String
    let updateRates: String
    let daily: String
    let about: String
    let version: String
    let privacy: String
    let sendFeedback: String

    // Engineering category labels
    let engTime: String
    let engAcceleration: String
    let engDensity: String
    let engPressure: String
    let engEnergy: String
    let engPower: String
    let engForce: String
    let engAngle: String
    let engWireGauge: String
    let engRotation: String
    let engTorque: String
    let engTempDiff: String
    let engVolumeFlow: String
    let engMassFlow: String
    let engIlluminance: String
    let engRadiation: String
    let engRadioactivity: String
}

// MARK: - English

extension Loc {
    static let en = Loc(
        tabHome: "Home", tabHistory: "History", tabSettings: "Settings",
        done: "Done", cancel: "Cancel", from: "FROM", to: "TO",
        hubSubtitle: "Calculator & converters", hubRecent: "RECENT",
        tileSimple: "Simple", tileSimpleSub: "Basic calc",
        tileScientific: "Scientific", tileScientificSub: "Advanced",
        tileCurrency: "Currency", tileCurrencySub: "62 currencies",
        tileUnits: "Units", tileUnitsSub: "Length, mass…",
        tileTemp: "Temperature", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "Date & Time", tileDateTimeSub: "Timezones",
        tileClothing: "Clothing", tileClothingSub: "EU · US · UK",
        tileTip: "Tip & %", tileTipSub: "Split bill",
        tileFinance: "Finance", tileFinanceSub: "Loan & deposit",
        tileBMI: "BMI", tileBMISub: "Body mass index",
        tileEngineering: "Engineering", tileEngineeringSub: "17 converters",
        navCalculator: "Calculator",
        navScientific: "Scientific", sciModeSci: "Scientific", sciModeProg: "Programmer", sciModeGraph: "Graph",
        graphRange: "Range", graphStep: "Step",
        navCurrency: "Currency", popular: "POPULAR", allCurrencies: "All currencies",
        selectCurrency: "Select Currency", searchCurrencies: "Search currencies",
        navUnits: "Units", navEngineering: "Engineering", allConversions: "ALL CONVERSIONS", categories: "CATEGORIES",
        navTemp: "Temperature", celsius: "Celsius", fahrenheit: "Fahrenheit", kelvin: "Kelvin",
        reference: "Reference",
        tempExtremeCold: "Extreme cold", tempBelowFreezing: "Below freezing", tempCold: "Cold", tempCool: "Cool",
        tempComfortable: "Comfortable room temp", tempWarm: "Warm", tempHot: "Hot", tempExtremeHeat: "Extreme heat",
        navDateTime: "Date & Time", difference: "DIFFERENCE", worldClock: "WORLD CLOCK",
        today: "Today", tomorrow: "Tomorrow", yesterday: "Yesterday",
        days: "days", months: "months", weeks: "weeks",
        navClothing: "Clothing", shirts: "Shirts", pants: "Pants", shoes: "Shoes", kids: "Kids",
        mens: "Men's", womens: "Women's", selectYourSize: "SELECT YOUR SIZE", conversions: "CONVERSIONS",
        navTip: "Tip & Split", billAmount: "BILL AMOUNT", tip: "Tip", total: "Total",
        splitBetween: "Split between", people: "people", eachPays: "Each pays",
        navFinance: "Finance", loan: "Loan", deposit: "Deposit",
        loanAmount: "LOAN AMOUNT", annualRate: "ANNUAL RATE", term: "TERM",
        monthlyPayment: "MONTHLY PAYMENT", principal: "Principal", totalInterest: "Total Interest",
        totalPaid: "Total Paid", interest: "Interest", paymentSchedule: "PAYMENT SCHEDULE",
        monthly: "Monthly", yearly: "Yearly", year: "Year", balance: "Balance",
        initialDeposit: "INITIAL DEPOSIT", monthlyContribution: "MONTHLY CONTRIBUTION",
        capitalization: "CAPITALIZATION", quarter: "Quarter", semiAnnual: "Semi", annual: "Annual",
        finalAmount: "FINAL AMOUNT", totalDeposited: "Total Deposited", interestEarned: "Interest Earned",
        effectiveRate: "Effective Rate", yearlyGrowth: "YEARLY GROWTH",
        deposited: "Deposited", added: "Added", capitaliz: "capitalization",
        navBMI: "BMI", metric: "Metric", imperial: "Imperial", man: "Man", woman: "Woman",
        age: "AGE", weight: "WEIGHT", height: "HEIGHT", yourBMI: "YOUR BMI",
        estBodyFat: "Est. Body Fat", healthyRange: "Healthy range",
        underweight: "Underweight", normal: "Normal", overweight: "Overweight", obese: "Obese",
        underweightDesc: "Below the healthy weight range", normalDesc: "Within the healthy weight range",
        overweightDesc: "Above the healthy weight range", obeseDesc: "Well above the healthy weight range",
        essentialFat: "Essential fat", athletes: "Athletes", fitness: "Fitness", average: "Average", aboveAverage: "Above average",
        bmiChildNote: "For children and teens, BMI is interpreted using age-specific percentile charts. Consult a pediatrician.",
        bmiElderlyNote: "For adults 65+, a slightly higher BMI (23–30) may be protective. Consult your doctor.",
        navHistory: "History", searchHistory: "Search history",
        navSettings: "Settings", appearance: "Appearance", theme: "Theme",
        light: "Light", dark: "Dark", system: "System",
        accent: "Accent", appIcon: "App icon", defaultVal: "Default",
        language: "Language", appLanguage: "App language",
        numberFormat: "Number format", decimalPrecision: "Decimal precision", digits: "digits",
        calculator: "Calculator", hapticFeedback: "Haptic feedback", sound: "Sound",
        livePreview: "Live preview", angleUnits: "Angle units", degrees: "Degrees",
        conversionsSection: "Conversions", defaultCurrency: "Default currency",
        favoriteUnits: "Favorite units", selected: "selected", updateRates: "Update rates", daily: "Daily",
        about: "About", version: "Version", privacy: "Privacy", sendFeedback: "Send feedback",
        engTime: "Time", engAcceleration: "Acceleration", engDensity: "Density",
        engPressure: "Pressure", engEnergy: "Energy & Work", engPower: "Power",
        engForce: "Force", engAngle: "Angle", engWireGauge: "Wire Gauge",
        engRotation: "Rotation Speed", engTorque: "Torque", engTempDiff: "Temp Difference",
        engVolumeFlow: "Volume Flow", engMassFlow: "Mass Flow", engIlluminance: "Illuminance",
        engRadiation: "Radiation", engRadioactivity: "Radioactivity"
    )
}

// MARK: - Russian

extension Loc {
    static let ru = Loc(
        tabHome: "Главная", tabHistory: "История", tabSettings: "Настройки",
        done: "Готово", cancel: "Отмена", from: "ИЗ", to: "В",
        hubSubtitle: "Калькулятор и конвертеры", hubRecent: "НЕДАВНЕЕ",
        tileSimple: "Простой", tileSimpleSub: "Калькулятор",
        tileScientific: "Научный", tileScientificSub: "Расширенный",
        tileCurrency: "Валюта", tileCurrencySub: "62 валюты",
        tileUnits: "Единицы", tileUnitsSub: "Длина, масса…",
        tileTemp: "Температура", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "Дата и время", tileDateTimeSub: "Часовые пояса",
        tileClothing: "Одежда", tileClothingSub: "EU · US · UK",
        tileTip: "Чаевые", tileTipSub: "Разделить счёт",
        tileFinance: "Финансы", tileFinanceSub: "Кредит и вклад",
        tileBMI: "ИМТ", tileBMISub: "Индекс массы тела",
        tileEngineering: "Инженерные", tileEngineeringSub: "17 конвертеров",
        navCalculator: "Калькулятор",
        navScientific: "Научный", sciModeSci: "Научный", sciModeProg: "Программист", sciModeGraph: "График",
        graphRange: "Диапазон", graphStep: "Шаг",
        navCurrency: "Валюта", popular: "ПОПУЛЯРНЫЕ", allCurrencies: "Все валюты",
        selectCurrency: "Выбрать валюту", searchCurrencies: "Поиск валют",
        navUnits: "Единицы", navEngineering: "Инженерные", allConversions: "ВСЕ КОНВЕРТАЦИИ", categories: "КАТЕГОРИИ",
        navTemp: "Температура", celsius: "Цельсий", fahrenheit: "Фаренгейт", kelvin: "Кельвин",
        reference: "Справка",
        tempExtremeCold: "Экстремальный холод", tempBelowFreezing: "Ниже нуля", tempCold: "Холодно", tempCool: "Прохладно",
        tempComfortable: "Комфортная температура", tempWarm: "Тепло", tempHot: "Жарко", tempExtremeHeat: "Экстремальная жара",
        navDateTime: "Дата и время", difference: "РАЗНИЦА", worldClock: "МИРОВОЕ ВРЕМЯ",
        today: "Сегодня", tomorrow: "Завтра", yesterday: "Вчера",
        days: "дней", months: "мес.", weeks: "нед.",
        navClothing: "Одежда", shirts: "Рубашки", pants: "Брюки", shoes: "Обувь", kids: "Детское",
        mens: "Мужское", womens: "Женское", selectYourSize: "ВЫБЕРИТЕ РАЗМЕР", conversions: "КОНВЕРТАЦИЯ",
        navTip: "Чаевые", billAmount: "СУММА СЧЁТА", tip: "Чаевые", total: "Итого",
        splitBetween: "Разделить на", people: "чел.", eachPays: "Каждый платит",
        navFinance: "Финансы", loan: "Кредит", deposit: "Вклад",
        loanAmount: "СУММА КРЕДИТА", annualRate: "ГОДОВАЯ СТАВКА", term: "СРОК",
        monthlyPayment: "ЕЖЕМЕСЯЧНЫЙ ПЛАТЁЖ", principal: "Основной долг", totalInterest: "Всего процентов",
        totalPaid: "Всего выплачено", interest: "Проценты", paymentSchedule: "ГРАФИК ПЛАТЕЖЕЙ",
        monthly: "Помесячно", yearly: "По годам", year: "Год", balance: "Остаток",
        initialDeposit: "НАЧАЛЬНЫЙ ВКЛАД", monthlyContribution: "ЕЖЕМЕСЯЧНОЕ ПОПОЛНЕНИЕ",
        capitalization: "КАПИТАЛИЗАЦИЯ", quarter: "Квартал", semiAnnual: "Полугод.", annual: "Годовая",
        finalAmount: "ИТОГОВАЯ СУММА", totalDeposited: "Всего внесено", interestEarned: "Начислено процентов",
        effectiveRate: "Эффективная ставка", yearlyGrowth: "РОСТ ПО ГОДАМ",
        deposited: "Внесено", added: "Добавлено", capitaliz: "капитализация",
        navBMI: "ИМТ", metric: "Метрич.", imperial: "Имперск.", man: "Мужчина", woman: "Женщина",
        age: "ВОЗРАСТ", weight: "ВЕС", height: "РОСТ", yourBMI: "ВАШ ИМТ",
        estBodyFat: "Жир (оценка)", healthyRange: "Здоровый диапазон",
        underweight: "Недовес", normal: "Норма", overweight: "Избыточный вес", obese: "Ожирение",
        underweightDesc: "Ниже здорового диапазона", normalDesc: "В пределах здорового диапазона",
        overweightDesc: "Выше здорового диапазона", obeseDesc: "Значительно выше нормы",
        essentialFat: "Необходимый жир", athletes: "Атлеты", fitness: "Фитнес", average: "Средний", aboveAverage: "Выше среднего",
        bmiChildNote: "Для детей и подростков ИМТ интерпретируется по возрастным перцентильным таблицам. Обратитесь к педиатру.",
        bmiElderlyNote: "Для людей 65+ немного повышенный ИМТ (23–30) может быть защитным. Проконсультируйтесь с врачом.",
        navHistory: "История", searchHistory: "Поиск в истории",
        navSettings: "Настройки", appearance: "Оформление", theme: "Тема",
        light: "Светлая", dark: "Тёмная", system: "Система",
        accent: "Акцент", appIcon: "Иконка", defaultVal: "По умолч.",
        language: "Язык", appLanguage: "Язык приложения",
        numberFormat: "Формат чисел", decimalPrecision: "Точность", digits: "знаков",
        calculator: "Калькулятор", hapticFeedback: "Вибрация", sound: "Звук",
        livePreview: "Предпросмотр", angleUnits: "Ед. углов", degrees: "Градусы",
        conversionsSection: "Конвертация", defaultCurrency: "Валюта по умолч.",
        favoriteUnits: "Избранные ед.", selected: "выбрано", updateRates: "Обновление курсов", daily: "Ежедневно",
        about: "О приложении", version: "Версия", privacy: "Конфиденциальность", sendFeedback: "Обратная связь",
        engTime: "Время", engAcceleration: "Ускорение", engDensity: "Плотность",
        engPressure: "Давление", engEnergy: "Энергия, работа", engPower: "Мощность",
        engForce: "Сила", engAngle: "Угловая мера", engWireGauge: "Калибр проводов",
        engRotation: "Скорость вращения", engTorque: "Крутящий момент", engTempDiff: "Разница температур",
        engVolumeFlow: "Расход объёмный", engMassFlow: "Расход массовый", engIlluminance: "Освещённость",
        engRadiation: "Радиация", engRadioactivity: "Радиоактивность"
    )
}

// MARK: - German

extension Loc {
    static let de = Loc(
        tabHome: "Start", tabHistory: "Verlauf", tabSettings: "Einstellungen",
        done: "Fertig", cancel: "Abbrechen", from: "VON", to: "NACH",
        hubSubtitle: "Rechner & Umrechner", hubRecent: "ZULETZT",
        tileSimple: "Einfach", tileSimpleSub: "Taschenrechner",
        tileScientific: "Wissenschaft", tileScientificSub: "Erweitert",
        tileCurrency: "Währung", tileCurrencySub: "62 Währungen",
        tileUnits: "Einheiten", tileUnitsSub: "Länge, Masse…",
        tileTemp: "Temperatur", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "Datum & Zeit", tileDateTimeSub: "Zeitzonen",
        tileClothing: "Kleidung", tileClothingSub: "EU · US · UK",
        tileTip: "Trinkgeld", tileTipSub: "Rechnung teilen",
        tileFinance: "Finanzen", tileFinanceSub: "Kredit & Einlage",
        tileBMI: "BMI", tileBMISub: "Body-Mass-Index",
        tileEngineering: "Ingenieur", tileEngineeringSub: "17 Umrechner",
        navCalculator: "Rechner",
        navScientific: "Wissenschaft", sciModeSci: "Wissenschaftl.", sciModeProg: "Programmierer", sciModeGraph: "Graph",
        graphRange: "Bereich", graphStep: "Schritt",
        navCurrency: "Währung", popular: "BELIEBT", allCurrencies: "Alle Währungen",
        selectCurrency: "Währung wählen", searchCurrencies: "Währung suchen",
        navUnits: "Einheiten", navEngineering: "Ingenieur", allConversions: "ALLE UMRECHNUNGEN", categories: "KATEGORIEN",
        navTemp: "Temperatur", celsius: "Celsius", fahrenheit: "Fahrenheit", kelvin: "Kelvin",
        reference: "Referenz",
        tempExtremeCold: "Extreme Kälte", tempBelowFreezing: "Unter Null", tempCold: "Kalt", tempCool: "Kühl",
        tempComfortable: "Angenehme Raumtemp.", tempWarm: "Warm", tempHot: "Heiß", tempExtremeHeat: "Extreme Hitze",
        navDateTime: "Datum & Zeit", difference: "DIFFERENZ", worldClock: "WELTZEIT",
        today: "Heute", tomorrow: "Morgen", yesterday: "Gestern",
        days: "Tage", months: "Mon.", weeks: "Wo.",
        navClothing: "Kleidung", shirts: "Hemden", pants: "Hosen", shoes: "Schuhe", kids: "Kinder",
        mens: "Herren", womens: "Damen", selectYourSize: "GRÖSSE WÄHLEN", conversions: "UMRECHNUNGEN",
        navTip: "Trinkgeld", billAmount: "RECHNUNGSBETRAG", tip: "Trinkgeld", total: "Gesamt",
        splitBetween: "Teilen auf", people: "Pers.", eachPays: "Jeder zahlt",
        navFinance: "Finanzen", loan: "Kredit", deposit: "Einlage",
        loanAmount: "KREDITBETRAG", annualRate: "JAHRESZINS", term: "LAUFZEIT",
        monthlyPayment: "MONATLICHE RATE", principal: "Tilgung", totalInterest: "Zinsen gesamt",
        totalPaid: "Gesamt gezahlt", interest: "Zinsen", paymentSchedule: "ZAHLUNGSPLAN",
        monthly: "Monatlich", yearly: "Jährlich", year: "Jahr", balance: "Restschuld",
        initialDeposit: "ANFANGSEINLAGE", monthlyContribution: "MONATL. EINZAHLUNG",
        capitalization: "KAPITALISIERUNG", quarter: "Quartal", semiAnnual: "Halbjahr", annual: "Jährlich",
        finalAmount: "ENDBETRAG", totalDeposited: "Gesamt eingezahlt", interestEarned: "Zinserträge",
        effectiveRate: "Effektivzins", yearlyGrowth: "JÄHRL. WACHSTUM",
        deposited: "Eingezahlt", added: "Hinzugefügt", capitaliz: "Kapitalisierung",
        navBMI: "BMI", metric: "Metrisch", imperial: "Imperial", man: "Mann", woman: "Frau",
        age: "ALTER", weight: "GEWICHT", height: "GRÖSSE", yourBMI: "IHR BMI",
        estBodyFat: "Körperfett (ca.)", healthyRange: "Gesunder Bereich",
        underweight: "Untergewicht", normal: "Normalgewicht", overweight: "Übergewicht", obese: "Adipositas",
        underweightDesc: "Unter dem gesunden Bereich", normalDesc: "Im gesunden Bereich",
        overweightDesc: "Über dem gesunden Bereich", obeseDesc: "Deutlich über dem gesunden Bereich",
        essentialFat: "Essentielles Fett", athletes: "Athleten", fitness: "Fitness", average: "Durchschnitt", aboveAverage: "Überdurchschnitt",
        bmiChildNote: "Für Kinder und Jugendliche wird der BMI anhand altersabhängiger Perzentilkurven bewertet. Fragen Sie Ihren Kinderarzt.",
        bmiElderlyNote: "Für Erwachsene 65+ kann ein leicht erhöhter BMI (23–30) schützend wirken. Fragen Sie Ihren Arzt.",
        navHistory: "Verlauf", searchHistory: "Verlauf durchsuchen",
        navSettings: "Einstellungen", appearance: "Darstellung", theme: "Design",
        light: "Hell", dark: "Dunkel", system: "System",
        accent: "Akzent", appIcon: "App-Symbol", defaultVal: "Standard",
        language: "Sprache", appLanguage: "App-Sprache",
        numberFormat: "Zahlenformat", decimalPrecision: "Dezimalstellen", digits: "Stellen",
        calculator: "Rechner", hapticFeedback: "Haptik", sound: "Ton",
        livePreview: "Vorschau", angleUnits: "Winkeleinheit", degrees: "Grad",
        conversionsSection: "Umrechnungen", defaultCurrency: "Standardwährung",
        favoriteUnits: "Favoriteneinheiten", selected: "gewählt", updateRates: "Kurse aktualisieren", daily: "Täglich",
        about: "Über", version: "Version", privacy: "Datenschutz", sendFeedback: "Feedback senden",
        engTime: "Zeit", engAcceleration: "Beschleunigung", engDensity: "Dichte",
        engPressure: "Druck", engEnergy: "Energie & Arbeit", engPower: "Leistung",
        engForce: "Kraft", engAngle: "Winkel", engWireGauge: "Drahtquerschnitt",
        engRotation: "Drehzahl", engTorque: "Drehmoment", engTempDiff: "Temp.-Differenz",
        engVolumeFlow: "Volumenstrom", engMassFlow: "Massenstrom", engIlluminance: "Beleuchtungsstärke",
        engRadiation: "Strahlung", engRadioactivity: "Radioaktivität"
    )
}

// MARK: - Spanish

extension Loc {
    static let es = Loc(
        tabHome: "Inicio", tabHistory: "Historial", tabSettings: "Ajustes",
        done: "Listo", cancel: "Cancelar", from: "DE", to: "A",
        hubSubtitle: "Calculadora y convertidores", hubRecent: "RECIENTE",
        tileSimple: "Simple", tileSimpleSub: "Calculadora",
        tileScientific: "Científica", tileScientificSub: "Avanzada",
        tileCurrency: "Moneda", tileCurrencySub: "62 monedas",
        tileUnits: "Unidades", tileUnitsSub: "Longitud, masa…",
        tileTemp: "Temperatura", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "Fecha y hora", tileDateTimeSub: "Zonas horarias",
        tileClothing: "Ropa", tileClothingSub: "EU · US · UK",
        tileTip: "Propina", tileTipSub: "Dividir cuenta",
        tileFinance: "Finanzas", tileFinanceSub: "Préstamo y depósito",
        tileBMI: "IMC", tileBMISub: "Índice de masa",
        tileEngineering: "Ingeniería", tileEngineeringSub: "17 convertidores",
        navCalculator: "Calculadora",
        navScientific: "Científica", sciModeSci: "Científica", sciModeProg: "Programador", sciModeGraph: "Gráfica",
        graphRange: "Rango", graphStep: "Paso",
        navCurrency: "Moneda", popular: "POPULARES", allCurrencies: "Todas las monedas",
        selectCurrency: "Elegir moneda", searchCurrencies: "Buscar monedas",
        navUnits: "Unidades", navEngineering: "Ingeniería", allConversions: "TODAS LAS CONVERSIONES", categories: "CATEGORÍAS",
        navTemp: "Temperatura", celsius: "Celsius", fahrenheit: "Fahrenheit", kelvin: "Kelvin",
        reference: "Referencia",
        tempExtremeCold: "Frío extremo", tempBelowFreezing: "Bajo cero", tempCold: "Frío", tempCool: "Fresco",
        tempComfortable: "Temperatura agradable", tempWarm: "Cálido", tempHot: "Caliente", tempExtremeHeat: "Calor extremo",
        navDateTime: "Fecha y hora", difference: "DIFERENCIA", worldClock: "HORA MUNDIAL",
        today: "Hoy", tomorrow: "Mañana", yesterday: "Ayer",
        days: "días", months: "meses", weeks: "sem.",
        navClothing: "Ropa", shirts: "Camisas", pants: "Pantalones", shoes: "Zapatos", kids: "Niños",
        mens: "Hombre", womens: "Mujer", selectYourSize: "ELIGE TU TALLA", conversions: "CONVERSIONES",
        navTip: "Propina", billAmount: "MONTO DE CUENTA", tip: "Propina", total: "Total",
        splitBetween: "Dividir entre", people: "pers.", eachPays: "Cada uno paga",
        navFinance: "Finanzas", loan: "Préstamo", deposit: "Depósito",
        loanAmount: "MONTO DEL PRÉSTAMO", annualRate: "TASA ANUAL", term: "PLAZO",
        monthlyPayment: "PAGO MENSUAL", principal: "Capital", totalInterest: "Interés total",
        totalPaid: "Total pagado", interest: "Interés", paymentSchedule: "CALENDARIO DE PAGOS",
        monthly: "Mensual", yearly: "Anual", year: "Año", balance: "Saldo",
        initialDeposit: "DEPÓSITO INICIAL", monthlyContribution: "APORTE MENSUAL",
        capitalization: "CAPITALIZACIÓN", quarter: "Trimest.", semiAnnual: "Semest.", annual: "Anual",
        finalAmount: "MONTO FINAL", totalDeposited: "Total depositado", interestEarned: "Intereses ganados",
        effectiveRate: "Tasa efectiva", yearlyGrowth: "CRECIMIENTO ANUAL",
        deposited: "Depositado", added: "Añadido", capitaliz: "capitalización",
        navBMI: "IMC", metric: "Métrico", imperial: "Imperial", man: "Hombre", woman: "Mujer",
        age: "EDAD", weight: "PESO", height: "ALTURA", yourBMI: "TU IMC",
        estBodyFat: "Grasa est.", healthyRange: "Rango saludable",
        underweight: "Bajo peso", normal: "Normal", overweight: "Sobrepeso", obese: "Obesidad",
        underweightDesc: "Por debajo del rango saludable", normalDesc: "Dentro del rango saludable",
        overweightDesc: "Por encima del rango saludable", obeseDesc: "Muy por encima del rango saludable",
        essentialFat: "Grasa esencial", athletes: "Atletas", fitness: "Fitness", average: "Promedio", aboveAverage: "Sobre promedio",
        bmiChildNote: "Para niños y adolescentes, el IMC se interpreta usando tablas de percentiles por edad. Consulte a un pediatra.",
        bmiElderlyNote: "Para adultos de 65+, un IMC ligeramente más alto (23–30) puede ser protector. Consulte a su médico.",
        navHistory: "Historial", searchHistory: "Buscar en historial",
        navSettings: "Ajustes", appearance: "Apariencia", theme: "Tema",
        light: "Claro", dark: "Oscuro", system: "Sistema",
        accent: "Acento", appIcon: "Icono de app", defaultVal: "Predeterminado",
        language: "Idioma", appLanguage: "Idioma de la app",
        numberFormat: "Formato numérico", decimalPrecision: "Precisión decimal", digits: "dígitos",
        calculator: "Calculadora", hapticFeedback: "Vibración", sound: "Sonido",
        livePreview: "Vista previa", angleUnits: "Unidad de ángulo", degrees: "Grados",
        conversionsSection: "Conversiones", defaultCurrency: "Moneda predeterminada",
        favoriteUnits: "Unidades favoritas", selected: "seleccionadas", updateRates: "Actualizar tasas", daily: "Diario",
        about: "Acerca de", version: "Versión", privacy: "Privacidad", sendFeedback: "Enviar comentarios",
        engTime: "Tiempo", engAcceleration: "Aceleración", engDensity: "Densidad",
        engPressure: "Presión", engEnergy: "Energía y trabajo", engPower: "Potencia",
        engForce: "Fuerza", engAngle: "Ángulo", engWireGauge: "Calibre de cable",
        engRotation: "Vel. rotación", engTorque: "Par motor", engTempDiff: "Dif. temperatura",
        engVolumeFlow: "Caudal volumétrico", engMassFlow: "Caudal másico", engIlluminance: "Iluminancia",
        engRadiation: "Radiación", engRadioactivity: "Radiactividad"
    )
}

// MARK: - French

extension Loc {
    static let fr = Loc(
        tabHome: "Accueil", tabHistory: "Historique", tabSettings: "Réglages",
        done: "Terminé", cancel: "Annuler", from: "DE", to: "À",
        hubSubtitle: "Calculatrice et convertisseurs", hubRecent: "RÉCENT",
        tileSimple: "Simple", tileSimpleSub: "Calculatrice",
        tileScientific: "Scientifique", tileScientificSub: "Avancé",
        tileCurrency: "Devises", tileCurrencySub: "62 devises",
        tileUnits: "Unités", tileUnitsSub: "Longueur, masse…",
        tileTemp: "Température", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "Date et heure", tileDateTimeSub: "Fuseaux horaires",
        tileClothing: "Vêtements", tileClothingSub: "EU · US · UK",
        tileTip: "Pourboire", tileTipSub: "Partager l'addition",
        tileFinance: "Finance", tileFinanceSub: "Prêt et dépôt",
        tileBMI: "IMC", tileBMISub: "Indice de masse",
        tileEngineering: "Ingénierie", tileEngineeringSub: "17 convertisseurs",
        navCalculator: "Calculatrice",
        navScientific: "Scientifique", sciModeSci: "Scientifique", sciModeProg: "Programmeur", sciModeGraph: "Graphique",
        graphRange: "Plage", graphStep: "Pas",
        navCurrency: "Devises", popular: "POPULAIRES", allCurrencies: "Toutes les devises",
        selectCurrency: "Choisir une devise", searchCurrencies: "Rechercher des devises",
        navUnits: "Unités", navEngineering: "Ingénierie", allConversions: "TOUTES LES CONVERSIONS", categories: "CATÉGORIES",
        navTemp: "Température", celsius: "Celsius", fahrenheit: "Fahrenheit", kelvin: "Kelvin",
        reference: "Référence",
        tempExtremeCold: "Froid extrême", tempBelowFreezing: "Sous zéro", tempCold: "Froid", tempCool: "Frais",
        tempComfortable: "Température agréable", tempWarm: "Chaud", tempHot: "Très chaud", tempExtremeHeat: "Chaleur extrême",
        navDateTime: "Date et heure", difference: "DIFFÉRENCE", worldClock: "HEURE MONDIALE",
        today: "Aujourd'hui", tomorrow: "Demain", yesterday: "Hier",
        days: "jours", months: "mois", weeks: "sem.",
        navClothing: "Vêtements", shirts: "Chemises", pants: "Pantalons", shoes: "Chaussures", kids: "Enfants",
        mens: "Hommes", womens: "Femmes", selectYourSize: "CHOISIR VOTRE TAILLE", conversions: "CONVERSIONS",
        navTip: "Pourboire", billAmount: "MONTANT", tip: "Pourboire", total: "Total",
        splitBetween: "Partager entre", people: "pers.", eachPays: "Chacun paie",
        navFinance: "Finance", loan: "Prêt", deposit: "Dépôt",
        loanAmount: "MONTANT DU PRÊT", annualRate: "TAUX ANNUEL", term: "DURÉE",
        monthlyPayment: "MENSUALITÉ", principal: "Capital", totalInterest: "Intérêts totaux",
        totalPaid: "Total payé", interest: "Intérêts", paymentSchedule: "ÉCHÉANCIER",
        monthly: "Mensuel", yearly: "Annuel", year: "Année", balance: "Solde",
        initialDeposit: "DÉPÔT INITIAL", monthlyContribution: "VERSEMENT MENSUEL",
        capitalization: "CAPITALISATION", quarter: "Trimestr.", semiAnnual: "Semestr.", annual: "Annuel",
        finalAmount: "MONTANT FINAL", totalDeposited: "Total déposé", interestEarned: "Intérêts gagnés",
        effectiveRate: "Taux effectif", yearlyGrowth: "CROISSANCE ANNUELLE",
        deposited: "Déposé", added: "Ajouté", capitaliz: "capitalisation",
        navBMI: "IMC", metric: "Métrique", imperial: "Impérial", man: "Homme", woman: "Femme",
        age: "ÂGE", weight: "POIDS", height: "TAILLE", yourBMI: "VOTRE IMC",
        estBodyFat: "Graisse est.", healthyRange: "Plage saine",
        underweight: "Insuffisance", normal: "Normal", overweight: "Surpoids", obese: "Obésité",
        underweightDesc: "En dessous de la plage saine", normalDesc: "Dans la plage saine",
        overweightDesc: "Au-dessus de la plage saine", obeseDesc: "Bien au-dessus de la plage saine",
        essentialFat: "Graisse essentielle", athletes: "Athlètes", fitness: "Fitness", average: "Moyen", aboveAverage: "Au-dessus de la moyenne",
        bmiChildNote: "Pour les enfants et adolescents, l'IMC est interprété à l'aide de courbes de percentiles par âge. Consultez un pédiatre.",
        bmiElderlyNote: "Pour les adultes de 65+, un IMC légèrement plus élevé (23–30) peut être protecteur. Consultez votre médecin.",
        navHistory: "Historique", searchHistory: "Rechercher dans l'historique",
        navSettings: "Réglages", appearance: "Apparence", theme: "Thème",
        light: "Clair", dark: "Sombre", system: "Système",
        accent: "Accent", appIcon: "Icône", defaultVal: "Par défaut",
        language: "Langue", appLanguage: "Langue de l'app",
        numberFormat: "Format des nombres", decimalPrecision: "Précision décimale", digits: "chiffres",
        calculator: "Calculatrice", hapticFeedback: "Retour haptique", sound: "Son",
        livePreview: "Aperçu", angleUnits: "Unité d'angle", degrees: "Degrés",
        conversionsSection: "Conversions", defaultCurrency: "Devise par défaut",
        favoriteUnits: "Unités favorites", selected: "sélectionnées", updateRates: "Mettre à jour les taux", daily: "Quotidien",
        about: "À propos", version: "Version", privacy: "Confidentialité", sendFeedback: "Envoyer un commentaire",
        engTime: "Temps", engAcceleration: "Accélération", engDensity: "Densité",
        engPressure: "Pression", engEnergy: "Énergie et travail", engPower: "Puissance",
        engForce: "Force", engAngle: "Angle", engWireGauge: "Section de câble",
        engRotation: "Vitesse de rotation", engTorque: "Couple", engTempDiff: "Écart de temp.",
        engVolumeFlow: "Débit volumique", engMassFlow: "Débit massique", engIlluminance: "Éclairement",
        engRadiation: "Radiation", engRadioactivity: "Radioactivité"
    )
}

// MARK: - Lookup

extension Loc {
    static func forLanguage(_ lang: AppLanguage) -> Loc {
        switch lang {
        case .en: return .en
        case .ru: return .ru
        case .de: return .de
        case .es: return .es
        case .fr: return .fr
        }
    }
}

// MARK: - Environment Key

private struct LocKey: EnvironmentKey {
    static let defaultValue: Loc = .en
}

extension EnvironmentValues {
    var loc: Loc {
        get { self[LocKey.self] }
        set { self[LocKey.self] = newValue }
    }
}
