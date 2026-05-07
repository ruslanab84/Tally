import SwiftUI

struct CurrencyView: View {
    @Environment(\.tokens) private var T
    @State private var amountText = "100"
    @State private var fromCurrency = Currency.all[0]
    @State private var toCurrency = Currency.all[1]
    @State private var showFromPicker = false
    @State private var showToPicker = false
    @State private var service = CurrencyService()
    @FocusState private var amountFocused: Bool

    private var amount: Double { Double(amountText) ?? 0 }
    private var fromRate: Double { service.rateFor(fromCurrency.code) }
    private var toRate: Double { service.rateFor(toCurrency.code) }
    private var result: Double { amount / fromRate * toRate }
    private var rateString: String { String(format: "%.4f", toRate / fromRate) }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Conversion card
                VStack(spacing: 0) {
                    // From
                    HStack(alignment: .bottom) {
                        Button { showFromPicker = true } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("FROM")
                                    .font(.system(size: 11, weight: .semibold))
                                    .tracking(0.6)
                                    .foregroundStyle(T.textMuted)

                                HStack(spacing: 8) {
                                    Text(fromCurrency.flag).font(.system(size: 22))
                                    Text(fromCurrency.code)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(T.text)
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 10))
                                        .foregroundStyle(T.textMuted)
                                }
                            }
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        TextField("0", text: $amountText)
                            .font(.custom("JetBrainsMono-Medium", size: 38))
                            .tracking(-1)
                            .foregroundStyle(T.text)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .focused($amountFocused)
                            .frame(maxWidth: 200)
                    }

                    // Swap
                    HStack(spacing: 12) {
                        VStack { Divider() }

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                let temp = fromCurrency
                                fromCurrency = toCurrency
                                toCurrency = temp
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(T.accent)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)

                        VStack { Divider() }
                    }
                    .padding(.vertical, 10)

                    // To
                    HStack(alignment: .bottom) {
                        Button { showToPicker = true } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("TO")
                                    .font(.system(size: 11, weight: .semibold))
                                    .tracking(0.6)
                                    .foregroundStyle(T.textMuted)

                                HStack(spacing: 8) {
                                    Text(toCurrency.flag).font(.system(size: 22))
                                    Text(toCurrency.code)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(T.text)
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 10))
                                        .foregroundStyle(T.textMuted)
                                }
                            }
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Text(String(format: "%.2f", result))
                            .font(.custom("JetBrainsMono-Medium", size: 38))
                            .fontWeight(.medium)
                            .tracking(-1)
                            .foregroundStyle(T.accent)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }

                    // Rate + status
                    HStack(spacing: 6) {
                        Text("1 \(fromCurrency.code) = \(rateString) \(toCurrency.code)")
                            .font(.custom("JetBrainsMono-Medium", size: 11))
                            .foregroundStyle(T.textMuted)

                        Spacer()

                        if service.isLoading {
                            ProgressView()
                                .scaleEffect(0.5)
                                .frame(width: 12, height: 12)
                        } else {
                            Image(systemName: service.isOffline ? "wifi.slash" : "wifi")
                                .font(.system(size: 9))
                                .foregroundStyle(service.isOffline ? T.red : T.success)
                        }

                        Text(service.lastUpdatedText)
                            .font(.system(size: 10))
                            .foregroundStyle(T.textMuted)
                    }
                    .padding(.top, 12)
                }
                .padding(18)
                .background(T.surface)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.xl))

                // Popular currencies
                Text("POPULAR")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.6)
                    .foregroundStyle(T.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                VStack(spacing: 6) {
                    ForEach(Currency.popular) { currency in
                        Button {
                            toCurrency = currency
                        } label: {
                            HStack(spacing: 12) {
                                Text(currency.flag)
                                    .font(.system(size: 20))
                                    .frame(width: 36, height: 36)
                                    .background(T.surfaceAlt)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(currency.code)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(T.text)
                                    Text(currency.name)
                                        .font(.system(size: 12))
                                        .foregroundStyle(T.textMuted)
                                }

                                Spacer()

                                Text(String(format: "%.2f", amount / fromRate * service.rateFor(currency.code)))
                                    .font(.custom("JetBrainsMono-Medium", size: 18))
                                    .foregroundStyle(currency == toCurrency ? T.accent : T.text)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(currency == toCurrency ? T.accentSoft : T.surface)
                            .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
                        }
                        .buttonStyle(.plain)
                    }
                }

                // All currencies button
                Button { showToPicker = true } label: {
                    HStack {
                        Text("All 32 currencies")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(T.accent)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundStyle(T.accent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(T.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(T.bg)
        .navigationTitle("Currency")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { amountFocused = false }
            }
        }
        .task { await service.fetchRates() }
        .sheet(isPresented: $showFromPicker) {
            CurrencyPickerSheet(selected: $fromCurrency, amount: amount, fromRate: fromRate, service: service)
                .environment(\.tokens, T)
        }
        .sheet(isPresented: $showToPicker) {
            CurrencyPickerSheet(selected: $toCurrency, amount: amount, fromRate: fromRate, service: service)
                .environment(\.tokens, T)
        }
    }
}

// MARK: - Currency Picker

private struct CurrencyPickerSheet: View {
    @Environment(\.tokens) private var T
    @Environment(\.dismiss) private var dismiss
    @Binding var selected: Currency
    let amount: Double
    let fromRate: Double
    let service: CurrencyService
    @State private var search = ""

    private var filtered: [Currency] {
        if search.isEmpty { return Currency.all }
        return Currency.all.filter {
            $0.code.localizedCaseInsensitiveContains(search) ||
            $0.name.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(filtered.enumerated()), id: \.element.id) { index, currency in
                        Button {
                            selected = currency
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                Text(currency.flag)
                                    .font(.system(size: 22))
                                    .frame(width: 36, height: 36)
                                    .background(T.surfaceAlt)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(currency.code)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(T.text)
                                    Text(currency.name)
                                        .font(.system(size: 12))
                                        .foregroundStyle(T.textMuted)
                                }

                                Spacer()

                                if amount > 0 {
                                    Text(String(format: "%.2f", amount / fromRate * service.rateFor(currency.code)))
                                        .font(.custom("JetBrainsMono-Medium", size: 15))
                                        .foregroundStyle(currency == selected ? T.accent : T.textMuted)
                                }

                                if currency == selected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundStyle(T.accent)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(currency == selected ? T.accentSoft : T.surface)
                        }
                        .buttonStyle(.plain)

                        if index < filtered.count - 1 {
                            Divider().padding(.leading, 64)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .background(T.bg)
            .searchable(text: $search, prompt: "Search currencies")
            .navigationTitle("Select Currency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    NavigationStack {
        CurrencyView()
    }
    .environment(\.tokens, .light)
}
