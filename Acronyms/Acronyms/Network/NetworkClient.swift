//
//  NetworkClient.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation
import UIKit

protocol NetworkClientProtocol {
    func fetchDataToDisplay<T: Codable>(forRequestType requestType : UrlRequestProviderProtocol, completionHandler : @escaping Handler<T>)
}
class NetworkClient : NetworkClientProtocol {
    private var session = URLSession.shared
    
    func fetchDataToDisplay<T: Codable>(forRequestType requestType : UrlRequestProviderProtocol, completionHandler : @escaping Handler<T>) {
        guard let request = requestType.urlRequest else {
            return
        }
        let task = self.session.dataTask(with: request) { (data, response, error) in
            guard error == nil, let dataObject = data else {
                completionHandler(.failure(error!))
                return
            }
            
            do {
                let result = try JSONDecoder().decode([T].self, from: dataObject) as [T]
                completionHandler(.success(result))
            }
            catch let error {
                completionHandler(.failure(error))
                print(error)
            }
        }
        task.resume()
        
    }
}
