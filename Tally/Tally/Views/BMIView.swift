import SwiftUI

struct BMIView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @State private var system = "metric"
    @State private var gender = "male"
    @State private var ageText = "25"
    @State private var weightText = "70"
    @State private var heightCmText = "175"
    @State private var heightFt = 5
    @State private var heightIn = 9
    @State private var weightLbsText = "154"
    @FocusState private var focused: FocusField?

    enum FocusField: Hashable {
        case weight, height, weightLbs, age
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

    private var age: Int { Int(ageText) ?? 25 }
    private var isMale: Bool { gender == "male" }

    private var category: BMICategory {
        BMICategory.from(bmi, age: age)
    }

    // Deurenberg formula: BF% = 1.20 × BMI + 0.23 × Age − 10.8 × sex − 5.4
    private var bodyFatPercent: Double {
        guard bmi > 0 && age > 0 else { return 0 }
        let sex = isMale ? 1.0 : 0.0
        return 1.20 * bmi + 0.23 * Double(age) - 10.8 * sex - 5.4
    }

    private var bodyFatCategory: String {
        let bf = bodyFatPercent
        if isMale {
            if bf < 6  { return L.essentialFat }
            if bf < 14 { return L.athletes }
            if bf < 18 { return L.fitness }
            if bf < 25 { return L.average }
            return L.aboveAverage
        } else {
            if bf < 14 { return L.essentialFat }
            if bf < 21 { return L.athletes }
            if bf < 25 { return L.fitness }
            if bf < 32 { return L.average }
            return L.aboveAverage
        }
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
                            Text(s == "metric" ? L.metric : L.imperial)
                                .font(.custom("JetBrainsMono-SemiBold", size: 14))
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

                // Gender & Age
                HStack(spacing: 10) {
                    // Gender
                    HStack(spacing: 6) {
                        ForEach(["male", "female"], id: \.self) { g in
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) { gender = g }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: g == "male" ? "figure.stand" : "figure.stand.dress")
                                        .font(.custom("JetBrainsMono-Regular", size: 16))
                                    Text(g == "male" ? L.man : L.woman)
                                        .font(.custom("JetBrainsMono-SemiBold", size: 13))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(gender == g ? (g == "male" ? T.blue : T.pink) : .clear)
                                .foregroundStyle(gender == g ? .white : T.text)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(gender == g ? (g == "male" ? T.blue : T.pink) : T.border, lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(8)
                    .background(T.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

                    // Age
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L.age)
                            .font(.custom("JetBrainsMono-SemiBold", size: 10))
                            .tracking(0.6)
                            .foregroundStyle(T.textMuted)
                        HStack(spacing: 4) {
                            TextField("25", text: $ageText)
                                .font(.custom("JetBrainsMono-Medium", size: 24))
                                .foregroundStyle(T.text)
                                .keyboardType(.numberPad)
                                .focused($focused, equals: .age)
                                .frame(maxWidth: 40)
                            Text("yr")
                                .font(.custom("JetBrainsMono-Medium", size: 14))
                                .foregroundStyle(T.textMuted)
                        }
                    }
                    .padding(12)
                    .background(T.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
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
        .background { TallyBackground(T: T, icons: [
            "figure.walk", "heart", "scalemass",
            "figure.run", "dumbbell", "flame",
            "leaf", "figure.cooldown",
        ]) }
        .navigationTitle(L.navBMI)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(L.done) { focused = nil }
            }
        }
    }

    // MARK: - Metric

    private var metricInputs: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Text(L.weight)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
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
                Text(L.height)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
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
                Text(L.weight)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
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
                    Text(L.height)
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
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
                            .font(.custom("JetBrainsMono-SemiBold", size: 12))
                            .foregroundStyle(T.textMuted)
                            .frame(width: 16)
                        stepButton("+", enabled: heightFt < 8) { heightFt += 1 }
                    }
                    HStack(spacing: 8) {
                        stepButton("−", enabled: heightIn > 0) { heightIn -= 1 }
                        Text("in")
                            .font(.custom("JetBrainsMono-SemiBold", size: 12))
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
                .font(.custom("JetBrainsMono-SemiBold", size: 16))
                .frame(width: 30, height: 30)
                .background(enabled ? T.surfaceAlt : T.surfaceAlt.opacity(0.5))
                .foregroundStyle(enabled ? T.text : T.textMuted)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Result Card

    private var resultCard: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Text(L.yourBMI)
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .opacity(0.85)

                Text(String(format: "%.1f", bmi))
                    .font(.custom("JetBrainsMono-SemiBold", size: 52))
                    .tracking(-1.5)

                Text(category.label(L))
                    .font(.custom("JetBrainsMono-SemiBold", size: 18))

                Text(category.desc(L))
                    .font(.custom("JetBrainsMono-Regular", size: 12))
                    .opacity(0.8)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
            }

            Rectangle().fill(.white.opacity(0.3)).frame(height: 1)
                .padding(.vertical, 14)

            // Body fat estimation
            if age >= 18 {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L.estBodyFat)
                            .font(.custom("JetBrainsMono-Regular", size: 12))
                            .opacity(0.8)
                        Text(bodyFatCategory)
                            .font(.custom("JetBrainsMono-Regular", size: 11))
                            .opacity(0.65)
                    }
                    Spacer()
                    Text(String(format: "%.1f%%", bodyFatPercent))
                        .font(.custom("JetBrainsMono-SemiBold", size: 22))
                }
                .padding(.bottom, 10)
            }

            // Healthy weight range
            if system == "metric" {
                let cm = Double(heightCmText) ?? 0
                if cm > 0 {
                    let m = cm / 100
                    let lo = category.healthyLow(age: age) * m * m
                    let hi = category.healthyHigh(age: age) * m * m
                    HStack {
                        Text(L.healthyRange)
                            .font(.custom("JetBrainsMono-Regular", size: 12))
                            .opacity(0.8)
                        Spacer()
                        Text("\(String(format: "%.0f", lo))–\(String(format: "%.0f", hi)) kg")
                            .font(.custom("JetBrainsMono-Medium", size: 13))
                    }
                }
            } else {
                let inches = Double(heightFt * 12 + heightIn)
                if inches > 0 {
                    let lo = category.healthyLow(age: age) * inches * inches / 703
                    let hi = category.healthyHigh(age: age) * inches * inches / 703
                    HStack {
                        Text(L.healthyRange)
                            .font(.custom("JetBrainsMono-Regular", size: 12))
                            .opacity(0.8)
                        Spacer()
                        Text("\(String(format: "%.0f", lo))–\(String(format: "%.0f", hi)) lbs")
                            .font(.custom("JetBrainsMono-Medium", size: 13))
                    }
                }
            }

            // Age-specific note
            if age > 0 {
                Text(ageNote)
                    .font(.custom("JetBrainsMono-Regular", size: 11))
                    .opacity(0.65)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
            }
        }
        .foregroundStyle(.white)
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(category.color(T))
        .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
    }

    private var ageNote: String {
        if age < 18 {
            return L.bmiChildNote
        }
        if age >= 65 {
            return L.bmiElderlyNote
        }
        return isMale
            ? "Healthy body fat for men age \(age): \(age < 40 ? "8–20%" : age < 60 ? "11–22%" : "13–25%")"
            : "Healthy body fat for women age \(age): \(age < 40 ? "21–33%" : age < 60 ? "23–34%" : "24–36%")"
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

                    Text(cat.label(L))
                        .font(.custom(cat == category ? "JetBrainsMono-SemiBold" : "JetBrainsMono-Regular", size: 14))
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

    static func from(_ bmi: Double, age: Int = 25) -> BMICategory {
        if age >= 65 {
            if bmi < 23   { return .underweight }
            if bmi < 30   { return .normal }
            if bmi < 35   { return .overweight }
            return .obese
        }
        if bmi < 18.5 { return .underweight }
        if bmi < 25   { return .normal }
        if bmi < 30   { return .overweight }
        return .obese
    }

    func label(_ L: Loc) -> String {
        switch self {
        case .underweight: return L.underweight
        case .normal:      return L.normal
        case .overweight:  return L.overweight
        case .obese:       return L.obese
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

    func desc(_ L: Loc) -> String {
        switch self {
        case .underweight: return L.underweightDesc
        case .normal:      return L.normalDesc
        case .overweight:  return L.overweightDesc
        case .obese:       return L.obeseDesc
        }
    }

    func healthyLow(age: Int) -> Double {
        age >= 65 ? 23.0 : 18.5
    }

    func healthyHigh(age: Int) -> Double {
        age >= 65 ? 30.0 : 24.9
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
