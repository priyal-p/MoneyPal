//
//  OrderStatus.swift
//  MoneyPal
//
//  Created by Priyal PORWAL on 12/12/22.
//

import WidgetKit
import SwiftUI
import Intents

struct OrderStatus: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderFoodAttributes.self) { context in
            //MARK: Live Activity View
            // Note: Live Activity maximum height = 160 pixels
            // Lock screen/banner UI goes here
            ZStack {
                RoundedRectangle(cornerRadius: 15,
                                 style: .continuous)
                    .fill(Color("Green").gradient)
                // MARK: Order Status UI
                VStack {
                    HStack {
//                        Image("Logo")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30, height: 30)
                        Image("Logo")
                            .clipShape(ContainerRelativeShape())

                        Text("In Store Pickup")
                            .foregroundColor(.white.opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: -2) {
                            ForEach(["Burger", "Coffee"], id: \.self) { item in
                                Image(item)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        Circle()
                                            .fill(Color("Green"))
                                            .padding(-2)
                                    }
                                    .background {
                                        Circle()
                                            .stroke(.white, lineWidth: 1.5)
                                            .padding(-2)
                                    }
                            }
                        }
                    }

                    HStack(alignment: .bottom, spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message(status: context.state.status))
                                .font(.title3)
                                .foregroundColor(.white)
                            Text(subMessage(status: context.state.status))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: .infinity, alignment: .leading)

                        HStack(alignment: .bottom, spacing: 0) {
                            ForEach(Status.allCases, id: \.self) { type in
                                Image(systemName: type.image)
                                    .font(context.state.status == type ? .title2 : .body)
                                    .foregroundColor(context.state.status == type ? Color("Green") : .white.opacity(0.7))
                                    .frame(width:
                                            context.state.status == type ? 45 : 32,
                                           height:
                                            context.state.status == type ? 45 : 32)
                                    .background {
                                        Circle()
                                            .fill(context.state.status == type ? .white : .green.opacity(0.5))
                                    }
                                // MARK: Bottom Arrow to look like bubble
                                    .background(alignment: .bottom) {
                                        BottomArrow(status: context.state.status,
                                                    type: type)
                                    }
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .overlay(alignment: .bottom, content: {
                            // Image Size = 45 + Trailing Padding = 10
                            // 55/2 = 27.5
                            Rectangle()
                                .fill(.white.opacity(0.6))
                                .frame(height: 2)
                                .offset(y: 12)
                                .padding(.horizontal, 27.5)
                        })
                        .padding(.leading, 15)
                        .padding(.trailing, -10)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)
                }
                .padding(15)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            // MARK: Implementing Dynamic Island
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom

                // On long press
                // Expanded region can further be classified into 4 regions
                // Leading, Trailing, Center, Bottom
                DynamicIslandExpandedRegion(.leading) {
                    HStack{
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)

                        Text("In Store Pickup")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .fixedSize()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    trailingView()
                }

                DynamicIslandExpandedRegion(.center) {
//                    centerView(status: context.state.status)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    bottomView(status: context.state.status)
                }
            } compactLeading: {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(ContainerRelativeShape())
            } compactTrailing: {
                Image(systemName: context.state.status.image)
                    .font(.title3)
            } minimal: {
                // Only visible when multiple activities are there
                Image(systemName: context.state.status.image)
                    .font(.title3)
                    .padding([.leading, .trailing], 5)
            }
            .contentMargins([.trailing], 0, for: .expanded)
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }

    // MARK: Main Title
    func message(status: Status) -> String {
        switch status {
        case .received:
            return "Order received"
        case .ready:
            return "Order prepared"
        case .progress:
            return "Order in progress"
        }
    }

    // MARK: Sub Title
    func subMessage(status: Status) -> String {
        switch status {
        case .received:
            return "We just received your order"
        case .ready:
            return "We have prepared your awesome order"
        case .progress:
            return "We are handcrafting your order"
        }
    }

    // MARK: Spliting Code
    @ViewBuilder
    func BottomArrow(status: Status, type: Status) -> some View {
        Image(systemName: "arrowtriangle.down.fill")
            .font(.system(size: 15))
            .scaleEffect(x: 1.3)
            .offset(y: 6)
            .opacity(status == type ? 1 : 0)
            .foregroundColor(.white)
            .overlay(alignment: .bottom) {
                Circle()
                    .fill(.white)
                    .frame(width: 5, height: 5)
                    .offset(y: 13)
            }
    }

//    func centerView(status: Status) -> some View {
//        VStack(alignment: .center, spacing: 4) {
//            Text(message(status: status))
//                .font(.callout)
//                .foregroundColor(.white)
//            Text(subMessage(status: status))
//                .font(.caption2)
//                .foregroundColor(.gray)
//        }
//        .frame(maxHeight: .infinity)
//        .offset(x: 5, y: 5)
//    }

    func trailingView() -> some View {
        HStack(spacing: -2) {
            ForEach(["Burger", "Coffee"], id: \.self) { item in
                Image(item)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(ContainerRelativeShape())
                    .frame(width: 20, height: 20)
                    .background {
                        Circle()
                            .fill(Color("Green"))
                            .padding(-1)
                    }
                    .background {
                        Circle()
                            .stroke(.white, lineWidth: 1.5)
                            .padding(-1)
                    }
            }
        }
        .padding(.leading, 5)
    }

    func bottomView(status: Status) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(message(status: status))
                    .font(.callout)
                    .foregroundColor(.white)
                Text(subMessage(status: status))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(maxHeight: .infinity, alignment: .leading)
            .offset(x: 5, y: 5)

            HStack(alignment: .bottom, spacing: 0) {
                ForEach(Status.allCases, id: \.self) { type in
                    Image(systemName: type.image)
                        .font(status == type ? .title2 : .body)
                        .foregroundColor(status == type ? Color("Green") : .white.opacity(0.7))
                        .frame(width:
                                status == type ? 35 : 26,
                               height:
                                status == type ? 35 : 26)
                        .background {
                            Circle()
                                .fill(status == type ? .white : .green.opacity(0.5))
                        }
                    // MARK: Bottom Arrow to look like bubble
                        .background(alignment: .bottom) {
                            BottomArrow(status: status,
                                        type: type)
                        }
                        .frame(maxWidth: .infinity)
                }
            }
            .overlay(alignment: .bottom, content: {
                // Image Size = 45 + Trailing Padding = 10
                // 55/2 = 27.5
                Rectangle()
                    .fill(.white.opacity(0.6))
                    .frame(height: 2)
                    .offset(y: 12)
                    .padding(.horizontal, 27.5)
            })
            .offset(y: -5)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 10)
    }
}
