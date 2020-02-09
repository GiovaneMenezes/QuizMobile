//
//  RequesterExecutor.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

protocol RequesterExecutorProtocol {
    func execute(request: URLRequest, in session: URLSession, completion: @escaping RequestCompletionResult)
}

class RequesterExecutor: RequesterExecutorProtocol {
    
    func execute(request: URLRequest, in session: URLSession, completion: @escaping RequestCompletionResult) {
        session.dataTask(with: request) { data, response, error in
            self.debugResponse(request, data, response, error)
            if let error = error {
                completion(data, response, RequestError.network(error))
            } else {
                completion(data, response, nil)
            }
        }.resume()
        session.finishTasksAndInvalidate()
    }
    
    func debugResponse(_ request: URLRequest, _ responseData: Data?, _ response: URLResponse?, _ error: Error?) {
        print("🚀 - Request")
        print("🚀 - URL: \(request.url?.absoluteString ?? "")")
        print("🚀 - Method: \(request.httpMethod ?? "")")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("\n💁‍♂️ - Response")
            print("💁‍♂️ - Code: \(httpResponse.statusCode)")
            if let bodyData = responseData, let body  = String(data: bodyData, encoding: .utf8) {
                print("💁‍♂️ - Body: \(body)")
            }
        }
    }
}
