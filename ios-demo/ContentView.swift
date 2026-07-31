import SwiftUI

private enum AppTab: String, CaseIterable {
    case today = "Today"
    case sleep = "Sleep"
    case move = "Move"
    case qibla = "Qibla"
    case coach = "Coach"

    var icon: String {
        switch self {
        case .today: return "sun.max.fill"
        case .sleep: return "moon.stars.fill"
        case .move: return "figure.run"
        case .qibla: return "location.north.fill"
        case .coach: return "sparkles"
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .today
    @State private var showProfile = false

    var body: some View {
        ZStack {
            NoorColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Header(showProfile: $showProfile)

                ScrollView(showsIndicators: false) {
                    Group {
                        switch selectedTab {
                        case .today: TodayView()
                        case .sleep: SleepView()
                        case .move: MoveView()
                        case .qibla: QiblaView()
                        case .coach: CoachView()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }

                TabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileSheet()
                .presentationDetents([.medium])
        }
    }
}

private struct Header: View {
    @Binding var showProfile: Bool

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Riyadh, Saudi Arabia")
                    .font(.caption)
                    .foregroundStyle(NoorColors.muted)
                Text("Good morning, Omar")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(NoorColors.ink)
            }

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "circle.lefthalf.filled")
                    .foregroundStyle(NoorColors.green)
                Text("8d")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NoorColors.ink)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(.white.opacity(0.78), in: Capsule())

            Button {
                showProfile = true
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 27))
                    .foregroundStyle(NoorColors.deepGreen)
            }
            .accessibilityLabel("Open profile")
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }
}

private struct TodayView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScoreHero()

            SectionTitle(title: "Today", action: "See trends")

            HStack(spacing: 12) {
                MetricCard(title: "Sleep", value: "82", suffix: "/100", icon: "moon.stars.fill", tint: NoorColors.blue)
                MetricCard(title: "Stress", value: "Low", suffix: "", icon: "waveform.path.ecg", tint: NoorColors.rose)
            }

            RingSensingCard()

            SectionTitle(title: "AI next actions", action: nil)
            ActionCard(icon: "figure.walk", title: "Choose a steady session", detail: "Your recovery is good. Keep training moderate for 35–45 minutes.", tint: NoorColors.green)
            ActionCard(icon: "bed.double.fill", title: "Protect tonight's sleep", detail: "A regular wind-down could improve your sleep consistency this week.", tint: NoorColors.gold)
        }
    }
}

private struct ScoreHero: View {
    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(NoorColors.mint, lineWidth: 12)
                Circle()
                    .trim(from: 0, to: 0.82)
                    .stroke(NoorColors.green, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: -2) {
                    Text("82")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                    Text("ready")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(NoorColors.muted)
                }
            }
            .frame(width: 124, height: 124)

            VStack(alignment: .leading, spacing: 8) {
                Text("Your body is ready")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(NoorColors.ink)
                Text("A balanced day is ahead. Keep your movement steady and give yourself an early wind-down.")
                    .font(.subheadline)
                    .foregroundStyle(NoorColors.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

private struct SleepView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PageIntro(eyebrow: "Last night", title: "Sleep that restores", subtitle: "Your sleep rhythm is becoming more consistent.")
            BigMetric(value: "7h 42m", label: "total sleep", detail: "+24 min vs your 14-day average", tint: NoorColors.blue)
            SleepStagesCard()
            TrendCard(title: "Resting heart rate", value: "54 bpm", delta: "−3 bpm", points: [0.62, 0.54, 0.58, 0.42, 0.48, 0.37, 0.32], tint: NoorColors.rose)
        }
    }
}

private struct MoveView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PageIntro(eyebrow: "Move well", title: "Train with care", subtitle: "Guidance lives in the app so your ring can stay quiet and last 7+ days.")
            BigMetric(value: "62", label: "training load", detail: "Moderate · 18 points below your weekly peak", tint: NoorColors.green)
            ActionCard(icon: "figure.run", title: "Joint care recommendation", detail: "Keep impact moderate today. Add a 6-minute warm-up before your main session to reduce knee and ankle load.", tint: NoorColors.rose)
            ActionCard(icon: "clock.arrow.circlepath", title: "Recovery window", detail: "You are ready for a 35–45 minute session. Avoid back-to-back high-intensity days.", tint: NoorColors.blue)
            ProgressCard(title: "Weekly activity", completed: 4, total: 5, tint: NoorColors.green)
        }
    }
}

