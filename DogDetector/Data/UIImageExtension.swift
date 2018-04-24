//
//  UIImageExtension.swift
//  DogDetector
//
//  Created by Quoc Nguyen on 1/15/18.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import CoreVideo
import UIKit

extension UIImage {
    func cropToPredict() -> UIImage? {
        if size.width == size.height {
            return self
        }
        guard let cgImage = self.cgImage else {
            return nil
        }
        let predictSize: CGFloat = 224
        let newX = (size.width - predictSize) / 2
        let newY = (size.height - predictSize) / 2
        guard let img = cgImage.cropping(to: CGRect(x: newX, y: newY, width: predictSize, height: predictSize)) else {
            return nil
        }
        return UIImage(cgImage: img, scale: UIScreen.main.scale, orientation: self.imageOrientation)
    }
}
