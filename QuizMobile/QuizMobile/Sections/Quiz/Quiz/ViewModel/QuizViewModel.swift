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
    var timer: CountdownClock?
    
    var playObservable  = Observable<Bool>(false)
    var questionObservable = Observable<RequestState>(.initialized)
    var timerObservable = Observable<ClockState>(.counting(seconds: 300))
    var winObservable = Observable<Bool>(false)
    var answersObservable = Observable<Bool>(true)
    
    var questionModel: Question?
    var answers = [String]()
    
    let defaultTimer = 300
    
    init(service: QuizService) {
        self.service = service
        setUpTimer()
    }
    
    func setUpTimer() {
        self.timer = CountdownClock(seconds: defaultTimer, onTimeUpdate: { [weak self] state in
            guard let self = self else { return }
            self.timerObservable.value = state
        })
    }
    
    var score: String {
        return String(format: "%02d/%02d", numberOfHits, numberOfQuestions)
    }
    
    var title: String {
        return questionModel?.question ?? ""
    }
    
    var numberOfHits: Int {
        return answers.count
    }
    
    var numberOfQuestions: Int {
        guard let model = questionModel else { return 0 }
        return model.answer.count
    }
    
    func getNewQuestion() {
        reset()
        fetchQustion()
    }
    
    func actionButtonDidTap() {
        if playObservable.value {
            getNewQuestion()
            timer?.stop()
        } else {
            play()
            timer?.start()
        }
    }
    
    func reset() {
        questionModel = nil
        answers = []
        questionObservable.value = .initialized
        answersObservable.value = true
    }
    
    func play() {
        if questionModel != nil {
            playObservable.value = true
        }
    }
    
    func answerTextDidUpdate(string: String) {
        if validateAnswer(answer: string) {
            answers.append(string)
            answersObservable.value = true
        }
    }
    
    func validateAnswer(answer: String) -> Bool {
        guard let questionModel = questionModel else { return false }
        return questionModel.answer.contains(answer) && !answers.contains(answer)
    }
    
    func timeUpMessage() -> String {
        return "Sorry, time is up! You got \(numberOfHits) out of \(numberOfQuestions) answers."
    }
    
    func fetchQustion() {
        questionObservable.value = .loading
        playObservable.value = false
        service.fetchQuestion(1) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let question):
                    self.questionModel = question
                    self.questionObservable.value = .loaded
                    self.timerObservable.value = .counting(seconds: self.defaultTimer)
                case .failure(let error):
                    self.questionObservable.value = .error(error)
                }
            }
        }
    }
}
