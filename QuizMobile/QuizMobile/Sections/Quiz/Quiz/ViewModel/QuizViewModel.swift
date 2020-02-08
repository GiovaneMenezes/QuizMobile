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
    
    var questionObservable = Observable<RequestState>(.initialized)
    var questionModel: Question?
    var answersObservable = Observable<Bool>(true)
    var answers = [String]()
    
    var score: String {
        return "\(numberOfHits)/\(questionModel?.answer.count ?? 0)"
    }
    var title: String {
        return questionModel?.question ?? ""
    }
    var numberOfHits: Int {
        return answers.count
    }
    
    func answerTextDidUpdate(string: String) {
        if validateAnswer(answer: string) && !answers.contains(string) {
            answers.append(string)
            answersObservable.value = true
        }
    }
    
    func validateAnswer(answer: String) -> Bool {
        return questionModel?.answer.contains(answer) ?? false
    }
    
    func fetchQustion() {
        questionObservable.value = .loading
        service.fetchQuestion(1) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let question):
                    self.questionModel = question
                    self.questionObservable.value = .loaded
                case .failure(let error):
                    self.questionObservable.value = .error(error)
                }
            }
        }
    }
}
