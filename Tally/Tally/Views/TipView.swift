import SwiftUI

struct TipView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @State private var billText = ""
    @State private var tipPercent = 18
    @State private var people = 2
    @FocusState private var billFocused: Bool

    private let tipOptions = [10, 15, 18, 20, 25]

    private var bill: Double { Double(billText) ?? 0 }
    private var tip: Double { bill * Double(tipPercent) / 100 }
    private var total: Double { bill + tip }
    private var perPerson: Double { people > 0 ? total / Double(people) : 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Bill amount
                VStack(spacing: 6) {
                    Text(L.billAmount)
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
                        .tracking(0.6)
                        .foregroundStyle(T.textMuted)

                    HStack(alignment: .bottom, spacing: 4) {
                        Text("$")
                            .font(.custom("JetBrainsMono-Medium", size: 36))
                            .foregroundStyle(T.textMuted)

                        TextField("0.00", text: $billText)
                            .font(.custom("JetBrainsMono-Medium", size: 56))
                            .fontWeight(.medium)
                            .tracking(-1.5)
                            .foregroundStyle(T.text)
                            .keyboardType(.decimalPad)
                            .focused($billFocused)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(22)
                .frame(maxWidth: .infinity)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
                .onTapGesture { billFocused = true }

                // Tip percentage
                VStack(spacing: 12) {
                    HStack {
                        Text(L.tip).font(.custom("JetBrainsMono-Regular", size: 13)).foregroundStyle(T.textMuted)
                        Spacer()
                        Text("\(tipPercent)%")
                            .font(.custom("JetBrainsMono-SemiBold", size: 22))
                            .foregroundStyle(T.accent)
                    }

                    HStack(spacing: 6) {
                        ForEach(tipOptions, id: \.self) { pct in
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    tipPercent = pct
                                }
                            } label: {
                                Text("\(pct)%")
                                    .font(.custom("JetBrainsMono-SemiBold", size: 13))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(pct == tipPercent ? T.accent : .clear)
                                    .foregroundStyle(pct == tipPercent ? .white : T.text)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(pct == tipPercent ? T.accent : T.border, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Slider(
                        value: Binding(
                            get: { Double(tipPercent) },
                            set: { tipPercent = Int($0) }
                        ),
                        in: 0...50,
                        step: 1
                    )
                    .tint(T.accent)
                }
                .padding(16)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Split
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L.splitBetween)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .foregroundStyle(T.textMuted)
                        Text("\(people) \(L.people)")
                            .font(.custom("JetBrainsMono-SemiBold", size: 16))
                            .foregroundStyle(T.text)
                    }
                    Spacer()
                    HStack(spacing: 12) {
                        Button {
                            if people > 1 { people -= 1 }
                        } label: {
                            Text("−")
                                .font(.custom("JetBrainsMono-Regular", size: 18))
                                .frame(width: 32, height: 32)
                                .background(T.surfaceAlt)
                                .foregroundStyle(T.text)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)

                        Text("\(people)")
                            .font(.custom("JetBrainsMono-SemiBold", size: 22))
                            .foregroundStyle(T.text)
                            .frame(minWidth: 24)

                        Button {
                            if people < 50 { people += 1 }
                        } label: {
                            Text("+")
                                .font(.custom("JetBrainsMono-Regular", size: 18))
                                .frame(width: 32, height: 32)
                                .background(T.accent)
                                .foregroundStyle(.white)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Result card
                VStack(spacing: 0) {
                    HStack {
                        Text(L.tip).font(.custom("JetBrainsMono-Regular", size: 13))
                        Spacer()
                        Text(String(format: "$%.2f", tip))
                            .font(.custom("JetBrainsMono-Medium", size: 13))
                    }
                    .opacity(0.85)
                    .padding(.bottom, 6)

                    HStack {
                        Text(L.total).font(.custom("JetBrainsMono-Regular", size: 13))
                        Spacer()
                        Text(String(format: "$%.2f", total))
                            .font(.custom("JetBrainsMono-Medium", size: 13))
                    }
                    .opacity(0.85)
                    .padding(.bottom, 12)

                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(height: 1)

                    HStack(alignment: .bottom) {
                        Text(L.eachPays)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .opacity(0.85)
                        Spacer()
                        Text(String(format: "$%.2f", perPerson))
                            .font(.custom("JetBrainsMono-SemiBold", size: 32))
                    }
                    .padding(.top, 12)
                }
                .foregroundStyle(.white)
                .padding(18)
                .background(T.accent)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background { TallyBackground(T: T, icons: [
            "fork.knife", "percent", "person.2",
            "dollarsign", "cart", "cup.and.saucer",
            "gift", "star",
        ]) }
        .navigationTitle(L.navTip)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(L.done) { billFocused = false }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TipView()
    }
    .environment(\.tokens, .light)
}
