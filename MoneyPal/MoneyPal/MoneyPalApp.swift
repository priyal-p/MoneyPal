//
//  MoneyPalApp.swift
//  MoneyPal
//
//  Created by Priyal PORWAL on 12/12/22.
//

import SwiftUI
import BackgroundTasks
import ActivityKit

@main
struct MoneyPalApp: App {
    @Environment(\.scenePhase) private var phase
    @State var activityId: String = ""
    @State var marketOpenActivityId: String = ""
    var body: some Scene {
        WindowGroup {
            ContentView(currentActivityId: $activityId, currentMarketOpenActivityId: $marketOpenActivityId)
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .background:
                scheduleAppRefresh()
            default: break
            }
        }
        .backgroundTask(.appRefresh("com.priyal.porwal.liveactivityupdate")) {
            scheduleAppRefresh()
            let request = URLRequest(url: URL(string: "https://mocki.io/v1/dd3eff8c-1f70-4270-9f01-b0f428de61aa")!)
            guard let data = try? await URLSession.shared.data(for: request).0
            else { return }

            let decoder = JSONDecoder()
            guard let status = try? decoder.decode(OrderAttributes.ContentState.self, from: data)
            else {
                print(String(bytes: data, encoding: .utf8) ?? "")
                return
            }

            if !Task.isCancelled {
                updateActivity(for: status)
            }
        }
    }

    func updateActivity(for currentSelection: OrderAttributes.ContentState) {
        if !Activity<OrderAttributes>.activities.isEmpty,
           let activity = Activity<OrderAttributes>.activities.first(where: { (activity: Activity<OrderAttributes>) in
               activity.id == activityId
           }) {
            UserDefaults(suiteName: "com.priyal.porwal.moneypal")?.set(Date.now, forKey: "MP_lastUpdatedTime")
            print("Activity Found \(activityId)")
            // Delaying action by 2s to show animation
            // Remove in real time
            Task {
                let alertConfiguration = AlertConfiguration(
                    title: "Order Update",
                    body: LocalizedStringResource(stringLiteral: "Test Message"),
                    sound: .default)
                let activityContent = ActivityContent(
                    state: currentSelection,
                    staleDate: Date.now + 2)
//                if currentSelection.status != .pending {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        print("remove activity")
//                        removeOrderStatusActivity()
//                    }
//                }
                await activity.update(activityContent,
                                      alertConfiguration: alertConfiguration)
            }
        }
    }

    func removeOrderStatusActivity() {
        if let activity = Activity.activities
            .first(where: { (activity: Activity<OrderAttributes>) in
                activity.id == activityId
            }) {
            Task {
                let activityContent = ActivityContent(
                    state: activity.content.state,
                    staleDate: Date.now + 1)
                await activity.end(
                    activityContent,
                    dismissalPolicy: ActivityUIDismissalPolicy.after(Date.now + 5))
            }
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.priyal.porwal.liveactivityupdate")
        //request.earliestBeginDate = .now.addingTimeInterval(24 * 3600)
        request.earliestBeginDate = .now.addingTimeInterval(2)
        let time = Date.now - (60 * 7)
        updateActivity(for: OrderAttributes.ContentState(
            status: .successful,
            timestamp: time.formatted(.dateTime.hour().minute()),
            productType: "Delivery",
            transaction: .buy,
            quantity: 10,
            price: 4333.70))
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Submitted")
            DispatchQueue.main.async {
                if !Activity<OrderAttributes>.activities.isEmpty,
                   let activity = Activity<OrderAttributes>.activities.first(where: { (activity: Activity<OrderAttributes>) in
                       activity.id == activityId
                   }) {
                    switch activity.activityState {
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
                }
            }
        } catch let error {
            print(error)
            print("Failed to submit task")
        }
    }
}
