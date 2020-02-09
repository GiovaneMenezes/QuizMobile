//
//  RequestState.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

enum RequestState {
    case initialized
    case loading
    case loaded
    case error(Error)
}
