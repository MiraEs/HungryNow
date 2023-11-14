//
//  Item.swift
//  HungryNow
//
//  Created by Mir on 11/13/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
