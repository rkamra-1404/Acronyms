//
//  AcronymsModelTests.swift
//  AcronymsTests
//
//  Created by Rahul Kamra on 21/07/22.
//

import XCTest
@testable import Acronyms

class AcronymsModelTests: XCTestCase {
    
    func testJSONMapping() throws {
        let data = StubGenerator().stubAcronyms()

        XCTAssertEqual(data.count, 1)
        XCTAssertEqual(data.first!.fullFormArray.count, 8)
    }
}
