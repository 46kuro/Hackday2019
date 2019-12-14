//
//  Int+Extension.swift
//  Professional
//
//  Created by Shinji Kurosawa on 2018/12/30.
//  Copyright © 2018 Shinji Kurosawa. All rights reserved.
//

import Foundation

extension Int {
    var hourMinutesString: String {
        let hour = self / 60
        let minutes = self % 60
        if hour > 0 {
            return "\(hour)時間\(minutes)分"
        } else {
            return "\(minutes)分"
        }
        
    }
}
