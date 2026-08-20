import SwiftUI

private enum AppTab: String, CaseIterable {
    case today = "首页"
    case core = "健康"
    case community = "社区"
    case health = "我的健康"
    var icon: String {
        switch self { case .today: return "house"; case .core: return "heart.text.square"; case .community: return "person.3"; case .health: return "tree" }
    }
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .today
    @State private var showDeviceStatus = false
    @State private var showQuickActions = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NoorColors.background.ignoresSafeArea()
            VStack(spacing: 0) {
                TopBar(showDeviceStatus: $showDeviceStatus)
                ScrollView(showsIndicators: false) {
                    Group { switch selectedTab { case .today: TodayView(); case .core: CoreDataView(); case .community: CommunityView(); case .health: HealthView() } }
                        .padding(.horizontal, 18).padding(.bottom, 130)
                }
            }
            HStack(alignment: .bottom, spacing: 12) {
                FloatingTabBar(selectedTab: $selectedTab)
                Button { showQuickActions = true } label: {
                    Image(systemName: "plus").font(.system(size: 26, weight: .light)).foregroundStyle(NoorColors.cream)
                        .frame(width: 66, height: 66).background(Circle().fill(NoorColors.floating)).overlay(Circle().stroke(NoorColors.line, lineWidth: 1))
                }.buttonStyle(.plain)
            }.padding(.horizontal, 18).padding(.bottom, 16)
        }
        .sheet(isPresented: $showDeviceStatus) { DeviceStatusSheet() }
        .sheet(isPresented: $showQuickActions) { QuickActionsSheet() }
        .preferredColorScheme(.dark)
    }
}

private struct TopBar: View {
    @Binding var showDeviceStatus: Bool
    var body: some View {
        HStack {
            Button {} label: { Image(systemName: "line.3.horizontal").font(.system(size: 25, weight: .light)) }.buttonStyle(.plain)
            Spacer(); Text("NOOR").font(.system(size: 29, weight: .ultraLight, design: .rounded)).tracking(2); Spacer()
            Button { showDeviceStatus = true } label: {
                HStack(spacing: 5) {
                    Image(systemName: "bolt.fill").font(.system(size: 12, weight: .bold))
                    Text("74%").font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                .padding(.horizontal, 9).padding(.vertical, 6)
                .foregroundStyle(NoorColors.cream)
                .background(Capsule().fill(NoorColors.batteryGreen))
            }.buttonStyle(.plain)
        }.foregroundStyle(NoorColors.cream).padding(.horizontal, 20).padding(.top, 10).padding(.bottom, 18)
    }
}

private struct TodayView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) { Text("今天").font(.system(size: 32)); Text("周三 · 19 八月").font(.system(size: 14)).foregroundStyle(NoorColors.muted) }
                Spacer(); Label("利雅得", systemImage: "location.fill").font(.system(size: 13)).foregroundStyle(NoorColors.muted)
            }
            MetricsStrip(); ReadinessHero(); AlarmCard(); QiblaCompassCard(); SectionTitle(title: "今日洞察", action: "查看全部")
            HStack(spacing: 12) {
                InsightCard(title: "压力管理", value: "平稳", detail: "过去 3 小时", icon: "water.waves", colors: NoorColors.tealGradient)
                InsightCard(title: "心率", value: "68 bpm", detail: "静息趋势正常", icon: "heart", colors: NoorColors.blueGradient)
            }
            TimelineCard(); SectionTitle(title: "为你推荐", action: nil); RecommendationCard()
        }
    }
}

