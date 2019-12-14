//
//  ViewController.swift
//  FaceTracker
//
//  Created by 齋藤健悟 on 2019/12/14.
//  Copyright © 2019 齋藤健悟. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class ViewController: UIViewController {

    var faceTracker: FaceTracker? = nil;
    @IBOutlet var cameraView :UIView!
    @IBOutlet weak var duplicatedCameraView: UIView!

    let eggView = SCNView()
    let rect = UIView()
    
    override func loadView() {
        super.loadView()
        
        setupEggView()
        
        rect.layer.borderWidth = 3
        view.addSubview(rect)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        faceTracker = FaceTracker(view: self.cameraView, duplicatedView: duplicatedCameraView) { arr in
            if arr.count < 1 {
                self.eggView.isHidden = true
            }
            if arr.indices.contains(0) {
                self.eggView.isHidden = false
                // 一番の顔だけ使う
                let rect1 = arr[0]
                // 顔の位置に移動する
                self.eggView.frame = rect1
                self.rect.frame = rect1
            }
        }
    }
    
    private func setupEggView() {
        view.addSubview(eggView)
        view.bringSubviewToFront(eggView)
        // create a new scene
        let scene = SCNScene(named: "SceneKitAsset.scnassets/test.scn")!
        // set the scene to the view
        eggView.scene = scene
        eggView.backgroundColor = .clear
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

