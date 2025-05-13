//
//  MockService.swift
//  AcronymsTests
//
//  Created by Rahul Kamra on 21/07/22.
//

import Foundation
@testable import Acronyms


class MockAcronymsService: ServiceProtocol {
    
    var isFetchAcronymsCalled = false
    
    func fetchDataToDisplay<T>(queryParam: String, completionHandler: @escaping Handler<T>) where T : Decodable, T : Encodable {
        isFetchAcronymsCalled = true
        let data = StubGenerator().stubAcronyms() as! [T]
        completionHandler(.success(data))
    }
    
    
}

class MockAcronymsFailService: ServiceProtocol {
    
    var isFetchAcronymsCalled = false
    
    func fetchDataToDisplay<T>(queryParam: String, completionHandler: @escaping Handler<T>) where T : Decodable, T : Encodable {
        isFetchAcronymsCalled = true
        completionHandler(.failure(NSError(domain: "Something went wrong", code: 404, userInfo: nil)))
    }
    
    
}
