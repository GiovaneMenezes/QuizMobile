//
//  StatusValidator.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

enum ResponseStatus {
    case success
    case failure
    case unknow
}

struct StatusValidator {
    
    static func validate(urlResponse: URLResponse?) -> ResponseStatus {
        guard let httpResponse = urlResponse as?  HTTPURLResponse else { return .unknow }
        switch httpResponse.statusCode {
        case 200...299:
            return .success
        default:
            return .failure
        }
    }
}
