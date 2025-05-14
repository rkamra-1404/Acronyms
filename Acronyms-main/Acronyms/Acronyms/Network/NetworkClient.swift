//
//  NetworkClient.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation
import UIKit

protocol Request {
    associatedtype ResponseType: Decodable
    func build() -> URLRequest
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case noData
    case decodingError(Error)
}

protocol NetworkClientProtocol {
    func send<T: Request>(_ request: T, completion: @escaping (Result<T.ResponseType, NetworkError>) -> Void)
    func get<T: Request>(_ request: T) async throws -> T.ResponseType
}
class NetworkClient : NetworkClientProtocol {
    private let session = URLSession.shared

    func send<T: Request>(_ request: T, completion: @escaping (Result<T.ResponseType, NetworkError>) -> Void) {
        let urlRequest = request.build()

        session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                return completion(.failure(.requestFailed(error)))
            }
            guard let data = data else {
                return completion(.failure(.noData))
            }

            do {
                let responseObject = try JSONDecoder().decode(T.ResponseType.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

    func get<T: Request>(_ request: T) async throws -> T.ResponseType {
        let urlRequest = request.build()
        let (data, _) = try await session.data(for: urlRequest)
        return try JSONDecoder().decode(T.ResponseType.self, from: data)
    }
}
