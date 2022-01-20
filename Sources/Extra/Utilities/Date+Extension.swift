//
//  Date+Extension.swift
//  
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

extension Date {
    
    func timeIntervalSinceBootup() -> TimeInterval {
        return timeIntervalSince(Date() - ProcessInfo.processInfo.systemUptime)
    }
    
}
