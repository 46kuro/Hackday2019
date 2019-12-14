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

    var eggViews = [UIView]()
    var rectList = [CGRect]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, 
                             target: self,
                             selector: #selector(setupEggView),
                             userInfo: nil,
                             repeats: true)
        
        faceTracker = FaceTracker(view: self.cameraView, duplicatedView: duplicatedCameraView) { [weak self] rectList in
            // 数が変わったときはリスト自体を再作成
            guard self?.rectList.count == rectList.count else {
                self?.rectList = rectList
                self?.setupEggView()
                return
            }
            
            // 数が変わらないときは、近いリストのRectを変更する
            rectList.forEach({ rect in
                let nearestResultIndex = self?.rectList.enumerated().reduce((0, 10000)) { result, anotherRect -> (Int, CGFloat) in
                    let rectDistance = self?.distance(from: anotherRect.element.origin, to: rect.origin) ?? 10000 
                    return rectDistance <= result.1 ? (anotherRect.offset, rectDistance) : result
                }.0 ?? 0
                guard (self?.eggViews.count ?? 0) > nearestResultIndex else {
                    return
                } 
                self?.eggViews[nearestResultIndex].frame = rect
            })
        }
    }
    
    private func distance(from point: CGPoint, to anotherPoint: CGPoint) -> CGFloat {
        return sqrt((pow(abs(point.x - anotherPoint.x), 2)) + (pow(abs(point.y - anotherPoint.y), 2)))  
    }
    
    @objc private func setupEggView() {
        self.eggViews.forEach { $0.removeFromSuperview() }
        rectList.forEach { self.appendEggView(in: $0) }
    }
    
    private func appendEggView(in rect: CGRect) {
        let containerView = UIView(frame: rect)
        view.addSubview(containerView)
        
        let eggView = SCNView()
        eggView.scene = SCNScene(named: "SceneKitAsset.scnassets/egg.scn")!
        eggView.backgroundColor = .clear
        containerView.addSubview(eggView)
        eggView.fillSuperview()
        
        let rectView = UIView()
        rectView.backgroundColor = .clear
        rectView.layer.borderWidth = 3
        containerView.addSubview(rectView)
        rectView.fillSuperview()
        
        eggViews.append(containerView)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

