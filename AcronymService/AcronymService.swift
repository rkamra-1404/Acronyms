//
//  Service.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation

protocol AcronymServiceProtocol {
    func fetchAcronyms(for query: String, completion: @escaping (Result<[AcronymsData], NetworkError>) -> Void)
}

class AcronymService : AcronymServiceProtocol {
    let networkClient: NetworkClientProtocol
    
    init(client: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = client
    }
    
    func fetchAcronyms(for query: String, completion: @escaping (Result<[AcronymsData], NetworkError>) -> Void) {
        let request = GetAcronymRequest(query: query)
        networkClient.send(request, completion: completion)
    }
}