private struct QiblaView: View {
    @State private var isCalibrated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PageIntro(eyebrow: "Local rhythm", title: "Qibla & prayer", subtitle: "A calm, app-side guide designed for everyday worship.")
            CompassCard(isCalibrated: $isCalibrated)
            PrayerTimesCard()
            InfoCard(icon: "iphone", title: "App-side guidance", detail: "The first version keeps the ring screen-free. Your phone handles location and direction while the ring focuses on sensing and subtle reminders.")
        }
    }
}

private struct CoachView: View {
    @State private var message = ""
    @State private var messages = ["I’m here to help you make today healthier without making it complicated."]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PageIntro(eyebrow: "Your health partner", title: "Ask Noor", subtitle: "Simple answers built from your personal baseline.")
            VStack(alignment: .leading, spacing: 12) {
                ForEach(messages, id: \.self) { item in
                    Text(item)
                        .font(.subheadline)
                        .foregroundStyle(NoorColors.ink)
                        .padding(14)
                        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .animation(.easeInOut, value: messages)

            HStack(spacing: 10) {
                TextField("Ask about sleep, training or stress", text: $message)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                Button {
                    let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    messages.append(trimmed)
                    messages.append("Based on your recent recovery, keep today moderate and protect your usual bedtime. I’ll keep learning your rhythm as you wear the ring.")
                    message = ""
                } label: {
                    Image(systemName: "arrow.up")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(NoorColors.deepGreen, in: Circle())
                }
                .accessibilityLabel("Send message")
            }
        }
    }
}

private struct TabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 16, weight: .semibold))
                        Text(tab.rawValue)
                            .font(.caption2.weight(.semibold))
                    }
                    .foregroundStyle(selectedTab == tab ? NoorColors.deepGreen : NoorColors.muted)
                    .frame(maxWidth: .infinity)
                }
                .accessibilityLabel(tab.rawValue)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(.white.opacity(0.94))
    }
}

private struct PageIntro: View {
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(eyebrow.uppercased())
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(NoorColors.gold)
            Text(title)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(NoorColors.ink)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(NoorColors.muted)
        }
        .padding(.top, 8)
    }
}

private struct SectionTitle: View {
    let title: String
    let action: String?

    var body: some View {
        HStack {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(NoorColors.ink)
            Spacer()
            if let action {
                Text(action)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NoorColors.green)
            }
        }
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    let suffix: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(tint)
            Text(title)
                .font(.caption)
                .foregroundStyle(NoorColors.muted)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                Text(suffix)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NoorColors.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct BigMetric: View {
    let value: String
    let label: String
    let detail: String
    let tint: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(value)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(tint)
                Text(label)
                    .font(.headline)
                    .foregroundStyle(NoorColors.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(NoorColors.muted)
            }
            Spacer()
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 34, weight: .medium))
                .foregroundStyle(tint.opacity(0.75))
        }
        .padding(18)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct RingSensingCard: View {
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(NoorColors.mint)
                Image(systemName: "waveform.path.ecg")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(NoorColors.green)
            }
            .frame(width: 48, height: 48)
            VStack(alignment: .leading, spacing: 4) {
                Text("Ring sensing")
                    .font(.headline)
                Text("Last synced 6 min ago · signal quality good")
                    .font(.caption)
                    .foregroundStyle(NoorColors.muted)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(NoorColors.green)
        }
        .padding(15)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct ActionCard: View {
    let icon: String
    let title: String
    let detail: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(NoorColors.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct InfoCard: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        ActionCard(icon: icon, title: title, detail: detail, tint: NoorColors.gold)
    }
}