private struct AlarmCard: View {
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("智能闹钟").font(.system(size: 18, weight: .medium))
                    Text("推荐起床时间").font(.system(size: 13)).foregroundStyle(NoorColors.muted)
                }
                Spacer()
                Label("ALARM ON", systemImage: "circle.fill").font(.system(size: 13, weight: .semibold)).foregroundStyle(NoorColors.gold)
            }
            HStack(alignment: .firstTextBaseline) {
                Text("06:40").font(.system(size: 42, weight: .light, design: .rounded))
                Text("明天").font(.system(size: 15)).foregroundStyle(NoorColors.muted)
                Spacer()
                Image(systemName: "pencil").font(.system(size: 19, weight: .light)).foregroundStyle(NoorColors.gold)
            }
            Text("在 06:25–06:40 的轻睡眠窗口内，用戒指的无声震动唤醒你。")
                .font(.system(size: 14)).foregroundStyle(NoorColors.muted)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(LinearGradient(colors: NoorColors.goldGradient, startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

private struct QiblaCompassCard: View {
    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle().stroke(NoorColors.gold.opacity(0.28), lineWidth: 1)
                Circle().stroke(NoorColors.gold.opacity(0.65), style: StrokeStyle(lineWidth: 3, dash: [2, 8]))
                Image(systemName: "location.north.fill").font(.system(size: 26, weight: .light)).foregroundStyle(NoorColors.gold).offset(y: -12)
                Image(systemName: "building.columns.fill").font(.system(size: 14)).foregroundStyle(NoorColors.cream)
            }.frame(width: 94, height: 94)
            VStack(alignment: .leading, spacing: 7) {
                HStack { Text("Qibla 指南针").font(.system(size: 18, weight: .medium)); Spacer(); Image(systemName: "chevron.right").foregroundStyle(NoorColors.muted) }
                Text("293° · 西北").font(.system(size: 24, weight: .light, design: .rounded)).foregroundStyle(NoorColors.gold)
                Text("距离麦加方向约 4°，可以开始校准。").font(.system(size: 13)).foregroundStyle(NoorColors.muted)
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 24).fill(NoorColors.panel))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(NoorColors.gold.opacity(0.25), lineWidth: 1))
    }
}

private struct MetricsStrip: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ScoreOrb(title: "恢复力", value: "—", icon: "water.waves", tint: NoorColors.gold.opacity(0.76))
                ScoreOrb(title: "准备度", value: "82", icon: "leaf", tint: NoorColors.gold)
                ScoreOrb(title: "睡眠", value: "81", icon: "moon", tint: NoorColors.cream.opacity(0.86))
                ScoreOrb(title: "活动", value: "52", icon: "flame", tint: NoorColors.mint)
            }.padding(.vertical, 3)
        }
    }
}

private struct ScoreOrb: View {
    let title: String; let value: String; let icon: String; let tint: Color
    var body: some View {
        VStack(spacing: 10) {
            ZStack { Circle().fill(tint.opacity(0.12)); Circle().stroke(tint.opacity(0.28), lineWidth: 1); VStack(spacing: 3) { Image(systemName: icon).font(.system(size: 21, weight: .light)); Text(value).font(.system(size: 25, weight: .light, design: .rounded)) } }
                .frame(width: 92, height: 92)
            Text(title).font(.system(size: 15)).foregroundStyle(NoorColors.cream)
        }.foregroundStyle(tint).frame(width: 98)
    }
}

private struct ReadinessHero: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 30).fill(LinearGradient(colors: NoorColors.greenGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            WaveLines(color: NoorColors.mint.opacity(0.28)).clipShape(RoundedRectangle(cornerRadius: 30))
            VStack(alignment: .leading, spacing: 12) {
                HStack { Label("准备度", systemImage: "leaf").font(.system(size: 17, weight: .medium)); Spacer(); Image(systemName: "chevron.right") }.foregroundStyle(NoorColors.cream)
                Text("82").font(.system(size: 82, weight: .ultraLight, design: .rounded)).foregroundStyle(NoorColors.cream)
                Text("活动平衡").font(.system(size: 30, weight: .light))
                Text("你的身体状态良好，今天适合保持稳定的活动节奏。").font(.system(size: 16)).foregroundStyle(NoorColors.cream.opacity(0.86)).fixedSize(horizontal: false, vertical: true)
                Button("了解更多") {}.font(.system(size: 15, weight: .medium)).foregroundStyle(NoorColors.cream).padding(.horizontal, 18).padding(.vertical, 10).background(Capsule().fill(Color.white.opacity(0.12)))
            }.padding(24)
        }.frame(minHeight: 330)
    }
}

