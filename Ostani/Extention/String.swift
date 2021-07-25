//
//  String.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit


extension String {
    
    func replace(_ target: String, withString: String)-> String {
        return self.replacingOccurrences(of: target, with: withString, options: String.CompareOptions.literal, range: nil)
    }
    
    func toEnglishNumber() -> String {
        var str = self
        let enNumber = ["0","1","2","3","4","5","6","7","8","9"]
        let faNumber = ["۰","۱","۲","۳","۴","۵","۶","۷","۸","۹"]
        let faNumber2 = ["٠","١","٢","٣","٤","٥","٦","٧","٨","٩"]
        for i in 0 ..< 10 {
            str = str.replace(faNumber[i], withString: enNumber[i])
        }
        for i in 0 ..< 10 {
            str = str.replace(faNumber2[i], withString: enNumber[i])
        }
        return str.applyingTransform(StringTransform.toLatin, reverse: false) ?? self
    }
    
    var base64ToImage: UIImage {
        get {
            let dataDecoded: NSData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedimage: UIImage = UIImage(data: dataDecoded as Data) ?? UIImage()
            
            return decodedimage
        }
    }
    
    func getDate(format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func toENDate(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .persian)
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "dd/MM/YYYY"
        let final = formatter.string(from: self.getDate())
        return final
    }
}
