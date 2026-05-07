import Foundation

struct UnitItem: Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let toBase: Double
}

struct UnitCategory: Identifiable {
    let id: String
    let label: String
    let icon: String
    let units: [UnitItem]

    static let all: [UnitCategory] = [
        UnitCategory(id: "length", label: "Length", icon: "📏", units: [
            UnitItem(id: "m", symbol: "m", name: "Meters", toBase: 1),
            UnitItem(id: "km", symbol: "km", name: "Kilometers", toBase: 1000),
            UnitItem(id: "cm", symbol: "cm", name: "Centimeters", toBase: 0.01),
            UnitItem(id: "mm", symbol: "mm", name: "Millimeters", toBase: 0.001),
            UnitItem(id: "in", symbol: "in", name: "Inches", toBase: 0.0254),
            UnitItem(id: "ft", symbol: "ft", name: "Feet", toBase: 0.3048),
            UnitItem(id: "yd", symbol: "yd", name: "Yards", toBase: 0.9144),
            UnitItem(id: "mi", symbol: "mi", name: "Miles", toBase: 1609.344),
        ]),
        UnitCategory(id: "mass", label: "Mass", icon: "⚖️", units: [
            UnitItem(id: "kg", symbol: "kg", name: "Kilograms", toBase: 1),
            UnitItem(id: "g", symbol: "g", name: "Grams", toBase: 0.001),
            UnitItem(id: "mg", symbol: "mg", name: "Milligrams", toBase: 0.000001),
            UnitItem(id: "t", symbol: "t", name: "Tonnes", toBase: 1000),
            UnitItem(id: "lb", symbol: "lb", name: "Pounds", toBase: 0.453592),
            UnitItem(id: "oz", symbol: "oz", name: "Ounces", toBase: 0.0283495),
        ]),
        UnitCategory(id: "volume", label: "Volume", icon: "🥤", units: [
            UnitItem(id: "L", symbol: "L", name: "Liters", toBase: 1),
            UnitItem(id: "mL", symbol: "mL", name: "Milliliters", toBase: 0.001),
            UnitItem(id: "m³", symbol: "m³", name: "Cubic meters", toBase: 1000),
            UnitItem(id: "gal", symbol: "gal", name: "Gallons (US)", toBase: 3.78541),
            UnitItem(id: "fl oz", symbol: "fl oz", name: "Fluid ounces", toBase: 0.0295735),
            UnitItem(id: "cup", symbol: "cup", name: "Cups", toBase: 0.236588),
        ]),
        UnitCategory(id: "area", label: "Area", icon: "▭", units: [
            UnitItem(id: "m²", symbol: "m²", name: "Sq. meters", toBase: 1),
            UnitItem(id: "km²", symbol: "km²", name: "Sq. kilometers", toBase: 1_000_000),
            UnitItem(id: "ft²", symbol: "ft²", name: "Sq. feet", toBase: 0.092903),
            UnitItem(id: "acre", symbol: "acre", name: "Acres", toBase: 4046.86),
            UnitItem(id: "ha", symbol: "ha", name: "Hectares", toBase: 10000),
        ]),
        UnitCategory(id: "speed", label: "Speed", icon: "🏃", units: [
            UnitItem(id: "km/h", symbol: "km/h", name: "Km per hour", toBase: 0.277778),
            UnitItem(id: "m/s", symbol: "m/s", name: "Meters per sec", toBase: 1),
            UnitItem(id: "mph", symbol: "mph", name: "Miles per hour", toBase: 0.44704),
            UnitItem(id: "knot", symbol: "knot", name: "Knots", toBase: 0.514444),
        ]),
        UnitCategory(id: "time", label: "Duration", icon: "⏱", units: [
            UnitItem(id: "s", symbol: "s", name: "Seconds", toBase: 1),
            UnitItem(id: "min", symbol: "min", name: "Minutes", toBase: 60),
            UnitItem(id: "h", symbol: "h", name: "Hours", toBase: 3600),
            UnitItem(id: "day", symbol: "day", name: "Days", toBase: 86400),
            UnitItem(id: "week", symbol: "week", name: "Weeks", toBase: 604800),
        ]),
        UnitCategory(id: "energy", label: "Energy", icon: "⚡", units: [
            UnitItem(id: "J", symbol: "J", name: "Joules", toBase: 1),
            UnitItem(id: "kJ", symbol: "kJ", name: "Kilojoules", toBase: 1000),
            UnitItem(id: "cal", symbol: "cal", name: "Calories", toBase: 4.184),
            UnitItem(id: "kcal", symbol: "kcal", name: "Kilocalories", toBase: 4184),
            UnitItem(id: "kWh", symbol: "kWh", name: "Kilowatt-hours", toBase: 3_600_000),
        ]),
        UnitCategory(id: "data", label: "Data", icon: "💾", units: [
            UnitItem(id: "B", symbol: "B", name: "Bytes", toBase: 1),
            UnitItem(id: "KB", symbol: "KB", name: "Kilobytes", toBase: 1024),
            UnitItem(id: "MB", symbol: "MB", name: "Megabytes", toBase: 1_048_576),
            UnitItem(id: "GB", symbol: "GB", name: "Gigabytes", toBase: 1_073_741_824),
            UnitItem(id: "TB", symbol: "TB", name: "Terabytes", toBase: 1_099_511_627_776),
        ]),
    ]
}