private struct InsightCard: View {
    let title: String; let value: String; let detail: String; let icon: String; let colors: [Color]
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack { Image(systemName: icon); Spacer(); Image(systemName: "chevron.right").font(.system(size: 15, weight: .light)) }.foregroundStyle(NoorColors.cream.opacity(0.82))
            Text(title).font(.system(size: 19, weight: .medium)); Text(value).font(.system(size: 28, weight: .light)).foregroundStyle(NoorColors.cream); Text(detail).font(.system(size: 13)).foregroundStyle(NoorColors.muted)
        }.padding(18).frame(maxWidth: .infinity, minHeight: 165, alignment: .leading).background(RoundedRectangle(cornerRadius: 24).fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

private struct TimelineCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionTitle(title: "时间轴", action: "添加")
            HStack(alignment: .top, spacing: 14) {
                VStack(spacing: 0) { Circle().fill(NoorColors.mint).frame(width: 12, height: 12); Rectangle().fill(NoorColors.line).frame(width: 1, height: 64) }
                VStack(alignment: .leading, spacing: 6) { Text("08:18").font(.system(size: 14)).foregroundStyle(NoorColors.muted); Text("醒来").font(.system(size: 20, weight: .medium)); Text("睡眠 6小时56分钟   准备度 82   睡眠 81").font(.system(size: 13)).foregroundStyle(NoorColors.muted) }
                Spacer(); Image(systemName: "chevron.right").foregroundStyle(NoorColors.muted)
            }
        }.padding(20).background(RoundedRectangle(cornerRadius: 24).fill(NoorColors.panel))
    }
}

private struct RecommendationCard: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "figure.walk").font(.system(size: 26, weight: .light)).foregroundStyle(NoorColors.mint).frame(width: 54, height: 54).background(Circle().fill(NoorColors.mint.opacity(0.12)))
            VStack(alignment: .leading, spacing: 5) { Text("稳步提升").font(.system(size: 18, weight: .medium)); Text("今天进行 20 分钟轻度活动，帮助维持恢复平衡。").font(.system(size: 14)).foregroundStyle(NoorColors.muted) }
            Spacer()
        }.padding(18).background(RoundedRectangle(cornerRadius: 22).fill(NoorColors.panel))
    }
}

private struct CoreDataView: View {
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PageHeading(title: "健康核心数据", subtitle: "长期趋势会比单日波动更有意义")
            SectionTitle(title: "准备度", action: "编辑")
            LazyVGrid(columns: columns, spacing: 12) {
                DataTile(title: "准备度评分", value: "82", status: "良好", icon: "leaf", tint: .mint)
                DataTile(title: "症状探测功能", value: "无异常体征", status: "", icon: "waveform.path.ecg", tint: .cyan)
                DataTile(title: "睡眠分数", value: "81", status: "良好", icon: "moon", tint: .teal)
                DataTile(title: "生物钟", value: "需要更多数据", status: "约需 90 天", icon: "clock", tint: .orange)
                DataTile(title: "睡眠规律", value: "稳定", status: "", icon: "chart.xyaxis.line", tint: .mint)
                DataTile(title: "睡眠负债", value: "无", status: "", icon: "bed.double", tint: .blue)
            }
            SectionTitle(title: "恢复趋势", action: "过去 30 天"); TrendCard()
        }
    }
}

private struct DataTile: View {
    let title: String; let value: String; let status: String; let icon: String; let tint: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { Text(title).font(.system(size: 16)).foregroundStyle(NoorColors.muted); Spacer(); Image(systemName: "chevron.right").font(.system(size: 13, weight: .light)).foregroundStyle(NoorColors.muted) }
            Spacer(minLength: 18); Image(systemName: icon).font(.system(size: 25, weight: .light)).foregroundStyle(tint); Text(value).font(.system(size: 25, weight: .light)).foregroundStyle(NoorColors.cream)
            if !status.isEmpty { Text(status).font(.system(size: 14)).foregroundStyle(tint) }
        }.padding(18).frame(maxWidth: .infinity, minHeight: 190, alignment: .leading).background(RoundedRectangle(cornerRadius: 24).fill(tint.opacity(0.07))).overlay(RoundedRectangle(cornerRadius: 24).stroke(NoorColors.line.opacity(0.35), lineWidth: 1))
    }
}

