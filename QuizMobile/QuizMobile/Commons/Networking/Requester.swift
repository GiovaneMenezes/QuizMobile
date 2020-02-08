//
//  Requester.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

class Requester {
    
    weak var sessionDelegate: URLSessionDelegate?
    var executor: RequesterExecutorProtocol
    
    var sessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        if #available(iOS 11.0, *)  {
            configuration.waitsForConnectivity = false
        }
        return configuration
    }
    
    init() {
        self.executor = RequesterExecutor()
    }
    
    func perform(_ request: URLRequest, _ queue: OperationQueue?, completion: @escaping RequestCompletionResult) {
        let urlSession  = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: queue)
        executor.execute(request: request, in: urlSession, completion: completion)
    }
}
