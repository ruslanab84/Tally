import Foundation

struct Currency: Identifiable, Hashable {
    let id: String
    let code: String
    let name: String
    let flag: String
    let rate: Double // relative to USD

    init(code: String, name: String, flag: String, rate: Double) {
        self.id = code
        self.code = code
        self.name = name
        self.flag = flag
        self.rate = rate
    }

    static let all: [Currency] = [
        Currency(code: "USD", name: "US Dollar", flag: "🇺🇸", rate: 1.0),
        Currency(code: "EUR", name: "Euro", flag: "🇪🇺", rate: 0.92),
        Currency(code: "GBP", name: "British Pound", flag: "🇬🇧", rate: 0.79),
        Currency(code: "JPY", name: "Japanese Yen", flag: "🇯🇵", rate: 154.2),
        Currency(code: "CNY", name: "Chinese Yuan", flag: "🇨🇳", rate: 7.24),
        Currency(code: "RUB", name: "Russian Ruble", flag: "🇷🇺", rate: 91.5),
        Currency(code: "CHF", name: "Swiss Franc", flag: "🇨🇭", rate: 0.88),
        Currency(code: "CAD", name: "Canadian Dollar", flag: "🇨🇦", rate: 1.36),
        Currency(code: "AUD", name: "Australian Dollar", flag: "🇦🇺", rate: 1.52),
        Currency(code: "NZD", name: "New Zealand Dollar", flag: "🇳🇿", rate: 1.65),
        Currency(code: "SEK", name: "Swedish Krona", flag: "🇸🇪", rate: 10.6),
        Currency(code: "NOK", name: "Norwegian Krone", flag: "🇳🇴", rate: 10.8),
        Currency(code: "DKK", name: "Danish Krone", flag: "🇩🇰", rate: 6.86),
        Currency(code: "PLN", name: "Polish Złoty", flag: "🇵🇱", rate: 4.0),
        Currency(code: "CZK", name: "Czech Koruna", flag: "🇨🇿", rate: 23.1),
        Currency(code: "HUF", name: "Hungarian Forint", flag: "🇭🇺", rate: 358),
        Currency(code: "TRY", name: "Turkish Lira", flag: "🇹🇷", rate: 32.1),
        Currency(code: "INR", name: "Indian Rupee", flag: "🇮🇳", rate: 83.4),
        Currency(code: "KRW", name: "South Korean Won", flag: "🇰🇷", rate: 1370),
        Currency(code: "SGD", name: "Singapore Dollar", flag: "🇸🇬", rate: 1.34),
        Currency(code: "HKD", name: "Hong Kong Dollar", flag: "🇭🇰", rate: 7.81),
        Currency(code: "TWD", name: "Taiwan Dollar", flag: "🇹🇼", rate: 32.4),
        Currency(code: "THB", name: "Thai Baht", flag: "🇹🇭", rate: 36.2),
        Currency(code: "MXN", name: "Mexican Peso", flag: "🇲🇽", rate: 17.0),
        Currency(code: "BRL", name: "Brazilian Real", flag: "🇧🇷", rate: 5.08),
        Currency(code: "ARS", name: "Argentine Peso", flag: "🇦🇷", rate: 880),
        Currency(code: "ZAR", name: "South African Rand", flag: "🇿🇦", rate: 18.7),
        Currency(code: "AED", name: "UAE Dirham", flag: "🇦🇪", rate: 3.67),
        Currency(code: "SAR", name: "Saudi Riyal", flag: "🇸🇦", rate: 3.75),
        Currency(code: "ILS", name: "Israeli Shekel", flag: "🇮🇱", rate: 3.71),
        Currency(code: "UAH", name: "Ukrainian Hryvnia", flag: "🇺🇦", rate: 39.5),
        Currency(code: "KZT", name: "Kazakhstani Tenge", flag: "🇰🇿", rate: 445),
        Currency(code: "GEL", name: "Georgian Lari", flag: "🇬🇪", rate: 2.72),
        Currency(code: "AMD", name: "Armenian Dram", flag: "🇦🇲", rate: 388),
        Currency(code: "AZN", name: "Azerbaijani Manat", flag: "🇦🇿", rate: 1.70),
        Currency(code: "UZS", name: "Uzbekistani Som", flag: "🇺🇿", rate: 12700),
        Currency(code: "BYN", name: "Belarusian Ruble", flag: "🇧🇾", rate: 3.27),
        Currency(code: "MDL", name: "Moldovan Leu", flag: "🇲🇩", rate: 17.8),
        Currency(code: "RON", name: "Romanian Leu", flag: "🇷🇴", rate: 4.58),
        Currency(code: "BGN", name: "Bulgarian Lev", flag: "🇧🇬", rate: 1.80),
        Currency(code: "HRK", name: "Croatian Kuna", flag: "🇭🇷", rate: 6.93),
        Currency(code: "RSD", name: "Serbian Dinar", flag: "🇷🇸", rate: 108),
        Currency(code: "ISK", name: "Icelandic Króna", flag: "🇮🇸", rate: 138),
        Currency(code: "PHP", name: "Philippine Peso", flag: "🇵🇭", rate: 56.2),
        Currency(code: "MYR", name: "Malaysian Ringgit", flag: "🇲🇾", rate: 4.47),
        Currency(code: "IDR", name: "Indonesian Rupiah", flag: "🇮🇩", rate: 15800),
        Currency(code: "VND", name: "Vietnamese Dong", flag: "🇻🇳", rate: 25400),
        Currency(code: "BDT", name: "Bangladeshi Taka", flag: "🇧🇩", rate: 110),
        Currency(code: "PKR", name: "Pakistani Rupee", flag: "🇵🇰", rate: 278),
        Currency(code: "LKR", name: "Sri Lankan Rupee", flag: "🇱🇰", rate: 298),
        Currency(code: "EGP", name: "Egyptian Pound", flag: "🇪🇬", rate: 49.5),
        Currency(code: "NGN", name: "Nigerian Naira", flag: "🇳🇬", rate: 1620),
        Currency(code: "KES", name: "Kenyan Shilling", flag: "🇰🇪", rate: 129),
        Currency(code: "GHS", name: "Ghanaian Cedi", flag: "🇬🇭", rate: 15.4),
        Currency(code: "MAD", name: "Moroccan Dirham", flag: "🇲🇦", rate: 9.85),
        Currency(code: "CLP", name: "Chilean Peso", flag: "🇨🇱", rate: 950),
        Currency(code: "COP", name: "Colombian Peso", flag: "🇨🇴", rate: 3960),
        Currency(code: "PEN", name: "Peruvian Sol", flag: "🇵🇪", rate: 3.73),
        Currency(code: "DOP", name: "Dominican Peso", flag: "🇩🇴", rate: 58.9),
        Currency(code: "JMD", name: "Jamaican Dollar", flag: "🇯🇲", rate: 156),
        Currency(code: "QAR", name: "Qatari Riyal", flag: "🇶🇦", rate: 3.64),
        Currency(code: "KWD", name: "Kuwaiti Dinar", flag: "🇰🇼", rate: 0.31),
    ]

    static let popular: [Currency] = Array(all.prefix(8))
}
