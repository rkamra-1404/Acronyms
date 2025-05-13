//
//  AcronymsModel.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation

struct AcronymsData: Codable {
    let shortForm: String
    let fullFormArray: [AcronymsModel]
    
    enum CodingKeys: String, CodingKey {
        case shortForm = "sf"
        case fullFormArray = "lfs"
    }
}

struct AcronymsModel: Codable {
    let fullForm: String
    let frequency: Int
    let since: Int
    
    enum CodingKeys: String, CodingKey {
        case fullForm = "lf"
        case frequency = "freq"
        case since
    }
    
}
