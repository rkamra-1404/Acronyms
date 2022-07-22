//
//  Request.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation

protocol UrlRequestProviderProtocol {
    var urlRequest : URLRequest? {get}
}
enum RequestProvider : UrlRequestProviderProtocol {
    case acronyms(inputString: String)
    
    private var url : URL? {
        switch self {
        case .acronyms(let inputString):
            let urlString = "http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=\(inputString)"
            let acronymUrl = URL.init(string: urlString)
            return acronymUrl
        }
    }
    var urlRequest : URLRequest? {
        guard let urlForRequest = self.url else {
            return nil
        }
        switch self {
        case .acronyms(_):
            return URLRequest.init(url: urlForRequest)
        }
    }
    
}
