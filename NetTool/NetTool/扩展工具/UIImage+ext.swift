//
//  UIImage+ext.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/22.
//

import Foundation
import UIKit

extension UIImage{
    /// 返回一个将红色背景变透明的UIImage
    /// - Returns: 红色
    func imageByRemoveRedBg() -> UIImage? {
//        let colorMasking1: [CGFloat] = [110, 230, 20, 155, 10, 133]
//        let image = transparentColor(colorMasking: colorMasking1)
        let colorMasking2: [CGFloat] = [110, 230, 20, 155, 10, 133]
        return transparentColor(colorMasking: colorMasking2)
    }
    
    private func transparentColor(colorMasking: [CGFloat]) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        guard let rawImageRef = self.cgImage, let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) else {
            return nil
        }
        UIGraphicsBeginImageContext(self.size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.translateBy(x: 0.0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        return result
    }
    
    ///裁剪image，rect是相对于image.size大小
    public func cropping(to rect: CGRect) -> UIImage? {
        guard self.size.width > rect.origin.x else {
            return nil
        }
        guard self.size.height > rect.origin.y else {
            return nil
        }
        let scaleRect = CGRect(x: rect.origin.x*self.scale, y: rect.origin.y*self.scale, width: rect.width*self.scale, height: rect.height*self.scale)
        if let cgImage = self.cgImage?.cropping(to: scaleRect) {
            let cropImage = UIImage(cgImage: cgImage, scale: self.scale, orientation: .up)
            return cropImage
        } else {
            return nil
        }
    }
}
