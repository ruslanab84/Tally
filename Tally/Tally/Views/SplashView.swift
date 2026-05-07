import SwiftUI

struct SplashView: View {
    let T: TallyTokens

    @State private var phase = 0
    @State private var tickerOffset: CGFloat = 0
    @State private var symbolsVisible = false
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0
    @State private var ringRotation: Double = 0
    @State private var ringScale: CGFloat = 0.5
    @State private var tickerOpacity: Double = 0
    @State private var fadeOut: Double = 1

    private let floatingSymbols = [
        ("$", -120, -220), ("€", 100, -180), ("¥", -80, 160),
        ("₿", 130, 120), ("£", -140, 40), ("₽", 60, -100),
        ("◎", -50, -300), ("Ξ", 140, -260), ("%", -130, 260),
        ("kg", 90, 220), ("mi", -100, -80), ("°C", 50, 50),
        ("m²", -60, 280), ("₮", 120, 0), ("cm", -30, -160),
    ]

    private let tickerItems = [
        "BTC $103,420", "ETH $2,451", "USD/EUR 0.92",
        "1 mi = 1.61 km", "SOL $170.5", "°F → °C",
        "XRP $2.35", "1 oz = 28.35 g", "BNB $650",
        "ADA $0.78", "1 lb = 0.45 kg", "DOT $4.80",
    ]

    var body: some View {
        ZStack {
            T.bg.ignoresSafeArea()

            ForEach(Array(floatingSymbols.enumerated()), id: \.offset) { i, sym in
                Text(sym.0)
                    .font(.custom("JetBrainsMono-Medium", size: CGFloat.random(in: 14...22)))
                    .foregroundStyle(T.accent.opacity(symbolsVisible ? 0.15 : 0))
                    .offset(
                        x: CGFloat(sym.1) + (symbolsVisible ? 0 : CGFloat(sym.1) * 0.3),
                        y: CGFloat(sym.2) + (symbolsVisible ? 0 : CGFloat(sym.2) * 0.3)
                    )
                    .scaleEffect(symbolsVisible ? 1 : 0.3)
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.6).delay(Double(i) * 0.04),
                        value: symbolsVisible
                    )
            }

            Circle()
                .stroke(
                    AngularGradient(
                        colors: [T.accent, T.blue, T.success, T.purple, T.accent],
                        center: .center
                    ),
                    lineWidth: 3
                )
                .frame(width: 140, height: 140)
                .scaleEffect(ringScale)
                .rotationEffect(.degrees(ringRotation))
                .opacity(phase >= 1 ? 0.6 : 0)

            Circle()
                .stroke(T.accent.opacity(0.15), lineWidth: 1)
                .frame(width: 180, height: 180)
                .scaleEffect(ringScale)
                .opacity(phase >= 1 ? 0.4 : 0)

            VStack(spacing: 8) {
                Text("Tally")
                    .font(.custom("JetBrainsMono-SemiBold", size: 42))
                    .tracking(-1)
                    .foregroundStyle(T.text)

                HStack(spacing: 6) {
                    ForEach(["$", "↔", "₿"], id: \.self) { s in
                        Text(s)
                            .font(.custom("JetBrainsMono-Medium", size: 16))
                            .foregroundStyle(T.accent)
                    }
                }
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)

            VStack {
                Spacer()
                tickerView
                    .opacity(tickerOpacity)
                    .padding(.bottom, 80)
            }
        }
        .opacity(fadeOut)
        .onAppear { startAnimation() }
    }

    private var tickerView: some View {
        GeometryReader { geo in
            let w = geo.size.width
            HStack(spacing: 30) {
                ForEach(0..<3, id: \.self) { batch in
                    ForEach(tickerItems, id: \.self) { item in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(T.success)
                                .frame(width: 5, height: 5)
                            Text(item)
                                .font(.custom("JetBrainsMono-Medium", size: 12))
                                .foregroundStyle(T.textMuted)
                        }
                    }
                }
            }
            .offset(x: tickerOffset)
            .onAppear {
                let totalWidth = CGFloat(tickerItems.count * 3) * 150
                tickerOffset = 0
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    tickerOffset = -totalWidth / 3
                }
            }
            .frame(width: w, alignment: .leading)
            .clipped()
        }
        .frame(height: 20)
    }

    private func startAnimation() {
        withAnimation(.easeOut(duration: 0.6)) {
            symbolsVisible = true
            logoScale = 1.0
            logoOpacity = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            phase = 1
            withAnimation(.easeOut(duration: 0.5)) {
                ringScale = 1.0
            }
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                ringRotation = 360
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeIn(duration: 0.4)) {
                tickerOpacity = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                fadeOut = 0
            }
        }
    }
}

#Preview {
    SplashView(T: .dark)
}
