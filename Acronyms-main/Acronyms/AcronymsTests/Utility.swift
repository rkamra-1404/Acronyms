//
//  Utility.swift
//  AcronymsTests
//
//  Created by Rahul Kamra on 21/07/22.
//

import Foundation
@testable import Acronyms

class StubGenerator {
    func stubAcronyms() -> [AcronymsData] {
        let path = Bundle.main.path(forResource: "AcronymsMock", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        let acronyms = try! decoder.decode([AcronymsData].self, from: data)
        return acronyms
    }
}
