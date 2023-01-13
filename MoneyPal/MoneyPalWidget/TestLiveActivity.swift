//
//  TestLiveActivityLiveActivity.swift
//  TestLiveActivity
//
//  Created by Priyal Porwal on 05/12/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TestLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int = 0
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TestLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TestLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Rectangle().fill(Color.red)
                        .frame(height: 30)
//                        .dynamicIsland(verticalPlacement: .belowIfTooWide)
                }
                DynamicIslandExpandedRegion(.trailing, priority: 1) {
                    Rectangle().fill(Color.blue)
                        .frame(minHeight: 30, maxHeight: .infinity)
//                        .frame(width: 30, height: 50)
                    .dynamicIsland(verticalPlacement: .belowIfTooWide)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Rectangle().fill(Color.yellow)
                        .frame(maxWidth: .infinity, minHeight: 30, maxHeight: .infinity)
                }
//                DynamicIslandExpandedRegion(.center) {
////                    Rectangle().fill(Color.cyan).frame(width: 30, height: 30)
//                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct TestLiveActivityLiveActivity_Previews: PreviewProvider {
    static let attributes = TestLiveActivityAttributes(name: "")
    static let contentState = TestLiveActivityAttributes.ContentState()

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
