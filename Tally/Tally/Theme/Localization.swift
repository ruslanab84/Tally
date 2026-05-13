import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case en, ru, de, es, fr, it, pt, tr, zh

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: return "English"
        case .ru: return "Русский"
        case .de: return "Deutsch"
        case .es: return "Español"
        case .fr: return "Français"
        case .it: return "Italiano"
        case .pt: return "Português"
        case .tr: return "Türkçe"
        case .zh: return "中文"
        }
    }

    var flag: String {
        switch self {
        case .en: return "🇺🇸"
        case .ru: return "🇷🇺"
        case .de: return "🇩🇪"
        case .es: return "🇪🇸"
        case .fr: return "🇫🇷"
        case .it: return "🇮🇹"
        case .pt: return "🇧🇷"
        case .tr: return "🇹🇷"
        case .zh: return "🇨🇳"
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
    let mo: String
    let yr: String
    let quarterly: String
    let interestTax: String
    let taxPaid: String
    let afterTaxTotal: String

    // Mortgage
    let mortgage: String
    let propPrice: String
    let downPayment: String
    let paymentType: String
    let annuity: String
    let diffPayment: String
    let propTax: String
    let homeIns: String
    let hoa: String
    let totalMonthly: String
    let pAndI: String
    let pmi: String
    let lastPaymentDate: String
    let extraPaymentLabel: String
    let scenario: String
    let saved: String
    let debtBalance: String

    // Rent vs Buy
    let rentVsBuy: String
    let monthlyRent: String
    let rentIncrease: String
    let homeAppreciation: String
    let yearsCompare: String
    let investReturn: String
    let renting: String
    let buying: String
    let homeEquity: String
    let netPosition: String
    let buyingBetter: String
    let rentingBetter: String
    let invested: String
    let remainingLoan: String

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

    // Crypto
    let tileCrypto: String
    let tileCryptoSub: String
    let navCrypto: String
    let cryptoConverter: String
    let cryptoAmount: String
    let cryptoPrices: String
    let cryptoShowAll: String
    let cryptoShowLess: String
    let cryptoLoading: String
    let cryptoOffline: String
    let cryptoUpdated: String
    let cryptoHigh: String
    let cryptoLow: String
    let cryptoMarketCap: String
    let cryptoVolume: String
    let cryptoMarket: String
    let cryptoPortfolio: String
    let portfolioEmpty: String
    let portfolioAdd: String
    let portfolioAddTitle: String
    let portfolioInvested: String
    let portfolioValue: String
    let portfolioCoin: String
    let portfolioAmount: String
    let portfolioBuyPrice: String
    let portfolioDate: String
    let portfolioCost: String
    let portfolioHoldings: String
    let portfolioSelectCoin: String

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
        mo: "mo", yr: "yr", quarterly: "Quarterly",
        interestTax: "TAX ON INTEREST %", taxPaid: "Tax paid", afterTaxTotal: "After-tax total",
        mortgage: "Mortgage", propPrice: "PROPERTY PRICE", downPayment: "DOWN PAYMENT",
        paymentType: "PAYMENT TYPE", annuity: "Annuity", diffPayment: "Differentiated",
        propTax: "PROPERTY TAX %", homeIns: "HOME INSURANCE $/mo", hoa: "HOA FEES $/mo",
        totalMonthly: "TOTAL MONTHLY", pAndI: "Principal & Interest", pmi: "PMI",
        lastPaymentDate: "Last payment", extraPaymentLabel: "EXTRA MONTHLY",
        scenario: "SCENARIO", saved: "saved", debtBalance: "DEBT BALANCE",
        rentVsBuy: "Rent/Buy", monthlyRent: "MONTHLY RENT", rentIncrease: "RENT INCREASE %/yr",
        homeAppreciation: "HOME APPRECIATION %/yr", yearsCompare: "YEARS TO COMPARE",
        investReturn: "INVEST RETURN %/yr", renting: "RENTING", buying: "BUYING",
        homeEquity: "Home equity", netPosition: "Net position",
        buyingBetter: "Buying is better by", rentingBetter: "Renting is better by",
        invested: "Invested down pmt", remainingLoan: "Remaining loan",
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
        tileCrypto: "Crypto", tileCryptoSub: "Live prices",
        navCrypto: "Crypto", cryptoConverter: "CONVERTER", cryptoAmount: "Amount",
        cryptoPrices: "PRICES", cryptoShowAll: "Show all", cryptoShowLess: "Show less",
        cryptoLoading: "Loading…", cryptoOffline: "Offline", cryptoUpdated: "Updated",
        cryptoHigh: "High", cryptoLow: "Low", cryptoMarketCap: "Market Cap", cryptoVolume: "Volume 24h",
        cryptoMarket: "Market", cryptoPortfolio: "Portfolio",
        portfolioEmpty: "No holdings yet · Tap + to add", portfolioAdd: "Add Holding",
        portfolioAddTitle: "Add Holding", portfolioInvested: "Invested", portfolioValue: "Value",
        portfolioCoin: "Coin", portfolioAmount: "Amount", portfolioBuyPrice: "Buy Price",
        portfolioDate: "Buy Date", portfolioCost: "Cost", portfolioHoldings: "Holdings",
        portfolioSelectCoin: "Select Coin",
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
        mo: "мес", yr: "лет", quarterly: "Квартальная",
        interestTax: "НАЛОГ НА ПРОЦЕНТЫ %", taxPaid: "Уплачено налога", afterTaxTotal: "Итого после налога",
        mortgage: "Ипотека", propPrice: "СТОИМОСТЬ ЖИЛЬЯ", downPayment: "ПЕРВОНАЧАЛЬНЫЙ ВЗНОС",
        paymentType: "ТИП ПЛАТЕЖА", annuity: "Аннуитет", diffPayment: "Дифференц.",
        propTax: "НАЛОГ НА ИМУ-ВО %", homeIns: "СТРАХОВКА $/мес", hoa: "СБОРЫ ТСЖ $/мес",
        totalMonthly: "ИТОГО В МЕСЯЦ", pAndI: "Долг и проценты", pmi: "PMI (страх.)",
        lastPaymentDate: "Последний платёж", extraPaymentLabel: "ДОПЛАТА В МЕС.",
        scenario: "СЦЕНАРИЙ", saved: "экономия", debtBalance: "ОСТАТОК ДОЛГА",
        rentVsBuy: "Аренда/Покупка", monthlyRent: "ЕЖЕМЕС. АРЕНДА", rentIncrease: "РОСТ АРЕНДЫ %/год",
        homeAppreciation: "РОСТ СТОИМОСТИ %/год", yearsCompare: "ЛЕТ ДЛЯ СРАВНЕНИЯ",
        investReturn: "ДОХОДНОСТЬ %/год", renting: "АРЕНДА", buying: "ПОКУПКА",
        homeEquity: "Капитал в жилье", netPosition: "Чистая позиция",
        buyingBetter: "Покупка выгоднее на", rentingBetter: "Аренда выгоднее на",
        invested: "Вложенный взнос", remainingLoan: "Остаток долга",
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
        tileCrypto: "Крипто", tileCryptoSub: "Курсы онлайн",
        navCrypto: "Крипто", cryptoConverter: "КОНВЕРТЕР", cryptoAmount: "Количество",
        cryptoPrices: "ЦЕНЫ", cryptoShowAll: "Показать все", cryptoShowLess: "Свернуть",
        cryptoLoading: "Загрузка…", cryptoOffline: "Офлайн", cryptoUpdated: "Обновлено",
        cryptoHigh: "Макс.", cryptoLow: "Мин.", cryptoMarketCap: "Рын. кап.", cryptoVolume: "Объём 24ч",
        cryptoMarket: "Рынок", cryptoPortfolio: "Портфель",
        portfolioEmpty: "Нет активов · Нажмите + для добавления", portfolioAdd: "Добавить",
        portfolioAddTitle: "Добавить актив", portfolioInvested: "Вложено", portfolioValue: "Стоимость",
        portfolioCoin: "Монета", portfolioAmount: "Количество", portfolioBuyPrice: "Цена покупки",
        portfolioDate: "Дата покупки", portfolioCost: "Затраты", portfolioHoldings: "Активы",
        portfolioSelectCoin: "Выберите монету",
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
        mo: "Mo", yr: "Jr", quarterly: "Vierteljährl.",
        interestTax: "ZINSSTEUER %", taxPaid: "Steuer bezahlt", afterTaxTotal: "Netto nach Steuer",
        mortgage: "Hypothek", propPrice: "IMMOBILIENPREIS", downPayment: "ANZAHLUNG",
        paymentType: "ZAHLUNGSART", annuity: "Annuität", diffPayment: "Differenziert",
        propTax: "GRUNDSTEUER %", homeIns: "VERSICHERUNG $/Mo", hoa: "HOA-GEBÜHR $/Mo",
        totalMonthly: "MONATL. GESAMT", pAndI: "Tilgung & Zinsen", pmi: "PMI",
        lastPaymentDate: "Letzte Zahlung", extraPaymentLabel: "EXTRA MONATL.",
        scenario: "SZENARIO", saved: "gespart", debtBalance: "RESTSCHULD",
        rentVsBuy: "Miete/Kauf", monthlyRent: "MONATL. MIETE", rentIncrease: "MIETERHÖHUNG %/J",
        homeAppreciation: "WERTSTEIGERUNG %/J", yearsCompare: "VERGLEICHSJAHRE",
        investReturn: "ANLAGERENDITE %/J", renting: "MIETEN", buying: "KAUFEN",
        homeEquity: "Eigenkapital", netPosition: "Nettovermögen",
        buyingBetter: "Kaufen ist besser um", rentingBetter: "Mieten ist besser um",
        invested: "Anzahlung investiert", remainingLoan: "Restschuld",
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
        tileCrypto: "Krypto", tileCryptoSub: "Live-Kurse",
        navCrypto: "Krypto", cryptoConverter: "UMRECHNER", cryptoAmount: "Menge",
        cryptoPrices: "PREISE", cryptoShowAll: "Alle anzeigen", cryptoShowLess: "Weniger",
        cryptoLoading: "Laden…", cryptoOffline: "Offline", cryptoUpdated: "Aktualisiert",
        cryptoHigh: "Hoch", cryptoLow: "Tief", cryptoMarketCap: "Marktk.", cryptoVolume: "Volumen 24h",
        cryptoMarket: "Markt", cryptoPortfolio: "Portfolio",
        portfolioEmpty: "Keine Positionen · + drücken", portfolioAdd: "Hinzufügen",
        portfolioAddTitle: "Position hinzufügen", portfolioInvested: "Investiert", portfolioValue: "Wert",
        portfolioCoin: "Münze", portfolioAmount: "Menge", portfolioBuyPrice: "Kaufpreis",
        portfolioDate: "Kaufdatum", portfolioCost: "Kosten", portfolioHoldings: "Positionen",
        portfolioSelectCoin: "Münze wählen",
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
        mo: "mes", yr: "año", quarterly: "Trimestral",
        interestTax: "IMPUESTO INTERÉS %", taxPaid: "Impuesto pagado", afterTaxTotal: "Total neto",
        mortgage: "Hipoteca", propPrice: "PRECIO PROPIEDAD", downPayment: "ENTRADA",
        paymentType: "TIPO DE PAGO", annuity: "Anualidad", diffPayment: "Diferenciado",
        propTax: "IMPUESTO PROP. %", homeIns: "SEGURO $/mes", hoa: "CUOTA HOA $/mes",
        totalMonthly: "TOTAL MENSUAL", pAndI: "Capital e intereses", pmi: "PMI",
        lastPaymentDate: "Último pago", extraPaymentLabel: "PAGO EXTRA",
        scenario: "ESCENARIO", saved: "ahorrado", debtBalance: "DEUDA RESTANTE",
        rentVsBuy: "Alq./Compra", monthlyRent: "RENTA MENSUAL", rentIncrease: "AUMENTO RENTA %/a",
        homeAppreciation: "APRECIACIÓN INMUEBLE %", yearsCompare: "AÑOS A COMPARAR",
        investReturn: "RENTAB. INVERSIÓN %", renting: "ALQUILAR", buying: "COMPRAR",
        homeEquity: "Capital vivienda", netPosition: "Posición neta",
        buyingBetter: "Comprar es mejor por", rentingBetter: "Alquilar es mejor por",
        invested: "Entrada invertida", remainingLoan: "Deuda restante",
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
        tileCrypto: "Cripto", tileCryptoSub: "Precios en vivo",
        navCrypto: "Cripto", cryptoConverter: "CONVERTIDOR", cryptoAmount: "Cantidad",
        cryptoPrices: "PRECIOS", cryptoShowAll: "Mostrar todo", cryptoShowLess: "Mostrar menos",
        cryptoLoading: "Cargando…", cryptoOffline: "Sin conexión", cryptoUpdated: "Actualizado",
        cryptoHigh: "Máx.", cryptoLow: "Mín.", cryptoMarketCap: "Cap. Merc.", cryptoVolume: "Volumen 24h",
        cryptoMarket: "Mercado", cryptoPortfolio: "Cartera",
        portfolioEmpty: "Sin posiciones · Toca + para agregar", portfolioAdd: "Agregar",
        portfolioAddTitle: "Agregar posición", portfolioInvested: "Invertido", portfolioValue: "Valor",
        portfolioCoin: "Moneda", portfolioAmount: "Cantidad", portfolioBuyPrice: "Precio de compra",
        portfolioDate: "Fecha de compra", portfolioCost: "Costo", portfolioHoldings: "Posiciones",
        portfolioSelectCoin: "Seleccionar moneda",
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
        mo: "mois", yr: "ans", quarterly: "Trimestriel",
        interestTax: "IMPÔT INTÉRÊTS %", taxPaid: "Impôt payé", afterTaxTotal: "Total après impôt",
        mortgage: "Hypothèque", propPrice: "PRIX DU BIEN", downPayment: "APPORT INITIAL",
        paymentType: "TYPE PAIEMENT", annuity: "Annuité", diffPayment: "Différencié",
        propTax: "TAXE FONCIÈRE %", homeIns: "ASSURANCE $/mois", hoa: "CHARGES HOA $/mois",
        totalMonthly: "TOTAL MENSUEL", pAndI: "Capital & intérêts", pmi: "PMI",
        lastPaymentDate: "Dernier paiement", extraPaymentLabel: "EXTRA MENSUEL",
        scenario: "SCÉNARIO", saved: "économisé", debtBalance: "SOLDE DETTE",
        rentVsBuy: "Louer/Acheter", monthlyRent: "LOYER MENSUEL", rentIncrease: "HAUSSE LOYER %/an",
        homeAppreciation: "VALORISATION %/an", yearsCompare: "ANNÉES À COMPARER",
        investReturn: "RENDEMENT INV. %/an", renting: "LOUER", buying: "ACHETER",
        homeEquity: "Valeur nette immo", netPosition: "Position nette",
        buyingBetter: "Acheter est mieux de", rentingBetter: "Louer est mieux de",
        invested: "Apport investi", remainingLoan: "Solde restant",
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
        tileCrypto: "Crypto", tileCryptoSub: "Prix en direct",
        navCrypto: "Crypto", cryptoConverter: "CONVERTISSEUR", cryptoAmount: "Montant",
        cryptoPrices: "PRIX", cryptoShowAll: "Tout afficher", cryptoShowLess: "Réduire",
        cryptoLoading: "Chargement…", cryptoOffline: "Hors ligne", cryptoUpdated: "Mis à jour",
        cryptoHigh: "Haut", cryptoLow: "Bas", cryptoMarketCap: "Cap. bours.", cryptoVolume: "Volume 24h",
        cryptoMarket: "Marché", cryptoPortfolio: "Portefeuille",
        portfolioEmpty: "Aucune position · Appuyer sur +", portfolioAdd: "Ajouter",
        portfolioAddTitle: "Ajouter une position", portfolioInvested: "Investi", portfolioValue: "Valeur",
        portfolioCoin: "Monnaie", portfolioAmount: "Quantité", portfolioBuyPrice: "Prix d'achat",
        portfolioDate: "Date d'achat", portfolioCost: "Coût", portfolioHoldings: "Positions",
        portfolioSelectCoin: "Choisir une monnaie",
        engTime: "Temps", engAcceleration: "Accélération", engDensity: "Densité",
        engPressure: "Pression", engEnergy: "Énergie et travail", engPower: "Puissance",
        engForce: "Force", engAngle: "Angle", engWireGauge: "Section de câble",
        engRotation: "Vitesse de rotation", engTorque: "Couple", engTempDiff: "Écart de temp.",
        engVolumeFlow: "Débit volumique", engMassFlow: "Débit massique", engIlluminance: "Éclairement",
        engRadiation: "Radiation", engRadioactivity: "Radioactivité"
    )
}

