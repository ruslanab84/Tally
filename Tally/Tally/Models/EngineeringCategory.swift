import Foundation

struct EngUnit: Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let toBase: Double
}

struct EngCategory: Identifiable {
    let id: String
    let label: String
    let icon: String
    let units: [EngUnit]

    static let all: [EngCategory] = [
        // 1. Time
        EngCategory(id: "time", label: "Time", icon: "⏱", units: [
            EngUnit(id: "µs", symbol: "µs", name: "Microseconds", toBase: 0.000001),
            EngUnit(id: "ms", symbol: "ms", name: "Milliseconds", toBase: 0.001),
            EngUnit(id: "s", symbol: "s", name: "Seconds", toBase: 1),
            EngUnit(id: "min", symbol: "min", name: "Minutes", toBase: 60),
            EngUnit(id: "h", symbol: "h", name: "Hours", toBase: 3600),
            EngUnit(id: "day", symbol: "day", name: "Days", toBase: 86400),
            EngUnit(id: "week", symbol: "wk", name: "Weeks", toBase: 604800),
            EngUnit(id: "year", symbol: "yr", name: "Years", toBase: 31_536_000),
        ]),

        // 2. Acceleration
        EngCategory(id: "accel", label: "Acceleration", icon: "🚀", units: [
            EngUnit(id: "m/s²", symbol: "m/s²", name: "Meters/sec²", toBase: 1),
            EngUnit(id: "ft/s²", symbol: "ft/s²", name: "Feet/sec²", toBase: 0.3048),
            EngUnit(id: "g", symbol: "g", name: "Standard gravity", toBase: 9.80665),
            EngUnit(id: "gal", symbol: "Gal", name: "Gal (cm/s²)", toBase: 0.01),
            EngUnit(id: "in/s²", symbol: "in/s²", name: "Inches/sec²", toBase: 0.0254),
            EngUnit(id: "km/s²", symbol: "km/s²", name: "Km/sec²", toBase: 1000),
        ]),

        // 3. Density
        EngCategory(id: "density", label: "Density", icon: "🧊", units: [
            EngUnit(id: "kg/m³", symbol: "kg/m³", name: "Kg per m³", toBase: 1),
            EngUnit(id: "g/cm³", symbol: "g/cm³", name: "Grams per cm³", toBase: 1000),
            EngUnit(id: "g/L", symbol: "g/L", name: "Grams per liter", toBase: 1),
            EngUnit(id: "kg/L", symbol: "kg/L", name: "Kg per liter", toBase: 1000),
            EngUnit(id: "lb/ft³", symbol: "lb/ft³", name: "Pounds per ft³", toBase: 16.0185),
            EngUnit(id: "lb/gal", symbol: "lb/gal", name: "Pounds per gal", toBase: 119.826),
            EngUnit(id: "oz/in³", symbol: "oz/in³", name: "Ounces per in³", toBase: 1729.99),
        ]),

        // 4. Pressure
        EngCategory(id: "pressure", label: "Pressure", icon: "🌡", units: [
            EngUnit(id: "Pa", symbol: "Pa", name: "Pascals", toBase: 1),
            EngUnit(id: "kPa", symbol: "kPa", name: "Kilopascals", toBase: 1000),
            EngUnit(id: "MPa", symbol: "MPa", name: "Megapascals", toBase: 1_000_000),
            EngUnit(id: "bar", symbol: "bar", name: "Bar", toBase: 100_000),
            EngUnit(id: "atm", symbol: "atm", name: "Atmospheres", toBase: 101_325),
            EngUnit(id: "psi", symbol: "psi", name: "Pounds/in² (PSI)", toBase: 6894.76),
            EngUnit(id: "mmHg", symbol: "mmHg", name: "mm Mercury", toBase: 133.322),
            EngUnit(id: "inHg", symbol: "inHg", name: "Inches Mercury", toBase: 3386.39),
        ]),

        // 5. Energy, Work
        EngCategory(id: "energy", label: "Energy & Work", icon: "⚡", units: [
            EngUnit(id: "J", symbol: "J", name: "Joules", toBase: 1),
            EngUnit(id: "kJ", symbol: "kJ", name: "Kilojoules", toBase: 1000),
            EngUnit(id: "MJ", symbol: "MJ", name: "Megajoules", toBase: 1_000_000),
            EngUnit(id: "cal", symbol: "cal", name: "Calories", toBase: 4.184),
            EngUnit(id: "kcal", symbol: "kcal", name: "Kilocalories", toBase: 4184),
            EngUnit(id: "kWh", symbol: "kWh", name: "Kilowatt-hours", toBase: 3_600_000),
            EngUnit(id: "BTU", symbol: "BTU", name: "British thermal unit", toBase: 1055.06),
            EngUnit(id: "eV", symbol: "eV", name: "Electronvolts", toBase: 1.602e-19),
            EngUnit(id: "ft·lbf", symbol: "ft·lbf", name: "Foot-pounds", toBase: 1.35582),
        ]),

        // 6. Power
        EngCategory(id: "power", label: "Power", icon: "🔌", units: [
            EngUnit(id: "W", symbol: "W", name: "Watts", toBase: 1),
            EngUnit(id: "kW", symbol: "kW", name: "Kilowatts", toBase: 1000),
            EngUnit(id: "MW", symbol: "MW", name: "Megawatts", toBase: 1_000_000),
            EngUnit(id: "hp", symbol: "hp", name: "Horsepower (mech)", toBase: 745.7),
            EngUnit(id: "PS", symbol: "PS", name: "Horsepower (metric)", toBase: 735.499),
            EngUnit(id: "BTU/h", symbol: "BTU/h", name: "BTU per hour", toBase: 0.293071),
            EngUnit(id: "ft·lbf/s", symbol: "ft·lbf/s", name: "Foot-pounds/sec", toBase: 1.35582),
        ]),

        // 7. Force
        EngCategory(id: "force", label: "Force", icon: "💪", units: [
            EngUnit(id: "N", symbol: "N", name: "Newtons", toBase: 1),
            EngUnit(id: "kN", symbol: "kN", name: "Kilonewtons", toBase: 1000),
            EngUnit(id: "MN", symbol: "MN", name: "Meganewtons", toBase: 1_000_000),
            EngUnit(id: "kgf", symbol: "kgf", name: "Kilogram-force", toBase: 9.80665),
            EngUnit(id: "lbf", symbol: "lbf", name: "Pound-force", toBase: 4.44822),
            EngUnit(id: "dyn", symbol: "dyn", name: "Dynes", toBase: 0.00001),
            EngUnit(id: "pdl", symbol: "pdl", name: "Poundals", toBase: 0.138255),
        ]),

        // 8. Angular Measure
        EngCategory(id: "angle", label: "Angle", icon: "📐", units: [
            EngUnit(id: "deg", symbol: "°", name: "Degrees", toBase: 1),
            EngUnit(id: "rad", symbol: "rad", name: "Radians", toBase: 57.2958),
            EngUnit(id: "grad", symbol: "grad", name: "Gradians", toBase: 0.9),
            EngUnit(id: "arcmin", symbol: "′", name: "Arcminutes", toBase: 1.0 / 60.0),
            EngUnit(id: "arcsec", symbol: "″", name: "Arcseconds", toBase: 1.0 / 3600.0),
            EngUnit(id: "turn", symbol: "turn", name: "Turns", toBase: 360),
            EngUnit(id: "mrad", symbol: "mrad", name: "Milliradians", toBase: 0.0572958),
        ]),

        // 9. Wire Gauge (cross-section area)
        EngCategory(id: "wire", label: "Wire Gauge", icon: "🔌", units: [
            EngUnit(id: "mm²", symbol: "mm²", name: "Sq. millimeters", toBase: 1),
            EngUnit(id: "AWG4/0", symbol: "4/0", name: "AWG 4/0 (0000)", toBase: 107.2),
            EngUnit(id: "AWG2/0", symbol: "2/0", name: "AWG 2/0 (00)", toBase: 67.43),
            EngUnit(id: "AWG1/0", symbol: "1/0", name: "AWG 1/0 (0)", toBase: 53.49),
            EngUnit(id: "AWG2", symbol: "AWG 2", name: "AWG 2", toBase: 33.63),
            EngUnit(id: "AWG4", symbol: "AWG 4", name: "AWG 4", toBase: 21.15),
            EngUnit(id: "AWG6", symbol: "AWG 6", name: "AWG 6", toBase: 13.30),
            EngUnit(id: "AWG8", symbol: "AWG 8", name: "AWG 8", toBase: 8.366),
            EngUnit(id: "AWG10", symbol: "AWG 10", name: "AWG 10", toBase: 5.261),
            EngUnit(id: "AWG12", symbol: "AWG 12", name: "AWG 12", toBase: 3.309),
            EngUnit(id: "AWG14", symbol: "AWG 14", name: "AWG 14", toBase: 2.081),
            EngUnit(id: "AWG16", symbol: "AWG 16", name: "AWG 16", toBase: 1.309),
            EngUnit(id: "AWG18", symbol: "AWG 18", name: "AWG 18", toBase: 0.8231),
            EngUnit(id: "AWG20", symbol: "AWG 20", name: "AWG 20", toBase: 0.5176),
            EngUnit(id: "AWG22", symbol: "AWG 22", name: "AWG 22", toBase: 0.3255),
            EngUnit(id: "AWG24", symbol: "AWG 24", name: "AWG 24", toBase: 0.2047),
            EngUnit(id: "kcmil", symbol: "kcmil", name: "Kcmil / MCM", toBase: 0.5067),
        ]),

        // 10. Rotational Speed
        EngCategory(id: "rotation", label: "Rotation Speed", icon: "🔄", units: [
            EngUnit(id: "rpm", symbol: "rpm", name: "Rev. per minute", toBase: 1),
            EngUnit(id: "rps", symbol: "rps", name: "Rev. per second", toBase: 60),
            EngUnit(id: "rad/s", symbol: "rad/s", name: "Radians per sec", toBase: 9.5493),
            EngUnit(id: "deg/s", symbol: "°/s", name: "Degrees per sec", toBase: 1.0 / 6.0),
            EngUnit(id: "Hz", symbol: "Hz", name: "Hertz", toBase: 60),
        ]),

        // 11. Torque
        EngCategory(id: "torque", label: "Torque", icon: "🔧", units: [
            EngUnit(id: "N·m", symbol: "N·m", name: "Newton-meters", toBase: 1),
            EngUnit(id: "kN·m", symbol: "kN·m", name: "Kilonewton-meters", toBase: 1000),
            EngUnit(id: "kgf·m", symbol: "kgf·m", name: "Kilogram-force m", toBase: 9.80665),
            EngUnit(id: "lbf·ft", symbol: "lbf·ft", name: "Pound-force feet", toBase: 1.35582),
            EngUnit(id: "lbf·in", symbol: "lbf·in", name: "Pound-force inch", toBase: 0.112985),
            EngUnit(id: "ozf·in", symbol: "ozf·in", name: "Ounce-force inch", toBase: 0.00706155),
            EngUnit(id: "dyn·cm", symbol: "dyn·cm", name: "Dyne-centimeters", toBase: 1e-7),
        ]),

        // 12. Temperature Difference
        EngCategory(id: "tempdiff", label: "Temp Difference", icon: "🌡", units: [
            EngUnit(id: "ΔC", symbol: "Δ°C", name: "Celsius diff", toBase: 1),
            EngUnit(id: "ΔK", symbol: "ΔK", name: "Kelvin diff", toBase: 1),
            EngUnit(id: "ΔF", symbol: "Δ°F", name: "Fahrenheit diff", toBase: 5.0 / 9.0),
            EngUnit(id: "ΔR", symbol: "ΔR", name: "Rankine diff", toBase: 5.0 / 9.0),
        ]),

        // 13. Volume Flow Rate
        EngCategory(id: "volflow", label: "Volume Flow", icon: "🚿", units: [
            EngUnit(id: "m³/s", symbol: "m³/s", name: "Cubic m/sec", toBase: 1),
            EngUnit(id: "m³/h", symbol: "m³/h", name: "Cubic m/hour", toBase: 1.0 / 3600.0),
            EngUnit(id: "L/s", symbol: "L/s", name: "Liters/sec", toBase: 0.001),
            EngUnit(id: "L/min", symbol: "L/min", name: "Liters/min", toBase: 1.0 / 60000.0),
            EngUnit(id: "GPM", symbol: "GPM", name: "Gallons/min (US)", toBase: 6.309e-5),
            EngUnit(id: "CFM", symbol: "CFM", name: "Cubic feet/min", toBase: 4.71947e-4),
            EngUnit(id: "ft³/s", symbol: "ft³/s", name: "Cubic feet/sec", toBase: 0.0283168),
        ]),

        // 14. Mass Flow Rate
        EngCategory(id: "massflow", label: "Mass Flow", icon: "⚙️", units: [
            EngUnit(id: "kg/s", symbol: "kg/s", name: "Kg per second", toBase: 1),
            EngUnit(id: "kg/h", symbol: "kg/h", name: "Kg per hour", toBase: 1.0 / 3600.0),
            EngUnit(id: "g/s", symbol: "g/s", name: "Grams per second", toBase: 0.001),
            EngUnit(id: "t/h", symbol: "t/h", name: "Tonnes per hour", toBase: 1000.0 / 3600.0),
            EngUnit(id: "lb/s", symbol: "lb/s", name: "Pounds per second", toBase: 0.453592),
            EngUnit(id: "lb/h", symbol: "lb/h", name: "Pounds per hour", toBase: 0.453592 / 3600.0),
        ]),

        // 15. Illuminance
        EngCategory(id: "light", label: "Illuminance", icon: "💡", units: [
            EngUnit(id: "lux", symbol: "lx", name: "Lux", toBase: 1),
            EngUnit(id: "klux", symbol: "klx", name: "Kilolux", toBase: 1000),
            EngUnit(id: "fc", symbol: "fc", name: "Foot-candles", toBase: 10.7639),
            EngUnit(id: "phot", symbol: "ph", name: "Phot", toBase: 10000),
            EngUnit(id: "nox", symbol: "nox", name: "Nox (milli-lux)", toBase: 0.001),
        ]),

        // 16. Radiation (dose)
        EngCategory(id: "radiation", label: "Radiation", icon: "☢️", units: [
            EngUnit(id: "Sv", symbol: "Sv", name: "Sieverts", toBase: 1),
            EngUnit(id: "mSv", symbol: "mSv", name: "Millisieverts", toBase: 0.001),
            EngUnit(id: "µSv", symbol: "µSv", name: "Microsieverts", toBase: 0.000001),
            EngUnit(id: "rem", symbol: "rem", name: "Rem", toBase: 0.01),
            EngUnit(id: "mrem", symbol: "mrem", name: "Millirem", toBase: 0.00001),
            EngUnit(id: "Gy", symbol: "Gy", name: "Gray", toBase: 1),
            EngUnit(id: "rad_u", symbol: "rad", name: "Rad (CGS)", toBase: 0.01),
        ]),

        // 17. Radioactivity
        EngCategory(id: "radioactivity", label: "Radioactivity", icon: "⚛️", units: [
            EngUnit(id: "Bq", symbol: "Bq", name: "Becquerels", toBase: 1),
            EngUnit(id: "kBq", symbol: "kBq", name: "Kilobecquerels", toBase: 1000),
            EngUnit(id: "MBq", symbol: "MBq", name: "Megabecquerels", toBase: 1_000_000),
            EngUnit(id: "GBq", symbol: "GBq", name: "Gigabecquerels", toBase: 1_000_000_000),
            EngUnit(id: "Ci", symbol: "Ci", name: "Curies", toBase: 3.7e10),
            EngUnit(id: "mCi", symbol: "mCi", name: "Millicuries", toBase: 3.7e7),
            EngUnit(id: "µCi", symbol: "µCi", name: "Microcuries", toBase: 37000),
        ]),
    ]
}
