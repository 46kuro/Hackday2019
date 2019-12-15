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
    @IBOutlet var cameraView: UIView!
    @IBOutlet weak var duplicatedCameraView: UIView!

    var eggViews = [UIView]()
    var rectList = [CGRect]()
    
    var duplicatedEggViews = [UIView]()
    var duplicatedRectList = [CGRect]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, 
                             target: self,
                             selector: #selector(setupEggViews),
                             userInfo: nil,
                             repeats: true)
        
        faceTracker = FaceTracker(view: self.cameraView, duplicatedView: duplicatedCameraView) { [weak self] rectList in
            guard let self = self else { return }
            // 数が変わったときはリスト自体を再作成
            guard self.rectList.count == rectList.count else {
                self.rectList = rectList
                return
            }
            
            // 数が変わらないときは、近いリストのRectを変更する
            let cameraHeight = self.cameraView.frame.height
            rectList.forEach({ rect in
                let nearestResultIndex = self.rectList.enumerated().reduce((0, 10000)) { result, anotherRect -> (Int, CGFloat) in
                    let rectDistance = self.distance(from: anotherRect.element.origin, to: rect.origin) 
                    return rectDistance <= result.1 ? (anotherRect.offset, rectDistance) : result
                }.0
                
                guard self.eggViews.count > nearestResultIndex else { return } 
                self.eggViews[nearestResultIndex].frame = rect
                
                guard self.duplicatedEggViews.count > nearestResultIndex else { return } 
                self.duplicatedEggViews[nearestResultIndex].frame = CGRect(x: rect.origin.x, 
                                                                           y: rect.origin.y + cameraHeight,
                                                                           width: rect.width,
                                                                           height: rect.height)
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
            duplicateEggViews()
        } else if eggViews.count == rectList.count {
            // TODO: 値がそのままのときは、Viewを合わせていく
        } else {
            // TODO: 値が増えているときは、もっとも距離が短いViewからViewを合わせていく
            // 足りない分のViewは追加する
            self.eggViews.forEach { $0.removeFromSuperview() }
            self.eggViews = []
            rectList.forEach { self.appendEggView(in: $0) }
            duplicateEggViews()
        }
    }
    
    private func appendEggView(in rect: CGRect) {
        let containerView = UIView(frame: rect)
        view.addSubview(containerView)
        
        let eggView = makeEggView()
        containerView.addSubview(eggView)
        eggView.fillSuperview()
        
        eggViews.append(containerView)
    }
    
    private func duplicateEggViews() {
        duplicatedRectList = []
        duplicatedEggViews.forEach { $0.removeFromSuperview() }
        duplicatedEggViews = []
        
        rectList.forEach {
            let y = $0.origin.y + cameraView.frame.height
            duplicatedRectList.append(CGRect(x: $0.origin.x, y: y, width: $0.size.width, height: $0.size.height))
        }
        duplicatedRectList.forEach { 
            appendDuplicatedEggView(in: $0)
        }
    }
    
    private func appendDuplicatedEggView(in rect: CGRect) {
        let containerView = UIView(frame: rect)
        view.addSubview(containerView)
        
        let eggView = makeEggView()
        containerView.addSubview(eggView)
        eggView.fillSuperview()
        
        duplicatedEggViews.append(containerView)
    }
    
    private func makeEggView() -> UIView {
        let eggView = SCNView()
        eggView.scene = SCNScene(named: "SceneKitAsset.scnassets/potate_with_uv.scn")!
        eggView.backgroundColor = .clear
        return eggView
    }    
}

