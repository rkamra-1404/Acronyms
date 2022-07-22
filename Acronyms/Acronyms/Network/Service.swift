//
//  Service.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation
typealias Handler<T> = (Result<[T], Error>) -> Void

protocol ServiceProtocol {
    func fetchDataToDisplay<T: Codable>(queryParam: String, completionHandler : @escaping Handler<T>)
}
class Service : ServiceProtocol {
    let networkClient: NetworkClientProtocol
    
    init(client: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = client
    }
    
    func fetchDataToDisplay<T: Codable>(queryParam: String, completionHandler: @escaping Handler<T>) {
        let request = RequestProvider.acronyms(inputString: queryParam)
        networkClient.fetchDataToDisplay(forRequestType: request, completionHandler: completionHandler)
    }
}
