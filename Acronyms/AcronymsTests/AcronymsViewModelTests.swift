//
//  AcronymsViewModelTests.swift
//  AcronymsTests
//
//  Created by Rahul Kamra on 21/07/22.
//

import XCTest
import Foundation
@testable import Acronyms

class AcronymsViewModelTests: XCTestCase {
    
    var sut: AcronymsViewModel!
    var mockAPIService: MockAcronymsService!
    var mockApiFailService: MockAcronymsFailService!
    
    override func setUp() {
            super.setUp()
            mockAPIService = MockAcronymsService()
            mockApiFailService = MockAcronymsFailService()
        }
        
        override func tearDown() {
            sut = nil
            mockAPIService = nil
            mockApiFailService = nil
            super.tearDown()
        }
    
    func test_fetch_Data() {
        sut = AcronymsViewModel(service: mockAPIService)
        sut.fetchAcronyms("")
            // Assert
            XCTAssertTrue(mockAPIService!.isFetchAcronymsCalled)
        }
    
    func test_create_view_model_array() {
        sut = AcronymsViewModel(service: mockAPIService)
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.shouldReloadTableView.bind(withHandler: { shouldReload in
            expect.fulfill()
        })
                
                // When
                sut.fetchAcronyms("")
                
                // Number of cell view model is equal to the number of photos
        XCTAssertEqual( sut.acronyms.count, 8)
                
                // XCTAssert reload closure triggered
                wait(for: [expect], timeout: 1.0)
        }
    
    func test_fail_create_view_model_array() {
        sut = AcronymsViewModel(service: mockApiFailService)
        let expect = XCTestExpectation(description: "error message closure triggered")
        sut.errorMessage.bind { error in
            expect.fulfill()
        }
        
        // When
        sut.fetchAcronyms("")
        XCTAssertEqual( sut.acronyms.count, 0)
        XCTAssertEqual(sut.error.value, true)
        wait(for: [expect], timeout: 1.0)

    }

}
