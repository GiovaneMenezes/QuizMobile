//
//  Router.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Task {
    case requestPlain
}

protocol Router {
    var host: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
}

extension Router  {
    var host: URL  {
        guard let url = URL(string: Environment.host) else {
            fatalError("Something weird happened.")
        }
        return url
    }
}
