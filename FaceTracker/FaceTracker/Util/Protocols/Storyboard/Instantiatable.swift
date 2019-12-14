//
//  Instantiatable.swift
//  Professional
//
//  Created by Shinji Kurosawa on 2018/12/10.
//  Copyright © 2018 Shinji Kurosawa. All rights reserved.
//

import Foundation

import UIKit

protocol Instantiatable { }

extension Instantiatable where Self: UIViewController {
    static var name: String {
        return String(describing: self)
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle(for: self))
    }
    
    static func instantiate() -> Self {
        return storyboard.instantiateInitialViewController() as! Self
    }
}
