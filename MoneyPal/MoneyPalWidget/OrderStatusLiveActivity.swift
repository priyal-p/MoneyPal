//
//  OrderStatusLiveActivity.swift
//  MoneyPalWidget
//
//  Created by Priyal PORWAL on 12/12/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderAttributes.self) {
            context in
            // Lock screen/banner UI goes here
            ZStack {
                VStack(alignment: .leading) {
                    HStack{
                        companyImage(image: context.attributes.image)

                        companyName(name: context.attributes.stockName)

                        exchange(context.attributes.exchange)
                    }

                    VStack(spacing: 5) {
                        HStack(alignment: .center) {
                            transactionTypeView(context.state.transaction)

                            productTypeView(context.state.productType)

                            quantityView(context.state.quantity)

                            Spacer(minLength: 0)
                        }
                        HStack(alignment: .top, spacing: 0) {
                            VStack(alignment: .leading, spacing: 4) {
                                stockPrice(context.state.price.priceStr ?? "0.00")

                                orderUpdateTime(context.state.timestamp)
                            }
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity,
                                   alignment: .leading)

                            orderStatus(isStale: context.isStale, status: context.state.status)
                        }

                        if let date = (UserDefaults(suiteName: "group.com.priyal.porwal.moneypal")?.value(forKey: "MP_lastUpdatedTime") as? Date),
                           context.isStale {
                            HStack {
                                Text("Updated \(date, style: .relative)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing)

                                Spacer(minLength: 0)
                                Text(" ago")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .fixedSize()
                            }.frame(maxWidth: .infinity)
                        }

//                        HStack {
//                            Text("Updated \(Text.init((UserDefaults(suiteName: "group.com.priyal.porwal.moneypal")?.value(forKey: "MP_lastUpdatedTime") as? Date) ?? Date.now - 120, style: .relative))")
//                                .font(.caption)
//                                .foregroundColor(.white)
//                                .multilineTextAlignment(.trailing)
//
//                            Spacer(minLength: 0)
//                            Text(" ago")
//                                .font(.caption)
//                                .foregroundColor(.white)
//                                .fixedSize()
//                        }.frame(maxWidth: .infinity)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .padding(15)
            .background {
                LinearGradient(
                    colors: [
                        Color("DarkishBlue"),
                        Color("Indigo")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            }
            .activityBackgroundTint(.clear)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    leadingView(attributes: context.attributes)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    trailingView()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    bottomView(status: context.state, isStale: context.isStale)
                }
            } compactLeading: {
                compactCompanyLogoView()
            } compactTrailing: {
                compactStatusView(context.state.status,
                                  isStale: context.isStale)
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

    // MARK: Main Title
    func orderMessage(status: OrderStatusType) -> String {
        switch status {
        case .pending:
            return "Pending"
        case .successful:
            return "Successful"
        case .failed:
            return "Failed"
        case .cancelled:
            return "Cancelled"
        }
    }


    func orderUpdateTime(status: OrderStatusType) -> String {
        switch status {
        case .pending:
            return "10:20 AM"
        case .successful:
            return "10:30 AM"
        case .failed:
            return "1:05 PM"
        case .cancelled:
            return "1:05 PM"
        }
    }
    
    func bottomView(status: OrderAttributes.OrderExecutionStatus, isStale: Bool) -> some View {
        VStack(spacing: 5) {
            HStack(alignment: .bottom) {
                transactionTypeView(status.transaction)

                productTypeView(status.productType)

                quantityView(status.quantity)

                Spacer(minLength: 0)
            }
            .offset(x: 5, y: 0)

            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    stockPrice(status.price.priceStr ?? "0.00")

                    orderUpdateTime(orderUpdateTime(status: status.status))
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .leading)
                .offset(x: 5, y: 0)

                orderStatus(isStale: isStale, status: status.status)
                    .offset(y: -10)
            }

            if let date = (UserDefaults(suiteName: "group.com.priyal.porwal.moneypal")?.value(forKey: "MP_lastUpdatedTime") as? Date),
               isStale {
                HStack {
                    Text("Updated \(date, style: .relative)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)

                    Spacer(minLength: 0)
                    Text(" ago")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fixedSize()
                }.frame(maxWidth: .infinity)
                    .offset(y: -10)
            }

//            HStack {
//                Text("Updated \(Text.init((UserDefaults(suiteName: "group.com.priyal.porwal.moneypal")?.value(forKey: "MP_lastUpdatedTime") as? Date) ?? Date.now - 120, style: .relative))")
//                    .font(.caption)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.trailing)
//
//                Spacer(minLength: 0)
//                Text(" ago")
//                    .font(.caption)
//                    .foregroundColor(.white)
//                    .fixedSize()
//            }.frame(maxWidth: .infinity)
//                .offset(y: -10)
        }
    }

    func leadingView(attributes: OrderAttributes) -> some View {
        HStack{
            companyImage(image: attributes.image)

            companyName(name: attributes.stockName)
                .padding(.top, 10)

            exchange(attributes.exchange)
        }
    }

    func companyImage(image: String) -> some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .clipShape(ContainerRelativeShape())
    }

    func companyName(name: String) -> some View {
        Text(name)
            .font(.system(size: 16))
            .foregroundColor(.white)
            .frame(maxWidth: UIScreen.main.bounds.width - 200,
                   alignment: .leading)
            .fixedSize()
    }

    func exchange(_ exchange: String) -> some View {
        Text(exchange)
            .font(.caption2)
            .foregroundColor(.gray)
            .fixedSize()
            .padding(.top, 10)
    }

    func transactionTypeView(_ txnType: OrderAttributes.Transaction) -> some View {
        Text(txnType.title)
            .font(.caption2)
            .foregroundColor(txnType == .buy ? .green : .red)
            .padding(3)
            .frame(width: 15, height: 15)
            .overlay {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(txnType == .buy ? .green : .red, lineWidth: 1)
            }
    }

    func productTypeView(_ productType: String) -> some View {
        Text(productType)
            .font(.caption2)
            .foregroundColor(.gray)
            .padding(3)
            .frame(height: 15)
            .overlay {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.gray, lineWidth: 1)
            }
    }

    func quantityView(_ quantity: Int) -> some View {
        Text("Qty \(quantity)")
            .font(.caption2)
            .foregroundColor(.gray)
    }

    func stockPrice(_ price: String) -> some View {
        Text(price)
            .font(.callout)
            .foregroundColor(.white)
    }

    func orderUpdateTime(_ time: String) -> some View {
        Text(time)
            .font(.caption2)
            .foregroundColor(.white)
    }

    func orderStatus(isStale: Bool, status: OrderStatusType) -> some View {
        Text(orderMessage(status: status))
            .font(.body)
            .fontWeight(Font.Weight.bold)
            .foregroundColor(.white)
            .frame(height: 35)
            .padding([.leading, .trailing], 5)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(isStale ? Color.gray : Color(status.bgColor))
            }
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .padding(-1)
            }
    }

    func trailingView() -> some View {
        Image("moneyLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .padding(.trailing, 5)
    }

    func compactStatusView(_ status: OrderStatusType, isStale: Bool) -> some View {
        Text(status.title)
            .font(.body)
            .fontWeight(Font.Weight.bold)
            .foregroundColor(.white)
            .padding(.vertical, 3)
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(isStale ? Color.gray : Color(status.bgColor))
            }
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .padding(-1)
            }
            .padding(5)
    }
}

struct OrderStatusLiveActivity_Previews: PreviewProvider {
    static let attributes = OrderAttributes(
        orderId: "1",
        stockName: "Britania Industries",
        image: "britania",
        exchange: "NSE")
    static let contentState = OrderAttributes.ContentState(
        status: .pending,
        timestamp: Date.now.formatted(.dateTime.hour().minute()),
        productType: "Delivery",
        transaction: .buy,
        quantity: 10,
        price: 4630.23)

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

        attributes
            .previewContext(contentState,
                            isStale: true,
                            viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact Stale")
        attributes
            .previewContext(contentState,
                            isStale: true,
                            viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded Stale")
        attributes
            .previewContext(contentState,
                            isStale: true,
                            viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal Stale")
        attributes
            .previewContext(contentState,
                            isStale: true,
                            viewKind: .content)
            .previewDisplayName("Notification Stale")
    }
}
