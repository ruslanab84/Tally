import SwiftUI

struct EngineeringView: View {
    @Environment(\.tokens) private var T
    @State private var selectedCategory = EngCategory.all[0]
    @State private var fromUnit: EngUnit
    @State private var toUnit: EngUnit
    @State private var inputText = "1"
    @FocusState private var inputFocused: Bool

    init() {
        let cat = EngCategory.all[0]
        _fromUnit = State(initialValue: cat.units[0])
        _toUnit = State(initialValue: cat.units[1])
    }

    private var inputValue: Double { Double(inputText) ?? 0 }
    private var result: Double { inputValue * fromUnit.toBase / toUnit.toBase }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Conversion card
                VStack(alignment: .leading, spacing: 0) {
                    Text(selectedCategory.label.uppercased())
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
                        .tracking(0.6)
                        .foregroundStyle(T.textMuted)

                    // FROM
                    HStack {
                        Text(fromUnit.name)
                            .font(.custom("JetBrainsMono-Regular", size: 14))
                            .foregroundStyle(T.textMuted)
                        Spacer()
                        TextField("0", text: $inputText)
                            .font(.custom("JetBrainsMono-Medium", size: 30))
                            .foregroundStyle(T.text)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .focused($inputFocused)
                            .frame(maxWidth: 200)
                    }
                    .padding(.top, 10)

                    // Swap
                    HStack(spacing: 12) {
                        VStack { Divider() }
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                let temp = fromUnit
                                fromUnit = toUnit
                                toUnit = temp
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.custom("JetBrainsMono-SemiBold", size: 12))
                                .foregroundStyle(.white)
                                .frame(width: 28, height: 28)
                                .background(T.accent)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        VStack { Divider() }
                    }
                    .padding(.vertical, 8)

                    // TO
                    HStack {
                        Text(toUnit.name)
                            .font(.custom("JetBrainsMono-Regular", size: 14))
                            .foregroundStyle(T.textMuted)
                        Spacer()
                        Text(formatResult(result))
                            .font(.custom("JetBrainsMono-Medium", size: 30))
                            .foregroundStyle(T.accent)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                    }

                    // FROM chips
                    Text("FROM")
                        .font(.custom("JetBrainsMono-SemiBold", size: 10))
                        .tracking(0.4)
                        .foregroundStyle(T.textMuted)
                        .padding(.top, 16)
                        .padding(.bottom, 4)

                    unitChips(selected: fromUnit) { unit in
                        fromUnit = unit
                    }

                    // TO chips
                    Text("TO")
                        .font(.custom("JetBrainsMono-SemiBold", size: 10))
                        .tracking(0.4)
                        .foregroundStyle(T.textMuted)
                        .padding(.top, 10)
                        .padding(.bottom, 4)

                    unitChips(selected: toUnit) { unit in
                        toUnit = unit
                    }
                }
                .padding(16)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // All conversions
                Text("ALL CONVERSIONS")
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                VStack(spacing: 0) {
                    let otherUnits = selectedCategory.units.filter { $0.id != fromUnit.id }
                    ForEach(Array(otherUnits.enumerated()), id: \.element.id) { index, unit in
                        Button {
                            toUnit = unit
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(unit.name)
                                        .font(.custom("JetBrainsMono-SemiBold", size: 14))
                                        .foregroundStyle(T.text)
                                    Text(unit.symbol)
                                        .font(.custom("JetBrainsMono-Medium", size: 11))
                                        .foregroundStyle(T.textMuted)
                                }
                                Spacer()
                                Text(formatResult(inputValue * fromUnit.toBase / unit.toBase))
                                    .font(.custom("JetBrainsMono-Medium", size: 18))
                                    .foregroundStyle(unit == toUnit ? T.accent : T.text)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(unit == toUnit ? T.accentSoft : .clear)
                        }
                        .buttonStyle(.plain)

                        if index < otherUnits.count - 1 {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))

                // Categories
                Text("CATEGORIES")
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                    ForEach(EngCategory.all) { category in
                        Button {
                            switchCategory(category)
                        } label: {
                            HStack(spacing: 10) {
                                Text(category.icon)
                                    .font(.custom("JetBrainsMono-Regular", size: 16))
                                    .frame(width: 32, height: 32)
                                    .background(selectedCategory.id == category.id ? T.accentSoft : T.surfaceAlt)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(category.label)
                                        .font(.custom("JetBrainsMono-SemiBold", size: 13))
                                        .foregroundStyle(selectedCategory.id == category.id ? T.accent : T.text)
                                        .lineLimit(1)
                                    Text("\(category.units.count) units")
                                        .font(.custom("JetBrainsMono-Regular", size: 11))
                                        .foregroundStyle(T.textMuted)
                                }
                                Spacer()
                            }
                            .padding(12)
                            .background(T.surface)
                            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
                            .overlay(
                                RoundedRectangle(cornerRadius: TallyRadius.medium)
                                    .stroke(selectedCategory.id == category.id ? T.accent : .clear, lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background { TallyBackground(T: T, icons: [
            "bolt", "gauge.open.with.lines.needle.33percent", "waveform.path",
            "arrow.up.right", "gearshape.2", "flame",
            "wrench.and.screwdriver", "atom",
        ]) }
        .navigationTitle("Engineering")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { inputFocused = false }
            }
        }
    }

    // MARK: - Helpers

    private func unitChips(selected: EngUnit, onSelect: @escaping (EngUnit) -> Void) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
            ForEach(selectedCategory.units) { unit in
                Button {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        onSelect(unit)
                    }
                } label: {
                    Text(unit.symbol)
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(selected == unit ? T.accentSoft : .clear)
                        .foregroundStyle(selected == unit ? T.accent : T.text)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selected == unit ? T.accent : T.border, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func switchCategory(_ category: EngCategory) {
        withAnimation(.easeInOut(duration: 0.15)) {
            selectedCategory = category
            fromUnit = category.units[0]
            toUnit = category.units.count > 1 ? category.units[1] : category.units[0]
            inputText = "1"
        }
    }

    private func formatResult(_ value: Double) -> String {
        if value == 0 { return "0" }
        if value.isNaN || value.isInfinite { return "—" }
        if value.truncatingRemainder(dividingBy: 1) == 0 && abs(value) < 1e12 {
            return String(format: "%.0f", value)
        }
        if abs(value) >= 100 {
            return String(format: "%.2f", value)
        }
        if abs(value) >= 1 {
            return String(format: "%.4f", value)
        }
        if abs(value) >= 0.001 {
            return String(format: "%.6f", value)
        }
        return String(format: "%.6g", value)
    }
}

#Preview {
    NavigationStack {
        EngineeringView()
    }
    .environment(\.tokens, .light)
}