// MARK: - Italian

extension Loc {
    static let it = Loc(
        tabHome: "Home", tabHistory: "Cronologia", tabSettings: "Impostazioni",
        done: "Fatto", cancel: "Annulla", from: "DA", to: "A",
        hubSubtitle: "Calcolatrice e convertitori", hubRecent: "RECENTI",
        tileSimple: "Semplice", tileSimpleSub: "Calcolatrice",
        tileScientific: "Scientifica", tileScientificSub: "Avanzata",
        tileCurrency: "Valuta", tileCurrencySub: "62 valute",
        tileUnits: "Unità", tileUnitsSub: "Lunghezza, massa…",
        tileTemp: "Temperatura", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "Data e ora", tileDateTimeSub: "Fusi orari",
        tileClothing: "Abbigliamento", tileClothingSub: "EU · US · UK",
        tileTip: "Mancia", tileTipSub: "Dividi il conto",
        tileFinance: "Finanza", tileFinanceSub: "Prestito e deposito",
        tileBMI: "IMC", tileBMISub: "Indice di massa",
        tileEngineering: "Ingegneria", tileEngineeringSub: "17 convertitori",
        navCalculator: "Calcolatrice",
        navScientific: "Scientifica", sciModeSci: "Scientifica", sciModeProg: "Programmatore", sciModeGraph: "Grafico",
        graphRange: "Intervallo", graphStep: "Passo",
        navCurrency: "Valuta", popular: "POPOLARI", allCurrencies: "Tutte le valute",
        selectCurrency: "Scegli valuta", searchCurrencies: "Cerca valute",
        navUnits: "Unità", navEngineering: "Ingegneria", allConversions: "TUTTE LE CONVERSIONI", categories: "CATEGORIE",
        navTemp: "Temperatura", celsius: "Celsius", fahrenheit: "Fahrenheit", kelvin: "Kelvin",
        reference: "Riferimento",
        tempExtremeCold: "Freddo estremo", tempBelowFreezing: "Sotto zero", tempCold: "Freddo", tempCool: "Fresco",
        tempComfortable: "Temperatura confortevole", tempWarm: "Caldo", tempHot: "Molto caldo", tempExtremeHeat: "Calore estremo",
        navDateTime: "Data e ora", difference: "DIFFERENZA", worldClock: "ORA MONDIALE",
        today: "Oggi", tomorrow: "Domani", yesterday: "Ieri",
        days: "giorni", months: "mesi", weeks: "sett.",
        navClothing: "Abbigliamento", shirts: "Camicie", pants: "Pantaloni", shoes: "Scarpe", kids: "Bambini",
        mens: "Uomo", womens: "Donna", selectYourSize: "SCEGLI LA TAGLIA", conversions: "CONVERSIONI",
        navTip: "Mancia", billAmount: "IMPORTO CONTO", tip: "Mancia", total: "Totale",
        splitBetween: "Dividi tra", people: "pers.", eachPays: "Ognuno paga",
        navFinance: "Finanza", loan: "Prestito", deposit: "Deposito",
        loanAmount: "IMPORTO PRESTITO", annualRate: "TASSO ANNUO", term: "DURATA",
        monthlyPayment: "RATA MENSILE", principal: "Capitale", totalInterest: "Interessi totali",
        totalPaid: "Totale pagato", interest: "Interessi", paymentSchedule: "PIANO PAGAMENTI",
        monthly: "Mensile", yearly: "Annuale", year: "Anno", balance: "Saldo",
        initialDeposit: "DEPOSITO INIZIALE", monthlyContribution: "VERSAMENTO MENSILE",
        capitalization: "CAPITALIZZAZIONE", quarter: "Trimest.", semiAnnual: "Semest.", annual: "Annuale",
        finalAmount: "IMPORTO FINALE", totalDeposited: "Totale depositato", interestEarned: "Interessi maturati",
        effectiveRate: "Tasso effettivo", yearlyGrowth: "CRESCITA ANNUALE",
        deposited: "Depositato", added: "Aggiunto", capitaliz: "capitalizzazione",
        mo: "mesi", yr: "anni", quarterly: "Trimestrale",
        interestTax: "TASSA INTERESSI %", taxPaid: "Tasse pagate", afterTaxTotal: "Totale netto",
        mortgage: "Mutuo", propPrice: "PREZZO IMMOBILE", downPayment: "ACCONTO",
        paymentType: "TIPO PAGAMENTO", annuity: "Rata fissa", diffPayment: "Differenziato",
        propTax: "IMPOSTA IMMOB. %", homeIns: "ASSICURAZIONE $/mese", hoa: "SPESE HOA $/mese",
        totalMonthly: "TOTALE MENSILE", pAndI: "Capitale & interessi", pmi: "PMI",
        lastPaymentDate: "Ultimo pagamento", extraPaymentLabel: "EXTRA MENSILE",
        scenario: "SCENARIO", saved: "risparmiato", debtBalance: "DEBITO RESTANTE",
        rentVsBuy: "Affitto/Acquisto", monthlyRent: "AFFITTO MENSILE", rentIncrease: "AUMENTO AFFITTO %",
        homeAppreciation: "RIVALUTAZIONE %/anno", yearsCompare: "ANNI DA CONFRONTARE",
        investReturn: "RENDIMENTO INV. %", renting: "AFFITTARE", buying: "ACQUISTARE",
        homeEquity: "Patrimonio casa", netPosition: "Posizione netta",
        buyingBetter: "Comprare conviene di", rentingBetter: "Affittare conviene di",
        invested: "Acconto investito", remainingLoan: "Debito residuo",
        navBMI: "IMC", metric: "Metrico", imperial: "Imperiale", man: "Uomo", woman: "Donna",
        age: "ETÀ", weight: "PESO", height: "ALTEZZA", yourBMI: "IL TUO IMC",
        estBodyFat: "Grasso stim.", healthyRange: "Range sano",
        underweight: "Sottopeso", normal: "Normopeso", overweight: "Sovrappeso", obese: "Obesità",
        underweightDesc: "Sotto il range sano", normalDesc: "Nel range sano",
        overweightDesc: "Sopra il range sano", obeseDesc: "Molto sopra il range sano",
        essentialFat: "Grasso essenziale", athletes: "Atleti", fitness: "Fitness", average: "Media", aboveAverage: "Sopra la media",
        bmiChildNote: "Per bambini e adolescenti, l'IMC viene interpretato con tabelle percentili per età. Consultare un pediatra.",
        bmiElderlyNote: "Per adulti 65+, un IMC leggermente più alto (23–30) può essere protettivo. Consultare il medico.",
        navHistory: "Cronologia", searchHistory: "Cerca nella cronologia",
        navSettings: "Impostazioni", appearance: "Aspetto", theme: "Tema",
        light: "Chiaro", dark: "Scuro", system: "Sistema",
        accent: "Accento", appIcon: "Icona app", defaultVal: "Predefinito",
        language: "Lingua", appLanguage: "Lingua dell'app",
        numberFormat: "Formato numeri", decimalPrecision: "Precisione decimale", digits: "cifre",
        calculator: "Calcolatrice", hapticFeedback: "Feedback aptico", sound: "Suono",
        livePreview: "Anteprima", angleUnits: "Unità angolo", degrees: "Gradi",
        conversionsSection: "Conversioni", defaultCurrency: "Valuta predefinita",
        favoriteUnits: "Unità preferite", selected: "selezionate", updateRates: "Aggiorna tassi", daily: "Giornaliero",
        about: "Informazioni", version: "Versione", privacy: "Privacy", sendFeedback: "Invia feedback",
        tileCrypto: "Crypto", tileCryptoSub: "Prezzi live",
        navCrypto: "Crypto", cryptoConverter: "CONVERTITORE", cryptoAmount: "Quantità",
        cryptoPrices: "PREZZI", cryptoShowAll: "Mostra tutto", cryptoShowLess: "Mostra meno",
        cryptoLoading: "Caricamento…", cryptoOffline: "Offline", cryptoUpdated: "Aggiornato",
        cryptoHigh: "Max.", cryptoLow: "Min.", cryptoMarketCap: "Cap. Merc.", cryptoVolume: "Volume 24h",
        cryptoMarket: "Mercato", cryptoPortfolio: "Portafoglio",
        portfolioEmpty: "Nessuna posizione · Tocca +", portfolioAdd: "Aggiungi",
        portfolioAddTitle: "Aggiungi posizione", portfolioInvested: "Investito", portfolioValue: "Valore",
        portfolioCoin: "Moneta", portfolioAmount: "Quantità", portfolioBuyPrice: "Prezzo d'acquisto",
        portfolioDate: "Data d'acquisto", portfolioCost: "Costo", portfolioHoldings: "Posizioni",
        portfolioSelectCoin: "Seleziona moneta",
        engTime: "Tempo", engAcceleration: "Accelerazione", engDensity: "Densità",
        engPressure: "Pressione", engEnergy: "Energia e lavoro", engPower: "Potenza",
        engForce: "Forza", engAngle: "Angolo", engWireGauge: "Sezione cavo",
        engRotation: "Velocità rotazione", engTorque: "Coppia", engTempDiff: "Diff. temperatura",
        engVolumeFlow: "Portata volumetrica", engMassFlow: "Portata massica", engIlluminance: "Illuminamento",
        engRadiation: "Radiazione", engRadioactivity: "Radioattività"
    )
}

