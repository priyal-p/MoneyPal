//
//  MarketOpenTimerLiveActivity.swift
//  MoneyPal
//
//  Created by Priyal PORWAL on 16/12/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MarketOpenTimerLiveActivity: Widget {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MarketOpenTimerAttributes.self) {
            context in
            // Lock screen/banner UI goes here
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
                    Text(timerInterval: context.state.timerRange)
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
            .activityBackgroundTint(.clear.opacity(0))
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
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
                DynamicIslandExpandedRegion(.trailing) {}
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 1) {
                            Text("Time till your intraday positions are square-off")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true)
                                .foregroundStyle(.white)
                                .foregroundColor(.white)
                                .opacity(isLuminanceReduced ? 0.5 : 1.0)

                            Spacer()
                            VStack(spacing: 0) {
                                Text(timerInterval: context.state.timerRange)
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
                            .offset(y: -5)
                        }.offset(y: -5)

                        HStack(spacing: 2) {
                            Link(destination: URL(
                                string: "https://www.google.com")!) {
                                    Text("Positions")
                                        .font(.title3)
                                        .frame(
                                            maxWidth: .infinity,
                                            minHeight: 40,
                                            maxHeight: .infinity)

                                        .background {
                                            Color.gray.opacity(0.3)
                                        }
                                }

                            Link(destination: URL(
                                string: "https://www.apple.com")!) {
                                    Text("Orders")
                                        .font(.title3)
                                        .frame(
                                            maxWidth: .infinity,
                                            minHeight: 40,
                                            maxHeight: .infinity)
                                        .background {
                                            Color.gray.opacity(0.3)
                                        }

                                }
                        }
                    }
                }
            } compactLeading: {
                compactCompanyLogoView()
            } compactTrailing: {
                Text(timerInterval: context.state.timerRange)
                    .monospacedDigit()
                    .frame(width: 45)
                    .foregroundStyle(.tint)
            } minimal: {
                compactCompanyLogoView()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
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

struct MarketOpenTimerLiveActivity_Previews: PreviewProvider {
    static let attributes = MarketOpenTimerAttributes(name: "")
    static let contentState = MarketOpenTimerAttributes.ContentState(timerRange: Date.now...Date(timeIntervalSinceNow: Double(60*15)))

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
