//
//  QuizViewModel.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 07/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

class QuizViewModel {
    var service: QuizService
    
    init(service: QuizService) {
        self.service = service
    }
    
    func fetchQustion() {
        service.fetchQuestion(1) { (response) in
            print(response)
        }
    }
}