private struct SleepStagesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Sleep stages", action: "Details")
            HStack(alignment: .bottom, spacing: 4) {
                ForEach([0.36, 0.58, 0.46, 0.72, 0.49, 0.8, 0.62, 0.7, 0.44, 0.6], id: \.self) { height in
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(LinearGradient(colors: [NoorColors.blue, NoorColors.mint], startPoint: .top, endPoint: .bottom))
                        .frame(maxWidth: .infinity)
                        .frame(height: 92 * height)
                }
            }
            HStack {
                Legend(color: NoorColors.blue, label: "Deep 1h 28m")
                Legend(color: NoorColors.mint, label: "Restful 6h 14m")
            }
        }
        .padding(16)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct Legend: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label).font(.caption).foregroundStyle(NoorColors.muted)
        }
    }
}

private struct TrendCard: View {
    let title: String
    let value: String
    let delta: String
    let points: [CGFloat]
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Text(delta).font(.caption.weight(.bold)).foregroundStyle(NoorColors.green)
            }
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value).font(.title2.bold())
                Text("last 7 nights").font(.caption).foregroundStyle(NoorColors.muted)
            }
            GeometryReader { proxy in
                Path { path in
                    for (index, point) in points.enumerated() {
                        let x = proxy.size.width * CGFloat(index) / CGFloat(points.count - 1)
                        let y = proxy.size.height * point
                        if index == 0 { path.move(to: CGPoint(x: x, y: y)) }
                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                    }
                }
                .stroke(tint, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
            .frame(height: 62)
        }
        .padding(16)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct ProgressCard: View {
    let title: String
    let completed: Int
    let total: Int
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Text("\(completed)/\(total) days").font(.caption.weight(.semibold)).foregroundStyle(NoorColors.muted)
            }
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(NoorColors.mint)
                    Capsule().fill(tint).frame(width: proxy.size.width * CGFloat(completed) / CGFloat(total))
                }
            }
            .frame(height: 9)
        }
        .padding(16)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct CompassCard: View {
    @Binding var isCalibrated: Bool

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle().stroke(NoorColors.mint, lineWidth: 18)
                Circle().stroke(NoorColors.gold.opacity(0.3), lineWidth: 1)
                VStack(spacing: 3) {
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(NoorColors.gold)
                    Text("Qibla")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(NoorColors.muted)
                }
            }
            .frame(width: 180, height: 180)
            Text(isCalibrated ? "Direction calibrated" : "Hold your phone flat to calibrate")
                .font(.headline)
            Button {
                isCalibrated.toggle()
            } label: {
                Text(isCalibrated ? "Calibrated" : "Calibrate compass")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(NoorColors.deepGreen, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct PrayerTimesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Prayer times").font(.headline)
                Spacer()
                Text("Riyadh · Today").font(.caption).foregroundStyle(NoorColors.muted)
            }
            ForEach([("Fajr", "04:12"), ("Dhuhr", "12:02"), ("Asr", "15:27"), ("Maghrib", "18:48"), ("Isha", "20:18")], id: \.0) { item in
                HStack {
                    Text(item.0).font(.subheadline.weight(.semibold))
                    Spacer()
                    Text(item.1).font(.subheadline.monospacedDigit()).foregroundStyle(NoorColors.muted)
                }
            }
        }
        .padding(16)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct ProfileSheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Omar's profile").font(.title2.bold())
            InfoCard(icon: "person.fill", title: "Personal baseline", detail: "Your scores become more personal as Noor learns your sleep, recovery and activity rhythm.")
            InfoCard(icon: "lock.shield.fill", title: "Private by design", detail: "Health insights are presented as guidance, not diagnosis. Data controls will live here in the production app.")
        }
        .padding(22)
        .background(NoorColors.background)
    }
}

private enum NoorColors {
    static let background = Color(red: 0.96, green: 0.96, blue: 0.92)
    static let ink = Color(red: 0.09, green: 0.13, blue: 0.12)
    static let muted = Color(red: 0.39, green: 0.44, blue: 0.42)
    static let deepGreen = Color(red: 0.09, green: 0.24, blue: 0.22)
    static let green = Color(red: 0.18, green: 0.49, blue: 0.38)
    static let mint = Color(red: 0.86, green: 0.94, blue: 0.90)
    static let gold = Color(red: 0.72, green: 0.52, blue: 0.20)
    static let blue = Color(red: 0.25, green: 0.42, blue: 0.51)
    static let rose = Color(red: 0.66, green: 0.36, blue: 0.32)
}
