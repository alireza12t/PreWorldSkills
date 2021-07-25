//
//  AddCenterBody.swift
//  Ostani
//
//  Created by ali on 7/16/21.
//

import Foundation


struct AddCenterBody: Codable {
    var name, telephone, address: String
    var centerTypeId, score: Int
    var latitude, longitude: Double
    var manager: ManagerData
    var image: String?
}

struct ManagerData: Codable {
    var phoneNumber, firstName, lastName, nationalCode, birthDate: String
}

// MARK: - AddCenter
struct AddCenter: Codable {
    let id: Int
    let centerType: CenterType
    let name, address: String
    let longitude, latitude: Double
    let image: String?
    let telephone: String
    let score: Int
    let manager: Manager
}

// MARK: - CenterType
struct CenterType: Codable {
    let id: Int
    let title: String
}

// MARK: - Manager
struct Manager: Codable {
    let firstName, lastName, nationalCode, phoneNumber: String
    let birthDate: String
}
