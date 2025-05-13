//
//  GetAcronymRequest.swift
//  Acronyms
//
//  Created by r0k06op on 5/12/25.
//

import Foundation


struct GetAcronymRequest: Request {
    typealias ResponseType = [AcronymsData]

    private let query: String

    init(query: String) {
        self.query = query
    }

    func build() -> URLRequest {
        var components = URLComponents(string: "https://www.nactem.ac.uk/software/acromine/dictionary.py")!
        components.queryItems = [URLQueryItem(name: "sf", value: query)]
        let url = components.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

extension GetAcronymRequest: Codable {}
