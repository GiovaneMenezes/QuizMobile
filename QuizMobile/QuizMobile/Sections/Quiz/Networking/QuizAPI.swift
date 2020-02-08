//
//  QuizAPI.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

enum QuizAPI {
    case question(Int)
}

extension QuizAPI: Router {
    var path: String {
        switch self {
        case .question(let index):
            return "/quiz/\(index)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .question:
            return .get
        }
    }
    
    var task: Task {
        return .requestPlain
    }
}
