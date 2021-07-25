//
//  ValidationHelper.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import Foundation


class ValidationHelper {
    
    class func isPhoneNumberValid(phoneNumber: String?) -> Bool {
        if let phoneNumber = phoneNumber?.toEnglishNumber(), phoneNumber.count == 11 {
            if phoneNumber.hasPrefix("09") {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    class func isNationalCodeValid(nationalCode: String?) -> Bool {
        if let nationalCode = nationalCode?.toEnglishNumber(), (nationalCode.count == 10 || nationalCode.isEmpty) {
            return true
        } else {
            return false
        }
    }
}
