//
//  RequestComposer.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

struct RequestComposer {
    func compose<T: Router>(_ router: T) -> URLRequest {
        var request = URLRequest(url: URL(router: router))
        request.httpMethod = router.method.rawValue
        
        switch router.task {
        case .requestPlain:
            return request
        }
    }
}
