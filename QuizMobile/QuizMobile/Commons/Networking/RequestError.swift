//
//  RequestError.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case invalidResponse
    case invalidURL
    case network(Error)
    case encode(Error)
    case decode(Error)
}

extension RequestError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .network(let error):
            return error.localizedDescription
        case .invalidResponse:
            return "Unexpected response"
        case .encode(let error):
            return "Encode - \(error.localizedDescription)"
        case .decode(let error):
            return "Decode - \(error.localizedDescription)"
        }
    }
}