private struct TrendCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack { Text("个人基线").font(.system(size: 18, weight: .medium)); Spacer(); Text("+6%").foregroundStyle(NoorColors.mint) }
            TrendChart(); Text("你的恢复力正在逐步提升，保持当前睡眠和活动节奏。").font(.system(size: 14)).foregroundStyle(NoorColors.muted)
        }.padding(20).background(RoundedRectangle(cornerRadius: 24).fill(NoorColors.panel))
    }
}

private struct TrendChart: View {
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let points: [CGFloat] = [0.65, 0.52, 0.58, 0.42, 0.48, 0.28, 0.36, 0.22, 0.3, 0.16]
                path.move(to: CGPoint(x: 0, y: proxy.size.height * points[0]))
                for (index, value) in points.dropFirst().enumerated() { path.addLine(to: CGPoint(x: proxy.size.width * CGFloat(index + 1) / CGFloat(points.count - 1), y: proxy.size.height * value)) }
            }.stroke(NoorColors.mint, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }.frame(height: 95)
    }
}

private struct CommunityView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PageHeading(title: "社区", subtitle: "和拥有相似目标的人一起坚持")
            HStack(spacing: 12) {
                CommunityPromo(icon: "person.3.fill", title: "创建家庭计划", detail: "与 2–6 位成员共享健康目标", colors: NoorColors.goldGradient)
                CommunityPromo(icon: "person.crop.circle.badge.plus", title: "邀请朋友", detail: "一起完成 7 天睡眠挑战", colors: NoorColors.copperGradient)
            }
            SectionTitle(title: "我的小组", action: "查看全部")
            CommunityRow(icon: "moon.stars", title: "Ramadan Sleep Circle", detail: "24 位成员 · 连续 6 天", value: "78%")
            CommunityRow(icon: "figure.walk", title: "Riyadh Morning Walk", detail: "今天 06:30 · 轻度活动", value: "12 人")
            SectionTitle(title: "推荐社区", action: "全部")
            HStack(spacing: 12) {
                CommunityTile(title: "Saudi Wellness", members: "4,527 位成员", icon: "sun.max.fill")
                CommunityTile(title: "Men 30–40", members: "23,622 位成员", icon: "person.2.fill")
            }
        }
    }
}

private struct CommunityPromo: View {
    let icon: String; let title: String; let detail: String; let colors: [Color]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon).font(.system(size: 23, weight: .light)).foregroundStyle(NoorColors.ink)
            Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(NoorColors.ink)
            Text(detail).font(.system(size: 12)).foregroundStyle(NoorColors.ink.opacity(0.72))
        }.padding(16).frame(maxWidth: .infinity, minHeight: 150, alignment: .leading).background(RoundedRectangle(cornerRadius: 22).fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

private struct CommunityRow: View {
    let icon: String; let title: String; let detail: String; let value: String
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon).font(.system(size: 21, weight: .light)).foregroundStyle(NoorColors.gold).frame(width: 48, height: 48).background(Circle().fill(NoorColors.gold.opacity(0.12)))
            VStack(alignment: .leading, spacing: 5) { Text(title).font(.system(size: 17, weight: .medium)); Text(detail).font(.system(size: 13)).foregroundStyle(NoorColors.muted) }
            Spacer(); Text(value).font(.system(size: 16, weight: .medium)).foregroundStyle(NoorColors.gold); Image(systemName: "chevron.right").foregroundStyle(NoorColors.muted)
        }.padding(17).background(RoundedRectangle(cornerRadius: 22).fill(NoorColors.panel))
    }
}

private struct CommunityTile: View {
    let title: String; let members: String; let icon: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon).font(.system(size: 26, weight: .light)).foregroundStyle(NoorColors.gold)
            Spacer(); Text(title).font(.system(size: 18, weight: .medium)); Text(members).font(.system(size: 13)).foregroundStyle(NoorColors.muted)
        }.padding(18).frame(maxWidth: .infinity, minHeight: 155, alignment: .leading).background(RoundedRectangle(cornerRadius: 22).fill(NoorColors.panel)).overlay(RoundedRectangle(cornerRadius: 22).stroke(NoorColors.gold.opacity(0.18), lineWidth: 1))
    }
}

