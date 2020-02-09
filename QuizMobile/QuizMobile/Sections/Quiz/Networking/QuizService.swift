//
//  QuizService.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

class QuizService: NetworkingService<QuizAPI> {
    func fetchQuestion(_ index: Int, completion: @escaping (Result<Question, RequestError>) -> Void) {
        request(.question(index), dataType: Question.self) { (result, response) in
            switch result {
            case .success(let question):
                completion(.success(question))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
