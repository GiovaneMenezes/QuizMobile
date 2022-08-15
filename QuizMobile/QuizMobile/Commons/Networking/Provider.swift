//
//  Provider.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

typealias RequestCompletionResult = (_ data: Data?, _ response: URLResponse?, _ error: RequestError?) -> Void

protocol ProviderProtocol {
    associatedtype T: Router
    func request(_ router: T, _ queue: OperationQueue?, completion: @escaping RequestCompletionResult)
}

class Provider<T: Router>: ProviderProtocol {
    
    let requester: Requester
    
    init(_ requester: Requester = Requester()) {
        self.requester = requester
    }
    
    func request(_ router: T, _ queue: OperationQueue?, completion: @escaping RequestCompletionResult) {
        let request =  RequestComposer().compose(router)
        requester.perform(request, queue, completion: completion)
    }
}
