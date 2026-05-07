import SwiftUI

struct BMIView: View {
    @Environment(\.tokens) private var T
    @State private var system = "metric"
    @State private var weightText = "70"
    @State private var heightCmText = "175"
    @State private var heightFt = 5
    @State private var heightIn = 9
    @State private var weightLbsText = "154"
    @FocusState private var focused: FocusField?

    enum FocusField: Hashable {
        case weight, height, weightLbs
    }

    private var bmi: Double {
        if system == "metric" {
            let kg = Double(weightText) ?? 0
            let cm = Double(heightCmText) ?? 0
            guard kg > 0 && cm > 0 else { return 0 }
            let m = cm / 100
            return kg / (m * m)
        } else {
            let lbs = Double(weightLbsText) ?? 0
            let inches = Double(heightFt * 12 + heightIn)
            guard lbs > 0 && inches > 0 else { return 0 }
            return (lbs * 703) / (inches * inches)
        }
    }

    private var category: BMICategory {
        BMICategory.from(bmi)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // System toggle
                HStack(spacing: 8) {
                    ForEach(["metric", "imperial"], id: \.self) { s in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) { system = s }
                        } label: {
                            Text(s == "metric" ? "Metric" : "Imperial")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(system == s ? T.accent : .clear)
                                .foregroundStyle(system == s ? .white : T.text)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(system == s ? T.accent : T.border, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Input fields
                if system == "metric" {
                    metricInputs
                } else {
                    imperialInputs
                }

                // Result
                if bmi > 0 {
                    resultCard
                    bmiScale
                    categoriesInfo
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(T.bg)
        .navigationTitle("BMI")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focused = nil }
            }
        }
    }

    // MARK: - Metric

