//
//  MoneyPalWidgetBundle.swift
//  MoneyPalWidget
//
//  Created by Priyal PORWAL on 12/12/22.
//

import WidgetKit
import SwiftUI

@main
struct MoneyPalWidgetBundle: WidgetBundle {
    var body: some Widget {
        OrderStatus()
        MarketTimerLiveActivity()
        OrderStatusLiveActivity()
        MarketOpenTimerLiveActivity()
        TestLiveActivityLiveActivity()
    }
}
