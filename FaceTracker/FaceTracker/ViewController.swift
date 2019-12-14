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
                             selector: #selector(setupEggViews),
                             userInfo: nil,
                             repeats: true)
        
        faceTracker = FaceTracker(view: self.cameraView, duplicatedView: duplicatedCameraView) { [weak self] rectList in
            // 数が変わったときはリスト自体を再作成
            guard (self?.rectList.count ?? 0) == rectList.count else {
                self?.rectList = rectList
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
    
    @objc private func setupEggViews() {
        // RectListの値と比較
        if eggViews.count > rectList.count {
            // TODO: 値が減っているときは、もっとも距離が短いViewを作っていく
            // Indexが被っているView, 距離が遠いViewから順に削除していく
            self.eggViews.forEach { $0.removeFromSuperview() }
            self.eggViews = []
            rectList.forEach { self.appendEggView(in: $0) }
            
        } else if eggViews.count == rectList.count {
            // TODO: 値がそのままのときは、Viewを合わせていく
        } else {
            // TODO: 値が増えているときは、もっとも距離が短いViewからViewを合わせていく
            // 足りない分のViewは追加する
            self.eggViews.forEach { $0.removeFromSuperview() }
            self.eggViews = []
            
            rectList.forEach {
                self.appendEggView(in: $0)
            }
        }
    }
    
    private func appendEggView(in rect: CGRect) {
        let containerView = UIView(frame: rect)
        view.addSubview(containerView)
        
        let eggView = SCNView()
        eggView.scene = SCNScene(named: "SceneKitAsset.scnassets/poteto.scn")!
        eggView.backgroundColor = .clear
        containerView.addSubview(eggView)
        eggView.fillSuperview()
        
        eggViews.append(containerView)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

