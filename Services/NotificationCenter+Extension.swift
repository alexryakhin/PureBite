//
//  NotificationCenter+Extension.swift
//  Pure Bite
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Combine
import CoreData

extension NotificationCenter {
    var coreDataDidSavePublisher: NotificationCenter.Publisher {
        publisher(for: .NSManagedObjectContextDidSave)
    }
}
