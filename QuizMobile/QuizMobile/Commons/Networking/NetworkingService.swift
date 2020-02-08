//
//  NetworkingService.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

class NetworkingService<T: Router>: NSObject, URLSessionDelegate  {
    private let queue = OperationQueue()
    
    var provider = Provider<T>()
    
    func request<Value: Codable>(_ router: T, dataType: Value.Type,
                                 completion: @escaping (Result<Value, RequestError>, URLResponse?) -> Void) {
        provider.request(router, queue) { data, response, error in
            if let error = error {
                completion(.failure(error), response)
                return
            }
            switch StatusValidator.validate(urlResponse: response) {
            case .success:
                do {
                    let object = try CodableHandler.generateObject(data, dataType: dataType)
                    completion(.success(object), response)
                } catch let error {
                    if let  error = error as? RequestError {
                        completion(.failure(error), response)
                    } else {
                        completion(.failure(RequestError.invalidResponse), response)
                    }
                }
            case .failure, .unknow:
                completion(.failure(.invalidResponse), response)
            }
        }
    }
}