// MARK: - Portuguese

extension Loc {
    static let pt = Loc(
        tabHome: "Início", tabHistory: "Histórico", tabSettings: "Configurações",
        done: "Pronto", cancel: "Cancelar", from: "DE", to: "PARA",
        hubSubtitle: "Calculadora e conversores", hubRecent: "RECENTE",
        tileSimple: "Simples", tileSimpleSub: "Calculadora",
        tileScientific: "Científica", tileScientificSub: "Avançada",
        tileCurrency: "Moeda", tileCurrencySub: "62 moedas",
        tileUnits: "Unidades", tileUnitsSub: "Comprimento, massa…",
        tileTemp: "Temperatura", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "Data e hora", tileDateTimeSub: "Fusos horários",
        tileClothing: "Roupas", tileClothingSub: "EU · US · UK",
        tileTip: "Gorjeta", tileTipSub: "Dividir conta",
        tileFinance: "Finanças", tileFinanceSub: "Empréstimo e depósito",
        tileBMI: "IMC", tileBMISub: "Índice de massa",
        tileEngineering: "Engenharia", tileEngineeringSub: "17 conversores",
        navCalculator: "Calculadora",
        navScientific: "Científica", sciModeSci: "Científica", sciModeProg: "Programador", sciModeGraph: "Gráfico",
        graphRange: "Intervalo", graphStep: "Passo",
        navCurrency: "Moeda", popular: "POPULARES", allCurrencies: "Todas as moedas",
        selectCurrency: "Escolher moeda", searchCurrencies: "Buscar moedas",
        navUnits: "Unidades", navEngineering: "Engenharia", allConversions: "TODAS AS CONVERSÕES", categories: "CATEGORIAS",
        navTemp: "Temperatura", celsius: "Celsius", fahrenheit: "Fahrenheit", kelvin: "Kelvin",
        reference: "Referência",
        tempExtremeCold: "Frio extremo", tempBelowFreezing: "Abaixo de zero", tempCold: "Frio", tempCool: "Fresco",
        tempComfortable: "Temperatura agradável", tempWarm: "Quente", tempHot: "Muito quente", tempExtremeHeat: "Calor extremo",
        navDateTime: "Data e hora", difference: "DIFERENÇA", worldClock: "HORA MUNDIAL",
        today: "Hoje", tomorrow: "Amanhã", yesterday: "Ontem",
        days: "dias", months: "meses", weeks: "sem.",
        navClothing: "Roupas", shirts: "Camisas", pants: "Calças", shoes: "Sapatos", kids: "Infantil",
        mens: "Masculino", womens: "Feminino", selectYourSize: "ESCOLHA SEU TAMANHO", conversions: "CONVERSÕES",
        navTip: "Gorjeta", billAmount: "VALOR DA CONTA", tip: "Gorjeta", total: "Total",
        splitBetween: "Dividir entre", people: "pes.", eachPays: "Cada um paga",
        navFinance: "Finanças", loan: "Empréstimo", deposit: "Depósito",
        loanAmount: "VALOR DO EMPRÉSTIMO", annualRate: "TAXA ANUAL", term: "PRAZO",
        monthlyPayment: "PARCELA MENSAL", principal: "Capital", totalInterest: "Juros totais",
        totalPaid: "Total pago", interest: "Juros", paymentSchedule: "CRONOGRAMA",
        monthly: "Mensal", yearly: "Anual", year: "Ano", balance: "Saldo",
        initialDeposit: "DEPÓSITO INICIAL", monthlyContribution: "APORTE MENSAL",
        capitalization: "CAPITALIZAÇÃO", quarter: "Trimest.", semiAnnual: "Semest.", annual: "Anual",
        finalAmount: "VALOR FINAL", totalDeposited: "Total depositado", interestEarned: "Juros ganhos",
        effectiveRate: "Taxa efetiva", yearlyGrowth: "CRESCIMENTO ANUAL",
        deposited: "Depositado", added: "Adicionado", capitaliz: "capitalização",
        mo: "mês", yr: "ano", quarterly: "Trimestral",
        interestTax: "IMPOSTO JUROS %", taxPaid: "Imposto pago", afterTaxTotal: "Total líquido",
        mortgage: "Hipoteca", propPrice: "PREÇO DO IMÓVEL", downPayment: "ENTRADA",
        paymentType: "TIPO PAGAMENTO", annuity: "Anuidade", diffPayment: "Diferenciado",
        propTax: "IMPOSTO IMÓVEL %", homeIns: "SEGURO $/mês", hoa: "TAXA HOA $/mês",
        totalMonthly: "TOTAL MENSAL", pAndI: "Capital & juros", pmi: "PMI",
        lastPaymentDate: "Último pagamento", extraPaymentLabel: "EXTRA MENSAL",
        scenario: "CENÁRIO", saved: "poupado", debtBalance: "SALDO DEVEDOR",
        rentVsBuy: "Alug./Compra", monthlyRent: "ALUGUEL MENSAL", rentIncrease: "AUMENTO ALUGUEL %",
        homeAppreciation: "VALORIZAÇÃO %/ano", yearsCompare: "ANOS A COMPARAR",
        investReturn: "RETORNO INV. %/ano", renting: "ALUGAR", buying: "COMPRAR",
        homeEquity: "Valor líquido imóvel", netPosition: "Posição líquida",
        buyingBetter: "Comprar é melhor em", rentingBetter: "Alugar é melhor em",
        invested: "Entrada investida", remainingLoan: "Saldo devedor",
        navBMI: "IMC", metric: "Métrico", imperial: "Imperial", man: "Homem", woman: "Mulher",
        age: "IDADE", weight: "PESO", height: "ALTURA", yourBMI: "SEU IMC",
        estBodyFat: "Gordura est.", healthyRange: "Faixa saudável",
        underweight: "Abaixo do peso", normal: "Normal", overweight: "Sobrepeso", obese: "Obesidade",
        underweightDesc: "Abaixo da faixa saudável", normalDesc: "Dentro da faixa saudável",
        overweightDesc: "Acima da faixa saudável", obeseDesc: "Muito acima da faixa saudável",
        essentialFat: "Gordura essencial", athletes: "Atletas", fitness: "Fitness", average: "Médio", aboveAverage: "Acima da média",
        bmiChildNote: "Para crianças e adolescentes, o IMC é interpretado usando tabelas de percentis por idade. Consulte um pediatra.",
        bmiElderlyNote: "Para adultos 65+, um IMC ligeiramente mais alto (23–30) pode ser protetor. Consulte seu médico.",
        navHistory: "Histórico", searchHistory: "Buscar no histórico",
        navSettings: "Configurações", appearance: "Aparência", theme: "Tema",
        light: "Claro", dark: "Escuro", system: "Sistema",
        accent: "Destaque", appIcon: "Ícone do app", defaultVal: "Padrão",
        language: "Idioma", appLanguage: "Idioma do app",
        numberFormat: "Formato numérico", decimalPrecision: "Precisão decimal", digits: "dígitos",
        calculator: "Calculadora", hapticFeedback: "Vibração", sound: "Som",
        livePreview: "Visualização", angleUnits: "Unidade de ângulo", degrees: "Graus",
        conversionsSection: "Conversões", defaultCurrency: "Moeda padrão",
        favoriteUnits: "Unidades favoritas", selected: "selecionadas", updateRates: "Atualizar taxas", daily: "Diário",
        about: "Sobre", version: "Versão", privacy: "Privacidade", sendFeedback: "Enviar feedback",
        tileCrypto: "Cripto", tileCryptoSub: "Preços ao vivo",
        navCrypto: "Cripto", cryptoConverter: "CONVERSOR", cryptoAmount: "Quantidade",
        cryptoPrices: "PREÇOS", cryptoShowAll: "Mostrar tudo", cryptoShowLess: "Mostrar menos",
        cryptoLoading: "Carregando…", cryptoOffline: "Offline", cryptoUpdated: "Atualizado",
        cryptoHigh: "Máx.", cryptoLow: "Mín.", cryptoMarketCap: "Cap. Merc.", cryptoVolume: "Volume 24h",
        cryptoMarket: "Mercado", cryptoPortfolio: "Carteira",
        portfolioEmpty: "Sem posições · Toque em +", portfolioAdd: "Adicionar",
        portfolioAddTitle: "Adicionar posição", portfolioInvested: "Investido", portfolioValue: "Valor",
        portfolioCoin: "Moeda", portfolioAmount: "Quantidade", portfolioBuyPrice: "Preço de compra",
        portfolioDate: "Data de compra", portfolioCost: "Custo", portfolioHoldings: "Posições",
        portfolioSelectCoin: "Selecionar moeda",
        engTime: "Tempo", engAcceleration: "Aceleração", engDensity: "Densidade",
        engPressure: "Pressão", engEnergy: "Energia e trabalho", engPower: "Potência",
        engForce: "Força", engAngle: "Ângulo", engWireGauge: "Bitola de fio",
        engRotation: "Vel. rotação", engTorque: "Torque", engTempDiff: "Dif. temperatura",
        engVolumeFlow: "Vazão volumétrica", engMassFlow: "Vazão mássica", engIlluminance: "Iluminância",
        engRadiation: "Radiação", engRadioactivity: "Radioatividade"
    )
}

