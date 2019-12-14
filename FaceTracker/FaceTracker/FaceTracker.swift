//
//  FaceTracker.swift
//  FaceTracker
//
//  Created by 齋藤健悟 on 2019/12/14.
//  Copyright © 2019 齋藤健悟. All rights reserved.
//

import UIKit
import AVFoundation

class FaceTracker: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let captureSession = AVCaptureSession() 
    let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)

    var videoOutput = AVCaptureVideoDataOutput()
    let duplicatedView: UIView
    let view: UIView
    
    private var findface: (_ arr: Array<CGRect>) -> Void
    required init(view: UIView, duplicatedView: UIView, findface: @escaping (_ arr: Array<CGRect>) -> Void) {
        self.view = view
        self.duplicatedView = duplicatedView
        self.findface = findface
        super.init()
        self.initialize()
    }


    func initialize()
    {
        // 各デバイスの登録(audioは実際いらない)
        do {
            let videoInput = try AVCaptureDeviceInput(device: self.videoDevice!) as AVCaptureDeviceInput
            self.captureSession.addInput(videoInput)
        } catch let error as NSError {
            print(error)
        }

        self.videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_32BGRA)]
        
        // フレーム毎に呼び出すデリゲート登録
        let queue: DispatchQueue = DispatchQueue(label: "myqueue", attributes: .concurrent)
        self.videoOutput.setSampleBufferDelegate(self, queue: queue)
        self.videoOutput.alwaysDiscardsLateVideoFrames = true

        self.captureSession.addOutput(self.videoOutput)
        
        // カメラ向き
        for connection in self.videoOutput.connections {
            let conn = connection
            if conn.isVideoOrientationSupported {
                conn.videoOrientation = AVCaptureVideoOrientation.portrait
            }
        }

        self.captureSession.startRunning()
    }

    func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage {
        //バッファーをUIImageに変換
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        let imageRef = context!.makeImage()

        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let resultImage: UIImage = UIImage(cgImage: imageRef!)
        return resultImage
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        //同期処理（非同期処理ではキューが溜まりすぎて画面がついていかない）
        DispatchQueue.main.sync(execute: {
            // バッファーをUIImageに変換
            let image = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer)
            let ciimage: CIImage! = CIImage(image: image)

            //CIDetectorAccuracyHighだと高精度（使った感じは遠距離による判定の精度）だが処理が遅くなる
            let detector : CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options:[CIDetectorAccuracy: CIDetectorAccuracyHigh] )!
            let faces: NSArray = detector.features(in: ciimage) as NSArray
            
            var rects = Array<CGRect>();
            var _ : CIFaceFeature = CIFaceFeature()
            for feature in faces {
                
                // 座標変換
                var faceRect : CGRect = (feature as AnyObject).bounds
                let widthPer = (self.view.bounds.width/image.size.width)
                let heightPer = (self.view.bounds.height/image.size.height)
                
                // UIKitは左上に原点があるが、CoreImageは左下に原点があるので揃える
                faceRect.origin.y = image.size.height - faceRect.origin.y - faceRect.size.height
                
                //倍率変換
                faceRect.origin.x = faceRect.origin.x * widthPer
                faceRect.origin.y = faceRect.origin.y * heightPer
                faceRect.size.width = faceRect.size.width * widthPer
                faceRect.size.height = faceRect.size.height * heightPer
                
                rects.append(faceRect)
            }
            self.findface(rects)
            
            view.subviews.forEach { $0.removeFromSuperview() }
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
            imageView.edges(to: view)
            imageView.fillSuperview()
            
            duplicatedView.subviews.forEach { $0.removeFromSuperview() }
            let duplicatedImageView = UIImageView(image: image)
            duplicatedImageView.contentMode = .scaleAspectFit
            duplicatedView.addSubview(duplicatedImageView)
            duplicatedImageView.fillSuperview()
            
            duplicatedView.layoutIfNeeded()
        })
    }
}


