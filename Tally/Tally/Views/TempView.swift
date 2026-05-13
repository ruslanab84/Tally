import SwiftUI

struct TempView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @State private var inputText = "22"
    @State private var selectedUnit = "°C"
    @FocusState private var inputFocused: Bool

    private var inputValue: Double { Double(inputText) ?? 0 }

    private var celsius: Double {
        switch selectedUnit {
        case "°F": return (inputValue - 32) * 5.0 / 9.0
        case "K":  return inputValue - 273.15
        default:   return inputValue
        }
    }

    private var fahrenheit: Double { celsius * 9.0 / 5.0 + 32 }
    private var kelvin: Double { celsius + 273.15 }

    private var sliderMin: Double {
        switch selectedUnit {
        case "°F": return -40
        case "K":  return 233
        default:   return -40
        }
    }

    private var sliderMax: Double {
        switch selectedUnit {
        case "°F": return 212
        case "K":  return 373
        default:   return 100
        }
    }

    private var sliderFraction: CGFloat {
        let range = sliderMax - sliderMin
        guard range > 0 else { return 0 }
        return CGFloat(min(1, max(0, (inputValue - sliderMin) / range)))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Unit selector
                HStack(spacing: 8) {
                    ForEach(["°C", "°F", "K"], id: \.self) { unit in
                        Button {
                            switchUnit(to: unit)
                        } label: {
                            Text(unit)
                                .font(.custom("JetBrainsMono-SemiBold", size: 14))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(selectedUnit == unit ? T.accent : .clear)
                                .foregroundStyle(selectedUnit == unit ? .white : T.text)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedUnit == unit ? T.accent : T.border, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Main card
                VStack(spacing: 16) {
                    HStack(alignment: .bottom) {
                        Text(selectedUnit)
                            .font(.custom("JetBrainsMono-Regular", size: 14))
                            .foregroundStyle(T.textMuted)
                        Spacer()
                        HStack(alignment: .bottom, spacing: 2) {
                            TextField("0", text: $inputText)
                                .font(.custom("JetBrainsMono-Medium", size: 44))
                                .tracking(-1)
                                .foregroundStyle(T.accent)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .focused($inputFocused)
                                .frame(maxWidth: 200)

                            Text(selectedUnit)
                                .font(.custom("JetBrainsMono-Medium", size: 20))
                                .foregroundStyle(T.accent)
                                .padding(.bottom, 4)
                        }
                    }

                    // Gradient slider
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "3A6FF7"), T.accent, Color(hex: "D14545")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 6)

                            Circle()
                                .fill(T.surface)
                                .frame(width: 18, height: 18)
                                .overlay(Circle().stroke(T.accent, lineWidth: 3))
                                .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                                .offset(x: max(0, min(geo.size.width - 18, sliderFraction * geo.size.width - 9)))
                        }
                        .frame(height: 18)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let pct = min(1, max(0, value.location.x / geo.size.width))
                                    let newVal = sliderMin + Double(pct) * (sliderMax - sliderMin)
                                    inputText = formatTemp(newVal)
                                }
                        )
                    }
                    .frame(height: 18)

                    HStack {
                        Text(formatTemp(sliderMin) + unitSuffix)
                        Spacer()
                        Text(formatTemp((sliderMin + sliderMax) / 2) + unitSuffix)
                        Spacer()
                        Text(formatTemp(sliderMax) + unitSuffix)
                    }
                    .font(.custom("JetBrainsMono-Medium", size: 11))
                    .foregroundStyle(T.textMuted)
                }
                .padding(18)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Conversion results (hide the selected unit)
                if selectedUnit != "°C" {
                    TempResultRow(T: T, label: L.celsius, unit: "°C",
                                  value: formatTemp(celsius) + "°C")
                }
                if selectedUnit != "°F" {
                    TempResultRow(T: T, label: L.fahrenheit, unit: "°F",
                                  value: formatTemp(fahrenheit) + "°F")
                }
                if selectedUnit != "K" {
                    TempResultRow(T: T, label: L.kelvin, unit: "K",
                                  value: formatTemp(kelvin) + " K")
                }

                // Reference
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L.reference)
                            .font(.custom("JetBrainsMono-SemiBold", size: 14))
                            .foregroundStyle(T.text)
                        Text(referenceText)
                            .font(.custom("JetBrainsMono-Regular", size: 11))
                            .foregroundStyle(T.textMuted)
                    }
                    Spacer()
                    Text(referenceEmoji).font(.custom("JetBrainsMono-Regular", size: 18))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background { TallyBackground(T: T, icons: [
            "thermometer.medium", "snowflake", "sun.max",
            "flame", "wind", "cloud.sun", "thermometer.low",
            "thermometer.high",
        ]) }
        .navigationTitle(L.navTemp)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("±") {
                    if inputText.hasPrefix("-") {
                        inputText = String(inputText.dropFirst())
                    } else if inputText != "0" {
                        inputText = "-" + inputText
                    }
                }
                Spacer()
                Button(L.done) { inputFocused = false }
            }
        }
    }

    // MARK: - Helpers

    private var unitSuffix: String {
        selectedUnit == "K" ? "" : "°"
    }

    private func switchUnit(to newUnit: String) {
        guard newUnit != selectedUnit else { return }
        let newValue: Double = switch newUnit {
        case "°F": fahrenheit
        case "K":  kelvin
        default:   celsius
        }
        selectedUnit = newUnit
        inputText = formatTemp(newValue)
    }

    private func formatTemp(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 && abs(value) < 1e10 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.1f", value)
    }

    private var referenceText: String {
        let c = celsius
        if c < -20 { return L.tempExtremeCold }
        if c < 0   { return L.tempBelowFreezing }
        if c < 10  { return L.tempCold }
        if c < 20  { return L.tempCool }
        if c < 26  { return L.tempComfortable }
        if c < 35  { return L.tempWarm }
        if c < 45  { return L.tempHot }
        return L.tempExtremeHeat
    }

    private var referenceEmoji: String {
        let c = celsius
        if c < -20 { return "🥶" }
        if c < 0   { return "❄️" }
        if c < 10  { return "🧊" }
        if c < 20  { return "🌥️" }
        if c < 26  { return "🌤️" }
        if c < 35  { return "☀️" }
        return "🔥"
    }
}

private struct TempResultRow: View {
    let T: TallyTokens
    let label: String
    let unit: String
    let value: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.custom("JetBrainsMono-SemiBold", size: 14))
                    .foregroundStyle(T.text)
                Text(unit)
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .foregroundStyle(T.textMuted)
            }
            Spacer()
            Text(value)
                .font(.custom("JetBrainsMono-Medium", size: 22))
                .foregroundStyle(T.text)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
    }
}

#Preview {
    NavigationStack {
        TempView()
    }
    .environment(\.tokens, .light)
}