// MARK: - Turkish

extension Loc {
    static let tr = Loc(
        tabHome: "Ana Sayfa", tabHistory: "Geçmiş", tabSettings: "Ayarlar",
        done: "Tamam", cancel: "İptal", from: "KİMDEN", to: "KİME",
        hubSubtitle: "Hesap makinesi ve dönüştürücüler", hubRecent: "SON",
        tileSimple: "Basit", tileSimpleSub: "Hesap makinesi",
        tileScientific: "Bilimsel", tileScientificSub: "Gelişmiş",
        tileCurrency: "Döviz", tileCurrencySub: "62 para birimi",
        tileUnits: "Birimler", tileUnitsSub: "Uzunluk, kütle…",
        tileTemp: "Sıcaklık", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "Tarih ve Saat", tileDateTimeSub: "Saat dilimleri",
        tileClothing: "Giyim", tileClothingSub: "EU · US · UK",
        tileTip: "Bahşiş", tileTipSub: "Hesap bölme",
        tileFinance: "Finans", tileFinanceSub: "Kredi ve mevduat",
        tileBMI: "VKİ", tileBMISub: "Vücut kitle indeksi",
        tileEngineering: "Mühendislik", tileEngineeringSub: "17 dönüştürücü",
        navCalculator: "Hesap Makinesi",
        navScientific: "Bilimsel", sciModeSci: "Bilimsel", sciModeProg: "Programcı", sciModeGraph: "Grafik",
        graphRange: "Aralık", graphStep: "Adım",
        navCurrency: "Döviz", popular: "POPÜLER", allCurrencies: "Tüm para birimleri",
        selectCurrency: "Para birimi seç", searchCurrencies: "Para birimi ara",
        navUnits: "Birimler", navEngineering: "Mühendislik", allConversions: "TÜM DÖNÜŞÜMLER", categories: "KATEGORİLER",
        navTemp: "Sıcaklık", celsius: "Celsius", fahrenheit: "Fahrenheit", kelvin: "Kelvin",
        reference: "Referans",
        tempExtremeCold: "Aşırı soğuk", tempBelowFreezing: "Sıfırın altında", tempCold: "Soğuk", tempCool: "Serin",
        tempComfortable: "Konforlu oda sıcaklığı", tempWarm: "Ilık", tempHot: "Sıcak", tempExtremeHeat: "Aşırı sıcak",
        navDateTime: "Tarih ve Saat", difference: "FARK", worldClock: "DÜNYA SAATİ",
        today: "Bugün", tomorrow: "Yarın", yesterday: "Dün",
        days: "gün", months: "ay", weeks: "hft.",
        navClothing: "Giyim", shirts: "Gömlekler", pants: "Pantolonlar", shoes: "Ayakkabılar", kids: "Çocuk",
        mens: "Erkek", womens: "Kadın", selectYourSize: "BEDENİNİZİ SEÇİN", conversions: "DÖNÜŞÜMLER",
        navTip: "Bahşiş", billAmount: "HESAP TUTARI", tip: "Bahşiş", total: "Toplam",
        splitBetween: "Bölüştür", people: "kişi", eachPays: "Kişi başı",
        navFinance: "Finans", loan: "Kredi", deposit: "Mevduat",
        loanAmount: "KREDİ TUTARI", annualRate: "YILLIK FAİZ", term: "VADE",
        monthlyPayment: "AYLIK TAKSİT", principal: "Anapara", totalInterest: "Toplam faiz",
        totalPaid: "Toplam ödenen", interest: "Faiz", paymentSchedule: "ÖDEME PLANI",
        monthly: "Aylık", yearly: "Yıllık", year: "Yıl", balance: "Bakiye",
        initialDeposit: "İLK YATIRMA", monthlyContribution: "AYLIK KATKI",
        capitalization: "KAPİTALİZASYON", quarter: "Çeyrek", semiAnnual: "Yarıyıl", annual: "Yıllık",
        finalAmount: "SON TUTAR", totalDeposited: "Toplam yatırılan", interestEarned: "Kazanılan faiz",
        effectiveRate: "Efektif oran", yearlyGrowth: "YILLIK BÜYÜME",
        deposited: "Yatırılan", added: "Eklenen", capitaliz: "kapitalizasyon",
        mo: "ay", yr: "yıl", quarterly: "Üç aylık",
        interestTax: "FAİZ VERGİSİ %", taxPaid: "Ödenen vergi", afterTaxTotal: "Vergi sonrası toplam",
        mortgage: "Mortgage", propPrice: "EMLAK FİYATI", downPayment: "PEŞİNAT",
        paymentType: "ÖDEME TÜRÜ", annuity: "Eşit taksit", diffPayment: "Azalan taksit",
        propTax: "EMLAK VERGİSİ %", homeIns: "SİGORTA $/ay", hoa: "HOA ÜCRETİ $/ay",
        totalMonthly: "TOPLAM AYLIK", pAndI: "Anapara & faiz", pmi: "PMI",
        lastPaymentDate: "Son ödeme", extraPaymentLabel: "EK ÖDEME",
        scenario: "SENARYO", saved: "tasarruf", debtBalance: "BORÇ BAKİYESİ",
        rentVsBuy: "Kira/Satın Al", monthlyRent: "AYLIK KİRA", rentIncrease: "KİRA ARTIŞI %/yıl",
        homeAppreciation: "DEĞER ARTIŞI %/yıl", yearsCompare: "KARŞILAŞT. YILLAR",
        investReturn: "YATIRIM GETİRİSİ %", renting: "KİRALAMA", buying: "SATIN ALMA",
        homeEquity: "Ev öz sermayesi", netPosition: "Net pozisyon",
        buyingBetter: "Satın almak daha iyi", rentingBetter: "Kiralamak daha iyi",
        invested: "Peşinat yatırımı", remainingLoan: "Kalan borç",
        navBMI: "VKİ", metric: "Metrik", imperial: "İmparatorluk", man: "Erkek", woman: "Kadın",
        age: "YAŞ", weight: "KİLO", height: "BOY", yourBMI: "VKİ'NİZ",
        estBodyFat: "Tah. yağ oranı", healthyRange: "Sağlıklı aralık",
        underweight: "Zayıf", normal: "Normal", overweight: "Fazla kilolu", obese: "Obez",
        underweightDesc: "Sağlıklı aralığın altında", normalDesc: "Sağlıklı aralıkta",
        overweightDesc: "Sağlıklı aralığın üstünde", obeseDesc: "Sağlıklı aralığın çok üstünde",
        essentialFat: "Temel yağ", athletes: "Sporcular", fitness: "Fitness", average: "Ortalama", aboveAverage: "Ortalamanın üstü",
        bmiChildNote: "Çocuklar ve gençler için VKİ, yaşa özel persentil tabloları ile yorumlanır. Bir pediatriste danışın.",
        bmiElderlyNote: "65+ yetişkinler için biraz yüksek VKİ (23–30) koruyucu olabilir. Doktorunuza danışın.",
        navHistory: "Geçmiş", searchHistory: "Geçmişte ara",
        navSettings: "Ayarlar", appearance: "Görünüm", theme: "Tema",
        light: "Açık", dark: "Koyu", system: "Sistem",
        accent: "Vurgu", appIcon: "Uygulama simgesi", defaultVal: "Varsayılan",
        language: "Dil", appLanguage: "Uygulama dili",
        numberFormat: "Sayı biçimi", decimalPrecision: "Ondalık hassasiyet", digits: "basamak",
        calculator: "Hesap Makinesi", hapticFeedback: "Dokunsal geri bildirim", sound: "Ses",
        livePreview: "Ön izleme", angleUnits: "Açı birimi", degrees: "Derece",
        conversionsSection: "Dönüşümler", defaultCurrency: "Varsayılan para birimi",
        favoriteUnits: "Favori birimler", selected: "seçili", updateRates: "Kurları güncelle", daily: "Günlük",
        about: "Hakkında", version: "Sürüm", privacy: "Gizlilik", sendFeedback: "Geri bildirim gönder",
        tileCrypto: "Kripto", tileCryptoSub: "Canlı fiyatlar",
        navCrypto: "Kripto", cryptoConverter: "DÖNÜŞTÜRÜCÜ", cryptoAmount: "Miktar",
        cryptoPrices: "FİYATLAR", cryptoShowAll: "Tümünü göster", cryptoShowLess: "Daha az",
        cryptoLoading: "Yükleniyor…", cryptoOffline: "Çevrimdışı", cryptoUpdated: "Güncellendi",
        cryptoHigh: "En Yük.", cryptoLow: "En Düş.", cryptoMarketCap: "Piy. Değ.", cryptoVolume: "Hacim 24s",
        cryptoMarket: "Piyasa", cryptoPortfolio: "Portföy",
        portfolioEmpty: "Pozisyon yok · + ile ekleyin", portfolioAdd: "Ekle",
        portfolioAddTitle: "Pozisyon ekle", portfolioInvested: "Yatırılan", portfolioValue: "Değer",
        portfolioCoin: "Coin", portfolioAmount: "Miktar", portfolioBuyPrice: "Alım fiyatı",
        portfolioDate: "Alım tarihi", portfolioCost: "Maliyet", portfolioHoldings: "Pozisyonlar",
        portfolioSelectCoin: "Coin seç",
        engTime: "Zaman", engAcceleration: "İvme", engDensity: "Yoğunluk",
        engPressure: "Basınç", engEnergy: "Enerji ve iş", engPower: "Güç",
        engForce: "Kuvvet", engAngle: "Açı", engWireGauge: "Tel kalınlığı",
        engRotation: "Dönüş hızı", engTorque: "Tork", engTempDiff: "Sıcaklık farkı",
        engVolumeFlow: "Hacimsel debi", engMassFlow: "Kütlesel debi", engIlluminance: "Aydınlık",
        engRadiation: "Radyasyon", engRadioactivity: "Radyoaktivite"
    )
}

