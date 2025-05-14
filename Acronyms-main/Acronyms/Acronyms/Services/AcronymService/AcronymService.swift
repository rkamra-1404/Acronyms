//
//  Service.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation

protocol AcronymServiceProtocol {
    func fetchAcronyms(for query: String) async throws -> [AcronymsData]
}

struct AcronymService : AcronymServiceProtocol {
    let networkClient: NetworkClientProtocol
    
    init(client: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = client
    }
    
    func fetchAcronyms(for query: String) async throws -> [AcronymsData] {
        let request = GetAcronymRequest(query: query)
        return try await networkClient.get(request)
    }
}
