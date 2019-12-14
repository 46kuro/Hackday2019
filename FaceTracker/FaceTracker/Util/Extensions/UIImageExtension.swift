//
//  UIImageExtension.swift
//  Professional
//
//  Created by Shinji Kurosawa on 2018/12/30.
//  Copyright © 2018 Shinji Kurosawa. All rights reserved.
//

import UIKit

// https://qiita.com/ruwatana/items/473c1fb6fc889215fca3
extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
