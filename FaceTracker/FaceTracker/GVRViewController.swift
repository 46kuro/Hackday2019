//
//  GVRViewController.swift
//  FaceTracker
//
//  Created by Shinji Kurosawa on 2019/12/14.
//  Copyright © 2019 齋藤健悟. All rights reserved.
//

import GVRKit
import UIKit

class GVRViewController: GVRRendererViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerViewController = FaceTrackerViewController.instantiate()  
        add(containerViewController, from: rendererView)
    }
}
