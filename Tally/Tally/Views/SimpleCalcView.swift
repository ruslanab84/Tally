import SwiftUI

struct SimpleCalcView: View {
    @Environment(\.tokens) private var T
    @State private var display = "0"
    @State private var expression = ""
    @State private var firstOperand: Double = 0
    @State private var pendingOp: String? = nil
    @State private var isNewInput = true
    @State private var tapCount = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(expression)
                    .font(.custom("JetBrainsMono-Medium", size: 16))
                    .foregroundStyle(T.textMuted)
                    .frame(minHeight: 22)

                Text(display)
                    .font(.custom("JetBrainsMono-Medium", size: 56))
                    .fontWeight(.medium)
                    .tracking(-1.5)
                    .foregroundStyle(T.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 22)
            .padding(.bottom, 24)

            VStack(spacing: 10) {
                let rows: [[(String, CalcKeyKind)]] = [
                    [("AC", .fn), ("±", .fn), ("%", .fn), ("÷", .op)],
                    [("7", .num), ("8", .num), ("9", .num), ("×", .op)],
                    [("4", .num), ("5", .num), ("6", .num), ("−", .op)],
                    [("1", .num), ("2", .num), ("3", .num), ("+", .op)],
                ]

                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    HStack(spacing: 10) {
                        ForEach(Array(row.enumerated()), id: \.offset) { _, key in
                            CalcKeyButton(label: key.0, kind: key.1) {
                                handleKey(key.0)
                            }
                        }
                    }
                }

                HStack(spacing: 10) {
                    CalcKeyButton(label: "0", kind: .num) { handleKey("0") }
                        .frame(maxWidth: .infinity)
                    CalcKeyButton(label: "0", kind: .num) {}
                        .hidden()
                    CalcKeyButton(label: ".", kind: .num) { handleKey(".") }
                    CalcKeyButton(label: "=", kind: .eq) { handleKey("=") }
                }
                .overlay(alignment: .leading) {
                    GeometryReader { geo in
                        CalcKeyButton(label: "0", kind: .num) { handleKey("0") }
                            .frame(width: geo.size.width * 0.5 - 5)
                    }
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xxl))
            .shadow(color: .black.opacity(0.04), radius: 7, y: 2)
            .padding(.horizontal, 14)
            .padding(.bottom, 16)
        }
        .background(T.bg)
        .navigationTitle("Calculator")
        .navigationBarTitleDisplayMode(.large)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: tapCount)
    }

    // MARK: - Input handling

    private func handleKey(_ key: String) {
        tapCount += 1
        switch key {
        case "0"..."9":
            inputDigit(key)
        case ".":
            inputDecimal()
        case "AC":
            clear()
        case "±":
            negate()
        case "%":
            percent()
        case "+", "−", "×", "÷":
            inputOperation(key)
        case "=":
            evaluate()
        default:
            break
        }
    }

    private func inputDigit(_ digit: String) {
        if isNewInput {
            display = digit
            isNewInput = false
        } else if display.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "").count < 12 {
            display = display == "0" ? digit : display + digit
        }
    }

    private func inputDecimal() {
        if isNewInput {
            display = "0."
            isNewInput = false
        } else if !display.contains(".") {
            display += "."
        }
    }

    private func clear() {
        display = "0"
        expression = ""
        firstOperand = 0
        pendingOp = nil
        isNewInput = true
    }

    private func negate() {
        guard let value = Double(display), value != 0 else { return }
        display = formatNumber(-value)
    }

    private func percent() {
        guard let value = Double(display) else { return }
        display = formatNumber(value / 100.0)
        isNewInput = true
    }

    private func inputOperation(_ op: String) {
        guard let value = Double(display) else { return }
        if pendingOp != nil && !isNewInput {
            let result = calculate(firstOperand, pendingOp!, value)
            firstOperand = result
            display = formatNumber(result)
        } else {
            firstOperand = value
        }
        expression = "\(formatNumber(firstOperand)) \(op)"
        pendingOp = op
        isNewInput = true
    }

    private func evaluate() {
        guard let op = pendingOp, let secondOperand = Double(display) else { return }
        if op == "÷" && secondOperand == 0 {
            expression = "\(formatNumber(firstOperand)) \(op) 0 ="
            display = "Error"
            pendingOp = nil
            isNewInput = true
            return
        }
        let result = calculate(firstOperand, op, secondOperand)
        expression = "\(formatNumber(firstOperand)) \(op) \(formatNumber(secondOperand)) ="
        display = formatNumber(result)
        firstOperand = result
        pendingOp = nil
        isNewInput = true
    }

    // MARK: - Math

    private func calculate(_ a: Double, _ op: String, _ b: Double) -> Double {
        switch op {
        case "+": return a + b
        case "−": return a - b
        case "×": return a * b
        case "÷": return a / b
        default: return b
        }
    }

    private func formatNumber(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.10g", value)
    }
}

enum CalcKeyKind {
    case num, op, fn, eq
}

struct CalcKeyButton: View {
    @Environment(\.tokens) private var T
    let label: String
    let kind: CalcKeyKind
    let action: () -> Void

    private var bgColor: Color {
        switch kind {
        case .num: return T.keyNum
        case .op:  return T.keyOp
        case .fn:  return T.keyFn
        case .eq:  return T.accent
        }
    }

    private var fgColor: Color {
        switch kind {
        case .num: return T.text
        case .op:  return T.accent
        case .fn:  return T.text
        case .eq:  return .white
        }
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: kind == .fn ? 18 : 22, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(bgColor)
                .foregroundStyle(fgColor)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
                .shadow(
                    color: kind == .eq ? T.accent.opacity(0.35) : .black.opacity(0.04),
                    radius: kind == .eq ? 7 : 0,
                    y: kind == .eq ? 3 : 1
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SimpleCalcView()
    }
    .environment(\.tokens, .light)
}
