//
//  ContentView.swift
//  MoneyPal
//
//  Created by Priyal PORWAL on 12/12/22.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct ContentView: View {
    // MARK: Updating Live Activity
    @Binding var currentActivityId: String
    @Binding var currentMarketOpenActivityId: String
    @State var currentSelection: Status = .received
    @Environment(\.openURL) var openURL
    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $currentSelection) {
                    Text("Received")
                        .tag(Status.received)
                    Text("Progress")
                        .tag(Status.progress)
                    Text("Ready")
                        .tag(Status.ready)
                } label: {}
                    .labelsHidden()
                    .pickerStyle(.segmented)

                // MARK: Initialising Activity
                Button("Start Order Status Activity") {
                    //                    addLiveActivity()
                    addOrderStatusActivity()
                    //                    addMarketTimerActivity()
                    //                    addMarketOpenTimerActivity()
                }
                .padding(.top)

                // MARK: Removing Activity
                Button("Remove Order Status Activity") {
                    removeActivity()
                }
                .padding(.top)

                // MARK: Initialising Activity
                Button("Start Market Timer Activity") {
                    //                    addLiveActivity()
//                    addOrderStatusActivity()
                    //                    addMarketTimerActivity()
                    addMarketOpenTimerActivity()
                }
                .padding(.top)
            }
            .navigationTitle("Live Activities")
            .padding(15)
            .onChange(of: currentSelection) { newValue in
                // Retrieving current activity from list of phone activities
                if let activity = Activity.activities.first(where: { (activity: Activity<OrderFoodAttributes>) in
                    activity.id == currentActivityId
                }) {
                    print("Activity Found")
                    // Delaying action by 2s to show animation
                    // Remove in real time
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        var updatedState = activity.content.state
                        updatedState.status = currentSelection
                        Task {
                            let alertConfiguration = AlertConfiguration(
                                title: "Order Update",
                                body: LocalizedStringResource(stringLiteral: subMessage(status: currentSelection)),
                                sound: .default)
                            let activityContent = ActivityContent(state: updatedState, staleDate: Date.now + 1)
                            await activity.update(
                                activityContent,
                                alertConfiguration: alertConfiguration)
                        }
                    }
                }
            }
            .onOpenURL { url in
                print(url.lastPathComponent)
                openURL(url)
            }
        }
    }
        func addMarketOpenTimerActivity() {
            let orderStatusAttributes = MarketOpenTimerAttributes(name: "Market Timer")
            let initialContentState = MarketOpenTimerAttributes.ContentState(timerRange: Date.now...Date(timeIntervalSinceNow: Double(60*10)))
            let activityContent = ActivityContent(state: initialContentState,
                                                  staleDate: Date.now + 1,
            relevanceScore: 100)
            do {
                let activity = try Activity<MarketOpenTimerAttributes>.request(
                    attributes: orderStatusAttributes,
                    content: activityContent,
                    pushType: nil)

                // MARK: Storing current id for updating activity
                currentMarketOpenActivityId = activity.id
                print("Activity Added Successfully, id: \(activity.id)")
            } catch {
                print(error.localizedDescription)
            }
        }

        func updateActivity(for currentSelection: OrderAttributes.ContentState) {
            if !Activity<OrderAttributes>.activities.isEmpty,
               let activity = Activity<OrderAttributes>.activities.first(where: { (activity: Activity<OrderAttributes>) in
                   activity.id == currentActivityId
               }) {
                print("Activity Found \(currentActivityId)")
                // Delaying action by 2s to show animation
                // Remove in real time
                Task {
                    let alertConfiguration = AlertConfiguration(
                        title: "Order Update",
                        body: LocalizedStringResource(stringLiteral: "Test Message"),
                        sound: .default)
                    let activityContent = ActivityContent(
                        state: currentSelection,
                        staleDate: Date.now + 1)
                    await activity.update(activityContent,
                                          alertConfiguration: alertConfiguration)
                }
            }
        }

    func addMarketTimerActivity() {
        let futureDate = Date(timeIntervalSinceNow: Double(60*10))
        let staleDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let dateRange = Date.now...futureDate

        if ActivityAuthorizationInfo().areActivitiesEnabled {

            let activityAttributes = MarketTimerAttributes(name: "Market Timer")

            let initialContentState = MarketTimerAttributes.ContentState(timerRange: dateRange)

            let activityContent = ActivityContent(state: initialContentState,
                                                  staleDate: staleDate,
                                                  relevanceScore: 50)

            let activity = try? Activity.request(attributes: activityAttributes,
                                                 content: activityContent,
                                                 pushType: .token)
        }

//            do {
//                let activity = try Activity.request(attributes: activityAttributes,
//                                                    content: activityContent,
//                                                    pushType: .token)
//                currentActivityId = activity.id
//                print("Activity Added Successfully, id: \(activity.id)")
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }

        func addOrderStatusActivity() {
            let time = Date.now - (60 * 4)
            UserDefaults(suiteName: "group.com.priyal.porwal.moneypal")?.set(time, forKey: "MP_lastUpdatedTime")

            print((UserDefaults(suiteName: "group.com.priyal.porwal.moneypal")?.value(forKey: "MP_lastUpdatedTime") as? Date)?.formatted(.dateTime.hour().minute()))
            let orderStatusAttributes = OrderAttributes(
                orderId: "1",
                stockName: "Britania Industries",
                image: "britania",
                exchange: "NSE")
            let initialContentState = OrderAttributes.ContentState(
                status: .pending,
                timestamp: time.formatted(.dateTime.hour().minute()),
                productType: "Delivery",
                transaction: .buy,
                quantity: 10,
                price: 4333.70)
            let activityContent = ActivityContent(state: initialContentState,
                                                  staleDate: Date.now + 10,
            relevanceScore: 50)
            do {
                let activity = try Activity<OrderAttributes>.request(
                    attributes: orderStatusAttributes,
                    content: activityContent,
                    pushType: .token)

                // MARK: Storing current id for updating activity
                currentActivityId = activity.id
                print("Activity Added Successfully, id: \(activity.id)")

                Task {
                    for await currActivityState in activity.activityStateUpdates {
                        await MainActor.run(body: {
                            switch currActivityState {
                            case .active:
                                print("Activty Active")
                            case .dismissed:
                                print("Activty Dismissed")
                            case .ended:
                                print("Activty Ended")
                            case .stale:
                                print("Activty Stale")
                            default:
                                print("Unknown")
                            }
                        })
                    }
                }
            } catch {
                print(error.localizedDescription)
            }

        }

        func addLiveActivity() {
            let orderFoodAttributes = OrderFoodAttributes(orderNumber: 1, orderItems: "Burger & Coffee")
            let initialContentState = OrderFoodAttributes.ContentState()
            let activityContent = ActivityContent(state: initialContentState,
                                                  staleDate: Date.now + 1)
            do {
                let activity = try Activity<OrderFoodAttributes>.request(
                    attributes: orderFoodAttributes,
                    content: activityContent,
                    pushType: nil)

                // MARK: Storing current id for updating activity
                currentActivityId = activity.id
                print("Activity Added Successfully, id: \(activity.id)")
            } catch {
                print(error.localizedDescription)
            }
        }

        func removeActivity() {
            if let activity = Activity.activities.first(where: { (activity: Activity<OrderFoodAttributes>) in
                activity.id == currentActivityId
            }) {
                Task {
                    let activityContentState = activity.content.state
                    let activityContent = ActivityContent(
                        state: activityContentState,
                        staleDate: Date.now + 1)
                    await activity.end(
                        activityContent,
                        dismissalPolicy: ActivityUIDismissalPolicy.after(Date.now + 10))
                }
            }
        }

    func removeOrderStatusActivity() {
        if let activity = Activity.activities
            .first(where: { (activity: Activity<OrderAttributes>) in
                activity.id == currentActivityId
            }) {
            Task {
                let activityContentState = activity.content.state
                let activityContent = ActivityContent(
                    state: activityContentState,
                    staleDate: Date.now + 1)
                await activity.end(
                    activityContent,
                    dismissalPolicy: ActivityUIDismissalPolicy.after(Date.now + 10))
            }
        }
    }

    func removeMarketOpenActivity() {
        if let activity = Activity.activities
            .first(where: { (activity: Activity<OrderAttributes>) in
                activity.id == currentMarketOpenActivityId
            }) {
            Task {
                let activityContentState = activity.content.state
                let activityContent = ActivityContent(
                    state: activityContentState,
                    staleDate: Date.now + 1)
                await activity.end(
                    activityContent,
                    dismissalPolicy: .immediate)
            }
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
    }