    private var metricInputs: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Text("WEIGHT")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                HStack(spacing: 4) {
                    TextField("0", text: $weightText)
                        .font(.custom("JetBrainsMono-Medium", size: 28))
                        .foregroundStyle(T.text)
                        .keyboardType(.decimalPad)
                        .focused($focused, equals: .weight)
                    Text("kg")
                        .font(.custom("JetBrainsMono-Medium", size: 16))
                        .foregroundStyle(T.textMuted)
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

            VStack(alignment: .leading, spacing: 6) {
                Text("HEIGHT")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                HStack(spacing: 4) {
                    TextField("0", text: $heightCmText)
                        .font(.custom("JetBrainsMono-Medium", size: 28))
                        .foregroundStyle(T.text)
                        .keyboardType(.decimalPad)
                        .focused($focused, equals: .height)
                    Text("cm")
                        .font(.custom("JetBrainsMono-Medium", size: 16))
                        .foregroundStyle(T.textMuted)
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }

    // MARK: - Imperial

    private var imperialInputs: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Text("WEIGHT")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                HStack(spacing: 4) {
                    TextField("0", text: $weightLbsText)
                        .font(.custom("JetBrainsMono-Medium", size: 28))
                        .foregroundStyle(T.text)
                        .keyboardType(.decimalPad)
                        .focused($focused, equals: .weightLbs)
                    Text("lbs")
                        .font(.custom("JetBrainsMono-Medium", size: 16))
                        .foregroundStyle(T.textMuted)
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("HEIGHT")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(0.6)
                        .foregroundStyle(T.textMuted)

                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text("\(heightFt)")
                                .font(.custom("JetBrainsMono-Medium", size: 28))
                                .foregroundStyle(T.text)
                            Text("ft")
                                .font(.custom("JetBrainsMono-Medium", size: 16))
                                .foregroundStyle(T.textMuted)
                        }

                        HStack(spacing: 4) {
                            Text("\(heightIn)")
                                .font(.custom("JetBrainsMono-Medium", size: 28))
                                .foregroundStyle(T.text)
                            Text("in")
                                .font(.custom("JetBrainsMono-Medium", size: 16))
                                .foregroundStyle(T.textMuted)
                        }
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        stepButton("−", enabled: heightFt > 3) { heightFt -= 1 }
                        Text("ft")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(T.textMuted)
                            .frame(width: 16)
                        stepButton("+", enabled: heightFt < 8) { heightFt += 1 }
                    }
                    HStack(spacing: 8) {
                        stepButton("−", enabled: heightIn > 0) { heightIn -= 1 }
                        Text("in")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(T.textMuted)
                            .frame(width: 16)
                        stepButton("+", enabled: heightIn < 11) { heightIn += 1 }
                    }
                }
                .padding(14)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
            }
        }
    }

    private func stepButton(_ symbol: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            if enabled { action() }
        } label: {
            Text(symbol)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 30, height: 30)
                .background(enabled ? T.surfaceAlt : T.surfaceAlt.opacity(0.5))
                .foregroundStyle(enabled ? T.text : T.textMuted)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Result Card

    private var resultCard: some View {
        VStack(spacing: 4) {
            Text("YOUR BMI")
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.6)
                .opacity(0.85)

            Text(String(format: "%.1f", bmi))
                .font(.custom("JetBrainsMono-SemiBold", size: 52))
                .tracking(-1.5)

            Text(category.label)
                .font(.system(size: 18, weight: .semibold))

            Text(category.description)
                .font(.system(size: 12))
                .opacity(0.8)
                .multilineTextAlignment(.center)
                .padding(.top, 2)

            if system == "metric" {
                let kg = Double(weightText) ?? 0
                let cm = Double(heightCmText) ?? 0
                if kg > 0 && cm > 0 {
                    let m = cm / 100
                    let idealLow = 18.5 * m * m
                    let idealHigh = 24.9 * m * m
                    Text("Healthy range: \(String(format: "%.0f", idealLow))–\(String(format: "%.0f", idealHigh)) kg")
                        .font(.custom("JetBrainsMono-Medium", size: 12))
                        .opacity(0.75)
                        .padding(.top, 6)
                }
            } else {
                let inches = Double(heightFt * 12 + heightIn)
                if inches > 0 {
                    let idealLow = 18.5 * inches * inches / 703
                    let idealHigh = 24.9 * inches * inches / 703
                    Text("Healthy range: \(String(format: "%.0f", idealLow))–\(String(format: "%.0f", idealHigh)) lbs")
                        .font(.custom("JetBrainsMono-Medium", size: 12))
                        .opacity(0.75)
                        .padding(.top, 6)
                }
            }
        }
        .foregroundStyle(.white)
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(category.color(T))
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    // MARK: - BMI Scale

    private var bmiScale: some View {
        VStack(spacing: 10) {
            GeometryReader { geo in
                let w = geo.size.width
                let segments: [(range: ClosedRange<Double>, color: Color)] = [
                    (0...18.5, T.blue),
                    (18.5...24.9, T.success),
                    (24.9...29.9, T.yellow),
                    (29.9...40, T.red),
                ]
                let totalRange = 40.0

                ZStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        ForEach(Array(segments.enumerated()), id: \.offset) { _, seg in
                            let fraction = (seg.range.upperBound - seg.range.lowerBound) / totalRange
                            RoundedRectangle(cornerRadius: 3)
                                .fill(seg.color)
                                .frame(width: max(0, w * CGFloat(fraction) - 2))
                        }
                    }
                    .frame(height: 10)

                    let clampedBmi = min(40, max(0, bmi))
                    let pos = CGFloat(clampedBmi / totalRange) * w

                    Triangle()
                        .fill(T.text)
                        .frame(width: 12, height: 8)
                        .offset(x: pos - 6, y: -10)

                    Circle()
                        .fill(T.text)
                        .frame(width: 6, height: 6)
                        .offset(x: pos - 3, y: 0)
                }
                .frame(height: 10)
            }
            .frame(height: 24)

            HStack {
                Text("0")
                Spacer()
                Text("18.5")
                    .offset(x: -4)
                Spacer()
                Text("25")
                Spacer()
                Text("30")
                Spacer()
                Text("40")
            }
            .font(.custom("JetBrainsMono-Medium", size: 10))
            .foregroundStyle(T.textMuted)
        }
        .padding(16)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
    }

    // MARK: - Categories

    private var categoriesInfo: some View {
        VStack(spacing: 0) {
            ForEach(Array(BMICategory.allCases.enumerated()), id: \.element) { i, cat in
                HStack(spacing: 12) {
                    Circle()
                        .fill(cat.color(T))
                        .frame(width: 10, height: 10)

                    Text(cat.label)
                        .font(.system(size: 14, weight: cat == category ? .semibold : .regular))
                        .foregroundStyle(cat == category ? T.text : T.textMuted)

                    Spacer()

                    Text(cat.rangeText)
                        .font(.custom("JetBrainsMono-Medium", size: 13))
                        .foregroundStyle(cat == category ? cat.color(T) : T.textMuted)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(cat == category ? cat.color(T).opacity(0.08) : .clear)

                if i < BMICategory.allCases.count - 1 {
                    Divider().padding(.leading, 38)
                }
            }
        }
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
    }
}

// MARK: - BMI Category

enum BMICategory: CaseIterable, Hashable {
    case underweight, normal, overweight, obese

    static func from(_ bmi: Double) -> BMICategory {
        if bmi < 18.5 { return .underweight }
        if bmi < 25   { return .normal }
        if bmi < 30   { return .overweight }
        return .obese
    }

    var label: String {
        switch self {
        case .underweight: return "Underweight"
        case .normal:      return "Normal"
        case .overweight:  return "Overweight"
        case .obese:       return "Obese"
        }
    }

    var rangeText: String {
        switch self {
        case .underweight: return "< 18.5"
        case .normal:      return "18.5 – 24.9"
        case .overweight:  return "25.0 – 29.9"
        case .obese:       return "≥ 30.0"
        }
    }

    var description: String {
        switch self {
        case .underweight: return "Below the healthy weight range"
        case .normal:      return "Within the healthy weight range"
        case .overweight:  return "Above the healthy weight range"
        case .obese:       return "Well above the healthy weight range"
        }
    }

    func color(_ T: TallyTokens) -> Color {
        switch self {
        case .underweight: return T.blue
        case .normal:      return T.success
        case .overweight:  return T.yellow
        case .obese:       return T.red
        }
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    NavigationStack {
        BMIView()
    }
    .environment(\.tokens, .light)
}
