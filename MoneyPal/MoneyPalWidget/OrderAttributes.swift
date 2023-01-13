//
//  OrderAttributes.swift
//  MoneyPal
//
//  Created by Priyal PORWAL on 12/12/22.
//

import SwiftUI
import ActivityKit

public protocol ExpressibleAsNSNumber {
    var nsNumber: NSNumber { get }
}

public struct NumberStyles {
    private static let formatter: NumberFormatter = {
        let customFormatter = NumberFormatter()
        customFormatter.maximumFractionDigits = 2
        customFormatter.minimumFractionDigits = 2
        customFormatter.minimumIntegerDigits = 1
        customFormatter.locale = Locale(identifier: "en_IN")
        customFormatter.numberStyle = .currency
        return customFormatter
    }()

    func priceRepresentation<T: ExpressibleAsNSNumber>(_ value: T) -> String? {
        NumberStyles.formatter
            .string(from: value.nsNumber)?
            .trimmingCharacters(in: .whitespaces)
    }
}

extension Numeric where Self: ExpressibleAsNSNumber {
    var priceStr: String? {
        NumberStyles().priceRepresentation(self)
    }
}

protocol Diffable: SignedNumeric, Comparable, ExpressibleAsNSNumber { }

extension Double: Diffable {
    public var nsNumber: NSNumber { NSNumber(value: self) }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}

extension Decimal: Diffable {
    public var nsNumber: NSNumber { doubleValue.nsNumber }
}

struct OrderAttributes: ActivityAttributes {
    public typealias OrderExecutionStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var status = OrderStatusType.pending
        var timestamp: String
        var productType: String
        var transaction: Transaction
        var quantity: Int
        var price: Decimal

        enum CodingKeys: CodingKey {
            case status
            case timestamp
            case productType
            case transaction
            case quantity
            case price
        }
    }

    public enum Transaction: String, CaseIterable, Codable, Equatable {
        case buy
        case sell

        var title: String {
            switch self {
            case .buy:
                return "B"
            case .sell:
                return "S"
            }
        }
    }

    var orderId: String
    var stockName: String
    var image: String
    var exchange: String
}

enum OrderStatusType: String, CaseIterable, Codable, Equatable {
    case pending
    case successful
    case failed
    case cancelled

    var title: String {
        switch self {
        case .pending:
            return "P"
        case .successful:
            return "S"
        case .failed:
            return "F"
        case .cancelled:
            return "C"
        }
    }

    var bgColor: String {
        switch self {
        case .pending:
            return "Squash"
        case .successful:
            return "Green"
        case .failed:
            return "Red"
        case .cancelled:
            return "Brown"
        }
    }
}
