//
//  MockRequestExecutor.swift
//  QuizMobileTests
//
//  Created by Giovane Silva de Menezes Cavalcante on 09/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation
@testable import QuizMobile

class MockRequestExecutor {
    
    struct Mock {
        let fileName: String
        let statusCode: Int
    }
    
    let bundle: Bundle
    
    init() {
        self.bundle = Bundle(for: type(of: self))
    }
    
    var mocks: [String: Mock] = [:]
    
    func register(_ fileName: String, forRouter router: Router, statusCode: Int = 200) {
        let key = generateKey(path: router.path, method: router.method.rawValue)
        mocks[key] = Mock(fileName: fileName, statusCode: statusCode)
    }
    
    private func generateKey(path: String, method: String) -> String {
        return path + "$" + method
    }
    
    private func onBackgroud(code: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            code()
        }
    }
}

extension MockRequestExecutor: RequesterExecutorProtocol {
    
    func execute(request: URLRequest, in session: URLSession, completion: @escaping RequestCompletionResult) {
        let requestMethod = request.httpMethod ?? HTTPMethod.get.rawValue
        guard let requestPath = request.url?.path,
            let mock = mocks[generateKey(path: requestPath, method: requestMethod)] else {
                completion(nil, nil, RequestError.invalidURL)
                return
        }
        let response = HTTPURLResponse(url: request.url!,
                                       statusCode: mock.statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        onBackgroud {
            guard let filePath = self.bundle.url(forResource: mock.fileName, withExtension: "json"),
                let content = try? Data(contentsOf: filePath) else {
                    completion(nil, response, RequestError.invalidResponse)
                    return
            }
            
            completion(content, response, nil)
        }
    }
}