// MARK: - Chinese

extension Loc {
    static let zh = Loc(
        tabHome: "首页", tabHistory: "历史", tabSettings: "设置",
        done: "完成", cancel: "取消", from: "从", to: "到",
        hubSubtitle: "计算器和转换器", hubRecent: "最近",
        tileSimple: "简易", tileSimpleSub: "基础计算器",
        tileScientific: "科学", tileScientificSub: "高级功能",
        tileCurrency: "货币", tileCurrencySub: "62种货币",
        tileUnits: "单位", tileUnitsSub: "长度、质量…",
        tileTemp: "温度", tileTempSub: "°C ↔ °F ↔ K",
        tileDateTime: "日期时间", tileDateTimeSub: "世界时区",
        tileClothing: "服装", tileClothingSub: "EU · US · UK",
        tileTip: "小费", tileTipSub: "分摊账单",
        tileFinance: "金融", tileFinanceSub: "贷款和存款",
        tileBMI: "BMI", tileBMISub: "体质指数",
        tileEngineering: "工程", tileEngineeringSub: "17种转换器",
        navCalculator: "计算器",
        navScientific: "科学计算", sciModeSci: "科学", sciModeProg: "程序员", sciModeGraph: "图表",
        graphRange: "范围", graphStep: "步长",
        navCurrency: "货币", popular: "热门", allCurrencies: "所有货币",
        selectCurrency: "选择货币", searchCurrencies: "搜索货币",
        navUnits: "单位", navEngineering: "工程", allConversions: "所有转换", categories: "分类",
        navTemp: "温度", celsius: "摄氏度", fahrenheit: "华氏度", kelvin: "开尔文",
        reference: "参考",
        tempExtremeCold: "极度寒冷", tempBelowFreezing: "零度以下", tempCold: "寒冷", tempCool: "凉爽",
        tempComfortable: "舒适室温", tempWarm: "温暖", tempHot: "炎热", tempExtremeHeat: "极端高温",
        navDateTime: "日期时间", difference: "日期差", worldClock: "世界时钟",
        today: "今天", tomorrow: "明天", yesterday: "昨天",
        days: "天", months: "月", weeks: "周",
        navClothing: "服装", shirts: "上衣", pants: "裤子", shoes: "鞋子", kids: "童装",
        mens: "男装", womens: "女装", selectYourSize: "选择尺码", conversions: "转换",
        navTip: "小费计算", billAmount: "账单金额", tip: "小费", total: "合计",
        splitBetween: "分摊人数", people: "人", eachPays: "每人支付",
        navFinance: "金融", loan: "贷款", deposit: "存款",
        loanAmount: "贷款金额", annualRate: "年利率", term: "期限",
        monthlyPayment: "月供", principal: "本金", totalInterest: "总利息",
        totalPaid: "总支付", interest: "利息", paymentSchedule: "还款计划",
        monthly: "月度", yearly: "年度", year: "年", balance: "余额",
        initialDeposit: "初始存款", monthlyContribution: "每月追加",
        capitalization: "复利方式", quarter: "季度", semiAnnual: "半年", annual: "年度",
        finalAmount: "最终金额", totalDeposited: "总存入", interestEarned: "利息收益",
        effectiveRate: "有效利率", yearlyGrowth: "年度增长",
        deposited: "已存入", added: "已追加", capitaliz: "复利",
        mo: "月", yr: "年", quarterly: "季度",
        interestTax: "利息税 %", taxPaid: "已缴税款", afterTaxTotal: "税后总额",
        mortgage: "房贷", propPrice: "房产价格", downPayment: "首付款",
        paymentType: "还款方式", annuity: "等额还款", diffPayment: "等额本金",
        propTax: "房产税 %", homeIns: "房屋险 $/月", hoa: "物业费 $/月",
        totalMonthly: "月供合计", pAndI: "本金和利息", pmi: "按揭保险",
        lastPaymentDate: "最后还款", extraPaymentLabel: "额外月供",
        scenario: "方案对比", saved: "节省", debtBalance: "剩余债务",
        rentVsBuy: "租/买", monthlyRent: "月租金", rentIncrease: "租金涨幅 %/年",
        homeAppreciation: "房产增值 %/年", yearsCompare: "比较年限",
        investReturn: "投资回报 %/年", renting: "租房", buying: "购房",
        homeEquity: "房产净值", netPosition: "净资产",
        buyingBetter: "购房更合算，节省", rentingBetter: "租房更合算，节省",
        invested: "首付投资增值", remainingLoan: "剩余贷款",
        navBMI: "BMI", metric: "公制", imperial: "英制", man: "男", woman: "女",
        age: "年龄", weight: "体重", height: "身高", yourBMI: "你的BMI",
        estBodyFat: "估计体脂", healthyRange: "健康范围",
        underweight: "偏瘦", normal: "正常", overweight: "超重", obese: "肥胖",
        underweightDesc: "低于健康范围", normalDesc: "在健康范围内",
        overweightDesc: "高于健康范围", obeseDesc: "远高于健康范围",
        essentialFat: "必需脂肪", athletes: "运动员", fitness: "健身", average: "平均", aboveAverage: "高于平均",
        bmiChildNote: "儿童和青少年的BMI需使用年龄百分位图表解读。请咨询儿科医生。",
        bmiElderlyNote: "65岁以上成人，稍高的BMI（23-30）可能具有保护作用。请咨询医生。",
        navHistory: "历史", searchHistory: "搜索历史",
        navSettings: "设置", appearance: "外观", theme: "主题",
        light: "浅色", dark: "深色", system: "系统",
        accent: "强调色", appIcon: "应用图标", defaultVal: "默认",
        language: "语言", appLanguage: "应用语言",
        numberFormat: "数字格式", decimalPrecision: "小数精度", digits: "位",
        calculator: "计算器", hapticFeedback: "触感反馈", sound: "声音",
        livePreview: "实时预览", angleUnits: "角度单位", degrees: "度",
        conversionsSection: "转换", defaultCurrency: "默认货币",
        favoriteUnits: "常用单位", selected: "已选", updateRates: "更新汇率", daily: "每日",
        about: "关于", version: "版本", privacy: "隐私", sendFeedback: "发送反馈",
        tileCrypto: "加密货币", tileCryptoSub: "实时价格",
        navCrypto: "加密货币", cryptoConverter: "转换器", cryptoAmount: "数量",
        cryptoPrices: "价格", cryptoShowAll: "显示全部", cryptoShowLess: "收起",
        cryptoLoading: "加载中…", cryptoOffline: "离线", cryptoUpdated: "已更新",
        cryptoHigh: "最高", cryptoLow: "最低", cryptoMarketCap: "市值", cryptoVolume: "24h量",
        cryptoMarket: "市场", cryptoPortfolio: "投资组合",
        portfolioEmpty: "暂无持仓 · 点击+添加", portfolioAdd: "添加",
        portfolioAddTitle: "添加持仓", portfolioInvested: "已投入", portfolioValue: "市值",
        portfolioCoin: "币种", portfolioAmount: "数量", portfolioBuyPrice: "买入价格",
        portfolioDate: "买入日期", portfolioCost: "成本", portfolioHoldings: "持仓",
        portfolioSelectCoin: "选择币种",
        engTime: "时间", engAcceleration: "加速度", engDensity: "密度",
        engPressure: "压力", engEnergy: "能量和功", engPower: "功率",
        engForce: "力", engAngle: "角度", engWireGauge: "线径",
        engRotation: "转速", engTorque: "扭矩", engTempDiff: "温差",
        engVolumeFlow: "体积流量", engMassFlow: "质量流量", engIlluminance: "照度",
        engRadiation: "辐射", engRadioactivity: "放射性"
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
        case .it: return .it
        case .pt: return .pt
        case .tr: return .tr
        case .zh: return .zh
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
