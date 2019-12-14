//
//  UIViewController+Extension.swift
//  Professional
//
//  Created by Shinji Kurosawa on 2018/12/29.
//  Copyright © 2018 Shinji Kurosawa. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController,
             from containerView: UIView) {
        addChild(child)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
        
        child.view.fillSuperview()
    }
}