private struct HealthView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PageHeading(title: "我的健康", subtitle: "用小调整，长期管理你的生活方式"); HealthOverview(); SectionTitle(title: "健康状态", action: nil)
            HealthStatusCard(title: "睡眠健康", status: "状态良好", detail: "正常睡眠分数：81", icon: "moon", colors: NoorColors.greenGradient)
            HealthStatusCard(title: "压力管理", status: "正在校准", detail: "建立个人压力基线中", icon: "water.waves", colors: NoorColors.purpleGradient)
            HealthStatusCard(title: "心脏健康", status: "正在校准", detail: "持续佩戴后将提供更多趋势", icon: "heart", colors: NoorColors.blueGradient)
            SectionTitle(title: "中东生活方式", action: nil); LifestyleCard()
        }
    }
}

private struct HealthOverview: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 28).fill(LinearGradient(colors: NoorColors.oceanGradient, startPoint: .topLeading, endPoint: .bottomTrailing)); WaveLines(color: Color.white.opacity(0.22)).clipShape(RoundedRectangle(cornerRadius: 28))
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) { Text("长期健康趋势").font(.system(size: 17, weight: .medium)); Text("健康是一场马拉松").font(.system(size: 30, weight: .light)); Text("通过小调整来提升睡眠质量、保持恢复平衡和稳定活动量。").font(.system(size: 14)).foregroundStyle(NoorColors.cream.opacity(0.82)) }
                Spacer(); Image(systemName: "sparkles").font(.system(size: 35, weight: .ultraLight)).foregroundStyle(NoorColors.cream)
            }.padding(22)
        }.frame(minHeight: 205)
    }
}

private struct HealthStatusCard: View {
    let title: String; let status: String; let detail: String; let icon: String; let colors: [Color]
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon).font(.system(size: 25, weight: .light)).frame(width: 56, height: 56).background(Circle().fill(Color.white.opacity(0.1)))
            VStack(alignment: .leading, spacing: 5) { Text(title).font(.system(size: 19, weight: .medium)); Text(status).font(.system(size: 17)).foregroundStyle(NoorColors.mint); Text(detail).font(.system(size: 14)).foregroundStyle(NoorColors.muted) }
            Spacer(); Image(systemName: "chevron.right").font(.system(size: 18, weight: .light))
        }.padding(18).foregroundStyle(NoorColors.cream).background(RoundedRectangle(cornerRadius: 24).fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

private struct LifestyleCard: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "location.north.line").font(.system(size: 25, weight: .light)).foregroundStyle(NoorColors.gold).frame(width: 54, height: 54).background(Circle().fill(NoorColors.gold.opacity(0.12)))
            VStack(alignment: .leading, spacing: 6) { Text("Qibla 与祷告提醒").font(.system(size: 18, weight: .medium)); Text("在 App 中获取方向、礼拜时间和斋月健康建议").font(.system(size: 14)).foregroundStyle(NoorColors.muted) }
            Spacer(); Image(systemName: "chevron.right").foregroundStyle(NoorColors.muted)
        }.padding(18).background(RoundedRectangle(cornerRadius: 22).fill(NoorColors.panel))
    }
}

private struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab } } label: {
                    VStack(spacing: 6) { Image(systemName: tab.icon).font(.system(size: 21, weight: .light)); Text(tab.rawValue).font(.system(size: 12)) }
                        .foregroundStyle(selectedTab == tab ? NoorColors.cream : NoorColors.muted).frame(maxWidth: .infinity)
                }.buttonStyle(.plain)
            }
        }.padding(.vertical, 12).frame(maxWidth: .infinity).background(Capsule().fill(NoorColors.floating)).overlay(Capsule().stroke(NoorColors.line, lineWidth: 1))
    }
}

private struct PageHeading: View {
    let title: String; let subtitle: String
    var body: some View { VStack(alignment: .leading, spacing: 7) { Text(title).font(.system(size: 31, weight: .light)); Text(subtitle).font(.system(size: 15)).foregroundStyle(NoorColors.muted) }.padding(.top, 5) }
}

private struct SectionTitle: View {
    let title: String; let action: String?
    var body: some View { HStack(alignment: .firstTextBaseline) { Text(title).font(.system(size: 24, weight: .light)); Spacer(); if let action { Text(action).font(.system(size: 13)).foregroundStyle(NoorColors.muted) } } }
}

