//
//  SubscriptionSet.swift
//  
//
//  Created by Will Dale on 04/06/2021.
//

import Foundation
import Combine

internal final class SubscriptionSet {
    internal var subscription = Set<AnyCancellable>()
}
