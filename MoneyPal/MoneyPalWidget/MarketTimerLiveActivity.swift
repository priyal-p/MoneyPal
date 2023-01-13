//
//  MarketTimerLiveActivity.swift
//  MoneyPal
//
//  Created by Priyal PORWAL on 16/12/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MarketTimerLiveActivity: Widget {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced

    var body: some WidgetConfiguration {
        ActivityConfiguration(
            for: MarketTimerAttributes.self) { context in
                // Lock screen/banner UI
                MarketTimerNotificationView(timerRange: context.state.timerRange)
                    .activityBackgroundTint(.clear)
                    .activitySystemActionForegroundColor(Color.black)
            } dynamicIsland: { context in
                DynamicIsland {
                    // Expanded UI
                    DynamicIslandExpandedRegion(.leading) {
                        DynamicIslandLeadingView()
                    }
                    DynamicIslandExpandedRegion(.trailing) {
                        DynamicIslandTrailingView(timerRange: context.state.timerRange)
                    }
                    DynamicIslandExpandedRegion(.bottom) {
                        DynamicIslandBottomView()
                    }
                    DynamicIslandExpandedRegion(.center) {

                    }
                }
            compactLeading: {
                    compactCompanyLogoView()
                }
            compactTrailing: {
                    DynamicIslandTrailingView(timerRange: context.state.timerRange)
                }
            minimal: {
                    compactCompanyLogoView()
                }
                .widgetURL(URL(string: "https://www.paytmmoney.com"))
                .keylineTint(Color.blue)
            }
    }

    func compactCompanyLogoView() -> some View {
        Image("moneyLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding([.leading, .trailing], 5)
            .clipShape(ContainerRelativeShape())
    }

    func trailingView() -> some View {
        Image("moneyLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .padding(.trailing, 5)
    }
}

struct MarketTimerLiveActivity_Previews: PreviewProvider {
    static let attributes = MarketTimerAttributes(name: "")
    static let contentState = MarketTimerAttributes.ContentState(timerRange: Date.now...Date(timeIntervalSinceNow: Double(60*15)))

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}

struct DynamicIslandLeadingView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced

    var body: some View {
        HStack(spacing: 5) {
            Image("moneyLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25,
                       height: 25)
                .opacity(isLuminanceReduced ? 0.5 : 1.0)

            Text("Paytm Money")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .foregroundStyle(.tint)
                .fixedSize()
        }
    }
}

struct DynamicIslandTrailingView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    var timerRange: ClosedRange<Date>

    var body: some View {
        VStack(spacing: 0) {
            Text(timerInterval: timerRange)
                .monospacedDigit()
                .multilineTextAlignment(.center)
                .frame(width: 70)
                .font(.title2)
                .fontWeight(.bold)

            Text("Remaining")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .fixedSize()
                .opacity(isLuminanceReduced ? 0.5 : 1.0)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DynamicIslandBottomView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Time till your intraday positions are square-off")
                .font(.subheadline)
                .fontWeight(.regular)
                .frame(maxHeight: .infinity)
                .foregroundStyle(.white)
                .foregroundColor(.white)
                .opacity(isLuminanceReduced ? 0.5 : 1.0)

            HStack(spacing: 2) {
                Link(destination: URL(
                    string: "https://www.google.com")!) {
                        Text("Positions")
                            .font(.title3)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                            .background {
                                Color.gray.opacity(0.3)
                            }
                            .clipShape(ContainerRelativeShape())
                    }

                Link(destination: URL(
                    string: "https://www.apple.com")!) {
                        Button {
                            print("Opening URL")

                        } label: {
                            Text("Orders")
                                .font(.title3)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background {
                                    Color.gray.opacity(0.3)
                                }
                                .clipShape(ContainerRelativeShape())
                                .environment(\.openURL, OpenURLAction(handler: { url in
                                    print("Open \(url)")
                                    return .discarded
                                }))
                        }
                    }
            }
        }
    }
}
struct MarketTimerNotificationView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    var timerRange: ClosedRange<Date>
    var body: some View {
        HStack {
            VStack {
                HStack(spacing: 5) {
                    compactCompanyLogoView()
                        .frame(width: 40,
                               height: 40)
                        .opacity(isLuminanceReduced ? 0.5 : 1.0)

                    Text("Paytm Money")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .foregroundStyle(.tint)

                    Spacer()
                }

                Text("Time till your intraday positions are square-off")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .fixedSize(
                        horizontal: false,
                        vertical: true)
                    .foregroundStyle(.white)
                    .foregroundColor(.white)
                    .opacity(isLuminanceReduced ? 0.5 : 1.0)

            }

            VStack {
                Text(timerInterval: timerRange)
                    .monospacedDigit()
                    .multilineTextAlignment(.center)
                    .frame(width: 90)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.tint)

                Text("Remaining")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .opacity(isLuminanceReduced ? 0.5 : 1.0)
            }.tint(.cyan)
        }
        .padding(15)
        .background(content: {
            LinearGradient(gradient: Gradient(colors: [Color("Indigo"), Color("DarkishBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        })
    }

    func compactCompanyLogoView() -> some View {
        Image("moneyLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding([.leading, .trailing], 5)
            .clipShape(ContainerRelativeShape())
    }
}
