//
//  UIImage.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit


extension UIImage {
    
    var imageToBase64: String {
        get {
            if let imageData:NSData = self.jpegData(compressionQuality: 0.1) as NSData? {
                return imageData.base64EncodedString(options: .lineLength64Characters)
            } else {
                return ""
            }
        }
    }
}

