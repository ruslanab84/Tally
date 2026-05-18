import SwiftUI

// MARK: - Graph Function

enum GraphFunc: String, CaseIterable, Identifiable {
    case sine = "sin(x)"
    case cosine = "cos(x)"
    case square = "x²"
    case squareRoot = "√x"
    case reciprocal = "1/x"
    case logarithm = "log(x)"

    var id: String { rawValue }

    func evaluate(_ x: Double) -> Double {
        switch self {
        case .sine: return sin(x)
        case .cosine: return cos(x)
        case .square: return x * x
        case .squareRoot: return sqrt(max(0, x))
        case .reciprocal: return abs(x) > 0.05 ? 1 / x : .nan
        case .logarithm: return x > 0 ? log10(x) : .nan
        }
    }

    var xMin: Double {
        switch self {
        case .sine, .cosine: return -2 * .pi
        case .square: return -3
        case .squareRoot: return 0
        case .reciprocal: return -5
        case .logarithm: return 0.1
        }
    }

    var xMax: Double {
        switch self {
        case .sine, .cosine: return 2 * .pi
        case .square: return 3
        case .squareRoot: return 10
        case .reciprocal: return 5
        case .logarithm: return 10
        }
    }

    var yMin: Double {
        switch self {
        case .sine, .cosine: return -1.5
        case .square: return -1
        case .squareRoot: return -0.5
        case .reciprocal: return -5
        case .logarithm: return -2
        }
    }

    var yMax: Double {
        switch self {
        case .sine, .cosine: return 1.5
        case .square: return 10
        case .squareRoot: return 4
        case .reciprocal: return 5
        case .logarithm: return 2
        }
    }

    var xLabels: (String, String, String) {
        switch self {
        case .sine, .cosine: return ("−2π", "0", "2π")
        case .square: return ("−3", "0", "3")
        case .squareRoot: return ("0", "5", "10")
        case .reciprocal: return ("−5", "0", "5")
        case .logarithm: return ("0.1", "5", "10")
        }
    }

    var rangeStr: String {
        String(format: "%.2f → %.2f", xMin, xMax)
    }
}

// MARK: - Main View

