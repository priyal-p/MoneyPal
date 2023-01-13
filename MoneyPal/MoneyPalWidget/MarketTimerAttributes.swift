//
//  MarketTimerAttributes.swift
//  MoneyPal
//
//  Created by Priyal PORWAL on 16/12/22.
//

import SwiftUI
import ActivityKit

struct MarketTimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var timerRange: ClosedRange<Date>
    }

    var name: String
}


struct MarketOpenTimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var timerRange: ClosedRange<Date>
    }

    var name: String
}
