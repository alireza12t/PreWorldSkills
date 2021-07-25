//
//  CenterModel.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import Foundation

// MARK: - CenterListElement
struct CenterListElement: Codable {
    let id: Int
    let centerType: CenterType
    let name, address: String
    let longitude, latitude: Double
    let image: String
}

typealias CenterList = [CenterListElement]


// MARK: - CenterDetail
struct CenterDetail: Codable {
    let id: Int
    let centerType: CenterType
    let name, address: String
    let longitude, latitude: Double
    let image, telephone: String
    let score: Int
    let manager: ManagerData
}
