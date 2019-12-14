//
//  ViewController.swift
//  FaceTracker
//
//  Created by 齋藤健悟 on 2019/12/14.
//  Copyright © 2019 齋藤健悟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var faceTracker:FaceTracker? = nil;
    @IBOutlet var cameraView :UIView!//viewController上に一つviewを敷いてそれと繋いでおく

    var rectView = UIView()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.rectView.layer.borderWidth = 3//四角い枠を用意しておく
        self.view.addSubview(self.rectView)
        faceTracker = FaceTracker(view: self.cameraView, findface:{arr in
            let rect = arr[0];//一番の顔だけ使う
            self.rectView.frame = rect;//四角い枠を顔の位置に移動する
        })
    }

    
    
}

