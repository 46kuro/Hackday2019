//
//  ViewController.swift
//  FaceTracker
//
//  Created by 齋藤健悟 on 2019/12/14.
//  Copyright © 2019 齋藤健悟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var faceTracker: FaceTracker? = nil;
    //viewController上に一つviewを敷いてそれと繋いでおく
    @IBOutlet var cameraView :UIView!

    var rectViewFront = UIView()
    var rectViewBack = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.rectViewFront.layer.borderWidth = 3
        self.rectViewBack.layer.borderWidth = 3
        rectViewBack.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(self.rectViewFront)
        view.addSubview(rectViewBack)
        
        faceTracker = FaceTracker(view: self.cameraView, findface:{arr in
            if arr.count < 1 {
                self.rectViewFront.isHidden = true
                self.rectViewBack.isHidden = true
            }
            if arr.indices.contains(0) {
                self.rectViewFront.isHidden = false
                //一番の顔だけ使う
                let rect1 = arr[0]
                //四角い枠を顔の位置に移動する
                self.rectViewFront.frame = rect1
            }
            
            if arr.indices.contains(1) {
                self.rectViewBack.isHidden = false
                let rect2 = arr[1]
                self.rectViewBack.frame = rect2
            } else {
                self.rectViewBack.isHidden = true
            }
        })
    }

    
    
}

