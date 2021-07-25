//
//  UserDefaultsHelper.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//
import Foundation
import UIKit

enum UserDefaultKeys: String {
    case phoneNumber
    case token
    case firstName
    case lastName
    case image
    case allCentersCount
    case myCentersCount
}

class StoringData {
    
    static var allCentersCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultKeys.allCentersCount.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.allCentersCount.rawValue)
        }
    }
    
    static var myCentersCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultKeys.myCentersCount.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.myCentersCount.rawValue)
        }
    }
        
    static var phoneNumber: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.phoneNumber.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.phoneNumber.rawValue)
        }
    }
    
    static var firstName: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.firstName.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.firstName.rawValue)
        }
    }
    
    static var token: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.token.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.token.rawValue)
        }
    }
    
    static var lastName: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.lastName.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.lastName.rawValue)
        }
    }
    
    static var image: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.image.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.image.rawValue)
        }
    }
    
}
