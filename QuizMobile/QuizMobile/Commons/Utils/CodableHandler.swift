//
//  CodableHandler.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

struct CodableHandler {
    static func generateObject<T: Codable>(_ data: Data?, dataType: T.Type) throws -> T {
        guard let data = data else { throw RequestError.invalidResponse }
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(dataType, from: data)
            return object
        } catch let error {
            print("💥 Decode Error 👉 \(dataType): \(error)")
            throw RequestError.decode(error)
        }
    }
    
    static func encode<T: Encodable>(object: T, request: URLRequest) throws -> URLRequest {
        do {
            var request = request
            request.httpBody = try JSONEncoder().encode(object)
            let contentTypeHeader = "Content-Type"
            if request.value(forHTTPHeaderField: contentTypeHeader) == nil {
                request.setValue("application/json", forHTTPHeaderField: contentTypeHeader)
            }
            return request
        } catch let error {
            print("💥 Encode Error 👉 \(error)")
            throw RequestError.encode(error)
        }
    }
}