private struct WaveLines: View {
    let color: Color
    var body: some View {
        GeometryReader { _ in Canvas { context, size in
            for index in 0..<4 { var path = Path(); let y = size.height * (0.26 + CGFloat(index) * 0.2); path.move(to: CGPoint(x: -20, y: y)); path.addCurve(to: CGPoint(x: size.width + 20, y: y + 18), control1: CGPoint(x: size.width * 0.26, y: y - 55), control2: CGPoint(x: size.width * 0.67, y: y + 55)); context.stroke(path, with: .color(color), lineWidth: 2) }
        } }.allowsHitTesting(false)
    }
}

private struct DeviceStatusSheet: View {
    var body: some View {
        NavigationStack { List {
            Label("已连接 NOOR Ring", systemImage: "circle.hexagongrid.circle")
            Label("剩余电量 74% · 约 8 天", systemImage: "battery.75percent")
            Label("建议今晚充电", systemImage: "bolt.fill")
            Label("英语 / العربية", systemImage: "globe")
        }.navigationTitle("戒指状态") }.preferredColorScheme(.dark)
    }
}

private struct QuickActionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack { VStack(spacing: 16) { QuickActionRow(icon: "location.north.line", title: "Qibla 方向", detail: "打开手机端方向指引"); QuickActionRow(icon: "sparkles", title: "AI 健康伙伴", detail: "询问今天的恢复与训练建议"); QuickActionRow(icon: "moon.stars", title: "斋月模式", detail: "调整睡眠、饮水和活动节奏"); Spacer() }.padding(20).navigationTitle("快速操作").toolbar { ToolbarItem(placement: .topBarTrailing) { Button("完成") { dismiss() } } } }.preferredColorScheme(.dark)
    }
}

private struct QuickActionRow: View {
    let icon: String; let title: String; let detail: String
    var body: some View { HStack(spacing: 16) { Image(systemName: icon).font(.system(size: 22, weight: .light)).foregroundStyle(NoorColors.mint).frame(width: 45, height: 45).background(Circle().fill(NoorColors.mint.opacity(0.12))); VStack(alignment: .leading, spacing: 5) { Text(title).font(.system(size: 18, weight: .medium)); Text(detail).font(.system(size: 14)).foregroundStyle(NoorColors.muted) }; Spacer(); Image(systemName: "chevron.right").foregroundStyle(NoorColors.muted) }.padding(16).background(RoundedRectangle(cornerRadius: 20).fill(NoorColors.panel)) }
}

private enum NoorColors {
    static let background = Color(red: 0.055, green: 0.06, blue: 0.07); static let panel = Color(red: 0.115, green: 0.125, blue: 0.14); static let floating = Color(red: 0.16, green: 0.16, blue: 0.18)
    static let cream = Color(red: 0.98, green: 0.93, blue: 0.82); static let ink = Color(red: 0.10, green: 0.08, blue: 0.05); static let muted = Color(red: 0.64, green: 0.61, blue: 0.56); static let line = Color.white.opacity(0.14); static let mint = Color(red: 0.92, green: 0.68, blue: 0.26); static let gold = Color(red: 0.96, green: 0.70, blue: 0.25); static let batteryGreen = Color(red: 0.10, green: 0.64, blue: 0.30)
    static let greenGradient = [Color(red: 0.17, green: 0.13, blue: 0.07), Color(red: 0.40, green: 0.27, blue: 0.10)]; static let tealGradient = [Color(red: 0.14, green: 0.12, blue: 0.07), Color(red: 0.37, green: 0.25, blue: 0.09)]; static let blueGradient = [Color(red: 0.11, green: 0.12, blue: 0.12), Color(red: 0.31, green: 0.23, blue: 0.12)]; static let purpleGradient = [Color(red: 0.17, green: 0.10, blue: 0.11), Color(red: 0.39, green: 0.22, blue: 0.11)]; static let oceanGradient = [Color(red: 0.13, green: 0.14, blue: 0.12), Color(red: 0.40, green: 0.29, blue: 0.12)]; static let goldGradient = [Color(red: 0.24, green: 0.18, blue: 0.09), Color(red: 0.48, green: 0.31, blue: 0.11)]; static let copperGradient = [Color(red: 0.26, green: 0.15, blue: 0.09), Color(red: 0.44, green: 0.22, blue: 0.10)]
}