struct SciCalcView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @EnvironmentObject var historyStore: HistoryStore
    @State private var mode: SciMode = .sci

    enum SciMode: String, CaseIterable {
        case sci = "Scientific"
        case prog = "Programmer"
        case graph = "Graph"
    }

    // Scientific state
    @State private var sciDisplay = "0"
    @State private var sciExpr = ""
    @State private var sciFirst: Double = 0
    @State private var sciOp: String? = nil
    @State private var sciNewInput = true
    @State private var sciMemory: Double = 0
    @State private var sciStack: [(first: Double, op: String?)] = []

    // Programmer state
    @State private var progVal: Int64 = 0
    @State private var progBase = "DEC"
    @State private var progFirst: Int64 = 0
    @State private var progOp: String? = nil
    @State private var progNewInput = true

    // Graph state
    @State private var graphFunc: GraphFunc = .sine

    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @State private var tapCount = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Picker("Mode", selection: $mode) {
                    ForEach(SciMode.allCases, id: \.self) { m in
                        Text(m == .sci ? L.sciModeSci : m == .prog ? L.sciModeProg : L.sciModeGraph).tag(m)
                    }
                }
                .pickerStyle(.segmented)

                switch mode {
                case .sci:   sciView
                case .prog:  progView
                case .graph: graphView
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 20)
        }
        .background { TallyBackground(T: T, icons: [
            "function", "sum", "x.squareroot", "angle",
            "infinity", "pi", "chart.xyaxis.line", "number",
        ]) }
        .navigationTitle(L.navScientific)
        .navigationBarTitleDisplayMode(.large)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: tapCount) { _, _ in hapticEnabled }
    }

    // MARK: - Scientific View

    private var sciView: some View {
        VStack(spacing: 14) {
            VStack(alignment: .trailing, spacing: 6) {
                HStack {
                    if sciMemory != 0 {
                        Text("M: \(sciFormat(sciMemory))")
                            .font(.custom("JetBrainsMono-SemiBold", size: 11))
                            .tracking(0.4)
                            .foregroundStyle(T.accent)
                    }
                    Spacer()
                }

                Text(sciExpr)
                    .font(.custom("JetBrainsMono-Medium", size: 16))
                    .foregroundStyle(T.textMuted)
                    .frame(minHeight: 20)

                Text(sciDisplay)
                    .font(.custom("JetBrainsMono-Medium", size: 48))
                    .fontWeight(.medium)
                    .tracking(-1.5)
                    .foregroundStyle(T.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 6)

            let keys: [[(String, CalcKeyKind)]] = [
                [("MC", .fn), ("MR", .fn), ("M+", .fn), ("M−", .fn), ("AC", .fn)],
                [("sin", .fn), ("cos", .fn), ("tan", .fn), ("π", .fn), ("÷", .op)],
                [("ln", .fn), ("log", .fn), ("x²", .fn), ("√", .fn), ("×", .op)],
                [("(", .fn), (")", .fn), ("xʸ", .fn), ("1/x", .fn), ("−", .op)],
                [("7", .num), ("8", .num), ("9", .num), ("e", .fn), ("+", .op)],
                [("4", .num), ("5", .num), ("6", .num), ("n!", .fn), ("=", .eq)],
                [("1", .num), ("2", .num), ("3", .num), ("0", .num), (".", .num)],
            ]

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                ForEach(Array(keys.joined().enumerated()), id: \.offset) { _, key in
                    SciKeyButton(label: key.0, kind: key.1) {
                        sciHandleKey(key.0)
                    }
                }
            }
            .padding(12)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }

    // MARK: - Scientific Logic

    private func sciHandleKey(_ key: String) {
        tapCount += 1
        switch key {
        case "0"..."9": sciInputDigit(key)
        case ".":       sciInputDecimal()
        case "AC":      sciClear()
        case "+", "−", "×", "÷": sciInputOp(key)
        case "xʸ":     sciInputOp("^")
        case "=":       sciEvaluate()
        case "sin", "cos", "tan": sciTrig(key)
        case "ln":      sciUnary("ln") { $0 > 0 ? log($0) : .nan }
        case "log":     sciUnary("log") { $0 > 0 ? log10($0) : .nan }
        case "x²":      sciUnary("²") { $0 * $0 }
        case "√":       sciUnary("√") { $0 >= 0 ? sqrt($0) : .nan }
        case "1/x":     sciUnary("1/") { $0 != 0 ? 1 / $0 : .nan }
        case "n!":      sciUnary("!") { self.factorial(Int($0)) }
        case "π":
            sciDisplay = sciFormat(.pi)
            sciNewInput = true
        case "e":
            sciDisplay = sciFormat(M_E)
            sciNewInput = true
        case "MC":  sciMemory = 0
        case "MR":
            if sciMemory != 0 {
                sciDisplay = sciFormat(sciMemory)
                sciNewInput = true
            }
        case "M+":  if let v = Double(sciDisplay) { sciMemory += v }
        case "M−":  if let v = Double(sciDisplay) { sciMemory -= v }
        case "(":   sciOpenParen()
        case ")":   sciCloseParen()
        default: break
        }
    }

    private func sciInputDigit(_ d: String) {
        if sciNewInput {
            sciDisplay = d
            sciNewInput = false
        } else if sciDisplay.filter({ $0.isNumber }).count < 15 {
            sciDisplay = sciDisplay == "0" ? d : sciDisplay + d
        }
    }

    private func sciInputDecimal() {
        if sciNewInput {
            sciDisplay = "0."
            sciNewInput = false
        } else if !sciDisplay.contains(".") {
            sciDisplay += "."
        }
    }

    private func sciClear() {
        sciDisplay = "0"
        sciExpr = ""
        sciFirst = 0
        sciOp = nil
        sciNewInput = true
        sciStack = []
    }

    private func sciInputOp(_ op: String) {
        guard let value = Double(sciDisplay) else { return }
        if sciOp != nil && !sciNewInput {
            let result = sciCalc(sciFirst, sciOp!, value)
            sciFirst = result
            sciDisplay = sciFormat(result)
        } else {
            sciFirst = value
        }
        let symbol = op == "^" ? "^" : op
        sciExpr = "\(sciFormat(sciFirst)) \(symbol)"
        sciOp = op
        sciNewInput = true
    }

    private func sciEvaluate() {
        guard let op = sciOp, let second = Double(sciDisplay) else { return }
        if op == "÷" && second == 0 {
            sciExpr = "\(sciFormat(sciFirst)) ÷ 0 ="
            sciDisplay = "Error"
            sciOp = nil
            sciNewInput = true
            return
        }
        let result = sciCalc(sciFirst, op, second)
        let symbol = op == "^" ? "^" : op
        sciExpr = "\(sciFormat(sciFirst)) \(symbol) \(sciFormat(second)) ="
        sciDisplay = sciFormat(result)
        sciFirst = result
        sciOp = nil
        sciNewInput = true
        historyStore.add(expression: sciExpr, result: sciDisplay, type: .sci)
    }

    private func sciUnary(_ name: String, _ fn: (Double) -> Double) {
        guard let value = Double(sciDisplay) else { return }
        let result = fn(value)
        sciExpr = "\(name)(\(sciFormat(value)))"
        if result.isNaN || result.isInfinite {
            sciDisplay = "Error"
        } else {
            sciDisplay = sciFormat(result)
        }
        sciNewInput = true
        if sciDisplay != "Error" {
            historyStore.add(expression: sciExpr, result: sciDisplay, type: .sci)
        }
    }

    private func sciTrig(_ name: String) {
        guard let value = Double(sciDisplay) else { return }
        let radians = value * .pi / 180
        let result: Double = switch name {
        case "sin": sin(radians)
        case "cos": cos(radians)
        case "tan": tan(radians)
        default: 0
        }
        sciExpr = "\(name)(\(sciFormat(value))°)"
        if result.isNaN || result.isInfinite {
            sciDisplay = "Error"
        } else {
            sciDisplay = sciFormat(result)
        }
        sciNewInput = true
        if sciDisplay != "Error" {
            historyStore.add(expression: sciExpr, result: sciDisplay, type: .sci)
        }
    }

    private func sciOpenParen() {
        sciStack.append((first: sciFirst, op: sciOp))
        sciFirst = 0
        sciOp = nil
        sciNewInput = true
    }

    private func sciCloseParen() {
        if let op = sciOp, let value = Double(sciDisplay) {
            let result = sciCalc(sciFirst, op, value)
            sciDisplay = sciFormat(result)
            sciOp = nil
        }
        if let saved = sciStack.popLast() {
            sciFirst = saved.first
            sciOp = saved.op
            sciNewInput = saved.op == nil
        }
    }

    private func sciCalc(_ a: Double, _ op: String, _ b: Double) -> Double {
        switch op {
        case "+": return a + b
        case "−": return a - b
        case "×": return a * b
        case "÷": return a / b
        case "^": return pow(a, b)
        default: return b
        }
    }

    private func factorial(_ n: Int) -> Double {
        if n < 0 { return .nan }
        if n <= 1 { return 1 }
        if n > 170 { return .infinity }
        var result: Double = 1
        for i in 2...n { result *= Double(i) }
        return result
    }

    private func sciFormat(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.10g", value)
    }

    // MARK: - Programmer View

    private var progView: some View {
        VStack(spacing: 14) {
            VStack(alignment: .trailing, spacing: 8) {
                Text(progMainDisplay)
                    .font(.custom("JetBrainsMono-Medium", size: 36))
                    .fontWeight(.medium)
                    .tracking(-1)
                    .foregroundStyle(T.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)

                Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 4) {
                    ForEach(["HEX", "DEC", "OCT", "BIN"], id: \.self) { base in
                        GridRow {
                            Text(base)
                                .font(.custom("JetBrainsMono-Medium", size: 12))
                                .foregroundStyle(base == progBase ? T.accent : T.textMuted)
                            Text(progFormatValue(base))
                                .font(.custom("JetBrainsMono-Medium", size: 12))
                                .foregroundStyle(base == progBase ? T.accent : T.text)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 18)

            HStack(spacing: 8) {
                ForEach(["HEX", "DEC", "OCT", "BIN"], id: \.self) { base in
                    Button {
                        tapCount += 1
                        progBase = base
                    } label: {
                        Text(base)
                            .font(.custom("JetBrainsMono-SemiBold", size: 12))
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(base == progBase ? T.accent : .clear)
                            .foregroundStyle(base == progBase ? .white : T.text)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(T.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            let keys: [[(String, CalcKeyKind)]] = [
                [("AC", .fn), ("<<", .fn), (">>", .fn), ("NOT", .fn), ("÷", .op)],
                [("A", .fn), ("B", .fn), ("C", .fn), ("AND", .fn), ("×", .op)],
                [("D", .fn), ("E", .fn), ("F", .fn), ("OR", .fn), ("−", .op)],
                [("7", .num), ("8", .num), ("9", .num), ("XOR", .fn), ("+", .op)],
                [("4", .num), ("5", .num), ("6", .num), ("0", .num), ("=", .eq)],
                [("1", .num), ("2", .num), ("3", .num), ("00", .num), (".", .num)],
            ]

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                ForEach(Array(keys.joined().enumerated()), id: \.offset) { _, key in
                    Button {
                        progHandleKey(key.0)
                    } label: {
                        Text(key.0)
                            .font(.custom("JetBrainsMono-Medium", size: 13))
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(key.1 == .eq ? T.accent : key.1 == .op ? T.keyOp : key.1 == .fn ? T.keyFn : T.keyNum)
                            .foregroundStyle(key.1 == .eq ? .white : key.1 == .op ? T.accent : T.text)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .opacity(progKeyEnabled(key.0) ? 1 : 0.3)
                    }
                    .buttonStyle(.plain)
                    .disabled(!progKeyEnabled(key.0))
                }
            }
            .padding(12)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }

    // MARK: - Programmer Logic

    private var progMainDisplay: String {
        switch progBase {
        case "HEX": return "0x\(progFormatValue("HEX"))"
        case "OCT": return "0o\(progFormatValue("OCT"))"
        case "BIN": return progFormatValue("BIN")
        default:    return progFormatValue("DEC")
        }
    }

    private func progFormatValue(_ base: String) -> String {
        switch base {
        case "HEX": return String(progVal, radix: 16, uppercase: true)
        case "DEC": return String(progVal)
        case "OCT": return String(progVal, radix: 8)
        case "BIN":
            if progVal == 0 { return "0" }
            let s = String(progVal, radix: 2)
            let isNeg = s.hasPrefix("-")
            let digits = isNeg ? String(s.dropFirst()) : s
            var result = ""
            for (i, c) in digits.reversed().enumerated() {
                if i > 0 && i % 4 == 0 { result = " " + result }
                result = String(c) + result
            }
            return isNeg ? "-\(result)" : result
        default: return String(progVal)
        }
    }

    private func progKeyEnabled(_ key: String) -> Bool {
        switch key {
        case "A", "B", "C", "D", "E", "F": return progBase == "HEX"
        case "8", "9":                       return progBase == "HEX" || progBase == "DEC"
        case "2"..."7":                      return progBase != "BIN"
        case ".":                            return false
        default:                             return true
        }
    }

    private var progBaseMultiplier: Int64 {
        switch progBase {
        case "HEX": return 16
        case "OCT": return 8
        case "BIN": return 2
        default:    return 10
        }
    }

    private func progHandleKey(_ key: String) {
        tapCount += 1
        switch key {
        case "0"..."9": progInputDigit(Int64(key)!)
        case "00":      progInputDigit(0); progInputDigit(0)
        case "A":       progInputDigit(10)
        case "B":       progInputDigit(11)
        case "C":       progInputDigit(12)
        case "D":       progInputDigit(13)
        case "E":       progInputDigit(14)
        case "F":       progInputDigit(15)
        case "AC":
            progVal = 0; progFirst = 0; progOp = nil; progNewInput = true
        case "NOT":     progVal = ~progVal
        case "<<":      progVal = progVal << 1
        case ">>":      progVal = progVal >> 1
        case "+", "−", "×", "÷", "AND", "OR", "XOR":
            progInputOp(key)
        case "=":       progEvaluate()
        default: break
        }
    }

    private func progInputDigit(_ digit: Int64) {
        if progNewInput {
            progVal = digit
            progNewInput = false
        } else {
            progVal = progVal &* progBaseMultiplier &+ digit
        }
    }

    private func progInputOp(_ op: String) {
        if progOp != nil && !progNewInput {
            progVal = progCalc(progFirst, progOp!, progVal)
        }
        progFirst = progVal
        progOp = op
        progNewInput = true
    }

    private func progEvaluate() {
        guard let op = progOp else { return }
        let second = progVal
        progVal = progCalc(progFirst, op, progVal)
        progOp = nil
        progNewInput = true
        historyStore.add(expression: "\(progFirst) \(op) \(second)", result: "\(progVal)", type: .sci)
    }

    private func progCalc(_ a: Int64, _ op: String, _ b: Int64) -> Int64 {
        switch op {
        case "+":   return a &+ b
        case "−":   return a &- b
        case "×":   return a &* b
        case "÷":   return b != 0 ? a / b : 0
        case "AND": return a & b
        case "OR":  return a | b
        case "XOR": return a ^ b
        default:    return b
        }
    }

    // MARK: - Graph View

    private var graphView: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("F(X)")
                    .font(.custom("JetBrainsMono-SemiBold", size: 11))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)

                Text(graphFunc.rawValue)
                    .font(.custom("JetBrainsMono-Medium", size: 22))
                    .foregroundStyle(T.text)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(GraphFunc.allCases) { fn in
                            Button {
                                tapCount += 1
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    graphFunc = fn
                                }
                            } label: {
                                Text(fn.rawValue)
                                    .font(.custom("JetBrainsMono-Medium", size: 12))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(fn == graphFunc ? T.accentSoft : T.surfaceAlt)
                                    .foregroundStyle(fn == graphFunc ? T.accent : T.text)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                FunctionGraphView(graphFunc: graphFunc)
                    .padding(10)
                    .background(T.surfaceAlt)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.top, 8)

                let labels = graphFunc.xLabels
                HStack {
                    Text(labels.0)
                    Spacer()
                    Text(labels.1)
                    Spacer()
                    Text(labels.2)
                }
                .font(.custom("JetBrainsMono-Medium", size: 11))
                .foregroundStyle(T.textMuted)
                .padding(.top, 2)
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

            VStack(spacing: 8) {
                HStack {
                    Text(L.graphRange).font(.custom("JetBrainsMono-Regular", size: 13)).foregroundStyle(T.textMuted)
                    Spacer()
                    Text(graphFunc.rangeStr)
                        .font(.custom("JetBrainsMono-Medium", size: 13))
                        .foregroundStyle(T.text)
                }
                HStack {
                    Text(L.graphStep).font(.custom("JetBrainsMono-Regular", size: 13)).foregroundStyle(T.textMuted)
                    Spacer()
                    Text("0.05")
                        .font(.custom("JetBrainsMono-Medium", size: 13))
                        .foregroundStyle(T.text)
                }
            }
            .padding(14)
            .background(T.surface)
            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
        }
    }
}

// MARK: - Sci Key Button

private struct SciKeyButton: View {
    @Environment(\.tokens) private var T
    let label: String
    let kind: CalcKeyKind
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("JetBrainsMono-Medium", size: 16))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(kind == .eq ? T.accent : kind == .op ? T.keyOp : kind == .fn ? T.keyFn : T.keyNum)
                .foregroundStyle(kind == .eq ? .white : kind == .op ? T.accent : T.text)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Function Graph

struct FunctionGraphView: View {
    @Environment(\.tokens) private var T
    let graphFunc: GraphFunc

    var body: some View {
        Canvas { context, size in
            let w = size.width, h = size.height
            let xRange = graphFunc.xMax - graphFunc.xMin
            let yRange = graphFunc.yMax - graphFunc.yMin

            // Y=0 axis
            let y0 = h * (1 - (0 - graphFunc.yMin) / yRange)
            if y0 >= 0 && y0 <= h {
                var hLine = Path()
                hLine.move(to: CGPoint(x: 0, y: y0))
                hLine.addLine(to: CGPoint(x: w, y: y0))
                context.stroke(hLine, with: .color(T.border),
                              style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
            }

            // X=0 axis
            let x0 = w * ((0 - graphFunc.xMin) / xRange)
            if x0 >= 0 && x0 <= w {
                var vLine = Path()
                vLine.move(to: CGPoint(x: x0, y: 0))
                vLine.addLine(to: CGPoint(x: x0, y: h))
                context.stroke(vLine, with: .color(T.border),
                              style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
            }

            // Curve
            var curve = Path()
            var started = false
            for i in stride(from: 0.0, through: w, by: 1) {
                let x = graphFunc.xMin + (i / w) * xRange
                let y = graphFunc.evaluate(x)
                guard y.isFinite else { started = false; continue }
                let py = h * (1 - (y - graphFunc.yMin) / yRange)
                guard py > -h && py < 2 * h else { started = false; continue }
                let pt = CGPoint(x: i, y: py)
                if !started { curve.move(to: pt); started = true }
                else { curve.addLine(to: pt) }
            }
            context.stroke(curve, with: .color(T.accent),
                          style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
        .frame(height: 120)
    }
}

// Keep for backward compat
struct SineGraphView: View {
    @Environment(\.tokens) private var T
    var body: some View { FunctionGraphView(graphFunc: .sine) }
}

#Preview {
    NavigationView {
        SciCalcView()
    }
    .environment(\.tokens, .light)
    .environmentObject(HistoryStore())
}
