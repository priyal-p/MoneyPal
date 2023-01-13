//
//  OrderFoodAttributes.swift
//  MoneyPal
//
//  Created by Priyal PORWAL on 12/12/22.
//

import SwiftUI
import ActivityKit

struct OrderFoodAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        // Mark: live activities will update when content state is updated.
        // Dynamic stateful properties about your activity go here!
        var status = Status.received

        enum CodingKeys: CodingKey {
            case status
        }
    }

    // Fixed non-changing properties about your activity go here!
    var orderNumber: Int
    var orderItems: String
}

// Mark: Order Status
enum Status: String, CaseIterable, Codable, Equatable {
    case received
    case progress
    case ready

    var image: String {
        switch self {
        case .received:
            return "shippingbox.fill"
        case .progress:
            return "person.bust"
        case .ready:
            return "takeoutbag.and.cup.and.straw.fill"
        }
    }
}
