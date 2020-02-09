//
//  QuizViewModelTests.swift
//  QuizMobileTests
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import XCTest

@testable import QuizMobile

class QuizViewModelTests: XCTestCase {
    
    var viewModel: QuizViewModel!
    var service: QuizService!
    var executor: MockRequestExecutor!
    
    override func setUp() {
        super.setUp()
        executor = MockRequestExecutor()
        service = QuizService()
        service.provider.requester.executor = executor
        viewModel = QuizViewModel(service: service)
    }
    
    func testAnswerTestDidUpdateWithValidString() {
        viewModel.questionModel = Question(question: "Is this a test?", answer: ["yes", "no", "maybe"])
        var answerObservableWasCalled = false
        
        viewModel.answersObservable.didChange = { _ in
            answerObservableWasCalled = true
        }
        
        XCTAssertEqual(self.viewModel.numberOfHits, 0, "should return 0 in the empty state")
        viewModel.answerTextDidUpdate(string: viewModel.questionModel!.answer.first!)
        XCTAssertEqual(self.viewModel.numberOfHits, 1, "should update the number of hits")
        XCTAssert(answerObservableWasCalled, "should update answerObservable status")
    }
    
    func testAnswerTestDidUpdateWithInvalidString() {
        viewModel.questionModel = Question(question: "Is this a test?", answer: ["yes", "no", "maybe"])
        
        viewModel.answersObservable.didChange = { _ in
            XCTFail("should not update answer observable")
        }
        
        XCTAssertEqual(self.viewModel.numberOfHits, 0, "should return 0 in the empty state")
        viewModel.answerTextDidUpdate(string: "potato")
        XCTAssertEqual(self.viewModel.numberOfHits, 0, "should not update the number of hits")
    }
    
    func testDuplicatedTextInput() {
        viewModel.questionModel = Question(question: "Is this a test?", answer: ["yes", "no", "maybe"])
        viewModel.answers.append(viewModel.questionModel!.answer.first!)
        
        viewModel.answersObservable.didChange = { _ in
            XCTFail("should not update answer observable")
        }
        
        XCTAssertEqual(self.viewModel.numberOfHits, 1, "should have only 1 hit")
        viewModel.answerTextDidUpdate(string: viewModel.questionModel!.answer.first!)
        XCTAssertEqual(self.viewModel.numberOfHits, 1, "should keep the 1 hit")
    }
    
    func testPlayWithFilledQuestionModel() {
        viewModel.questionModel = Question(question: "Is this a test?", answer: ["yes", "no", "maybe"])
        var playObservableWasUpdated = false
        
        viewModel.playObservable.didChange = { isPlaying in
            playObservableWasUpdated = true
            XCTAssert(isPlaying, "should be set true")
        }
        
        viewModel.play()
        XCTAssert(playObservableWasUpdated, "should update answerObservable status")
    }
    
    func testPlayWithEmptyQuestionModel() {
        viewModel.playObservable.didChange = { isPlaying in
            XCTFail("should not update playObservable")
        }
        
        viewModel.play()
    }
    
    func testReset() {
        viewModel.questionModel = Question(question: "Is this a test?", answer: ["yes", "no", "maybe"])
        viewModel.answers = ["yes", "no"]
        
        var answersObservableWasUpdated = false
        var questionObservableWasUpdated = false
        
        viewModel.answersObservable.didChange = { _ in
            answersObservableWasUpdated = true
        }
        
        viewModel.questionObservable.didChange = { _ in
            questionObservableWasUpdated = true
        }
        
        XCTAssertGreaterThan(viewModel.numberOfHits, 0, "should be populated before test")
        XCTAssertGreaterThan(viewModel.numberOfQuestions, 0,  "should be populated before test")
        viewModel.reset()
        XCTAssertEqual(viewModel.numberOfHits, 0, "should be clean")
        XCTAssertEqual(viewModel.numberOfQuestions, 0,  "should be clean")
        XCTAssert(answersObservableWasUpdated, "should update answersObservable")
        XCTAssert(questionObservableWasUpdated, "should update answersObservable")
    }
    
    func testActionButtonTappedWhenPlaying() {
        viewModel.playObservable.value = true
        
        viewModel.actionButtonDidTap()
        
        viewModel.playObservable.value = false
    }
    
    func testActionButtonTappedWhenPause() {
        viewModel.playObservable.value = false
        
        viewModel.actionButtonDidTap()
        
        viewModel.playObservable.value = true
    }
    
    func testFetchQuestionSuccessfuly() {
        let expectation = self.expectation(description: "fetch question")
        executor.register("quiz_question_success", forRouter: QuizAPI.question(1))
        viewModel.questionObservable.didChange = { result in
            switch result  {
            case .loaded:
                XCTAssertNotNil(self.viewModel.questionModel, "question should be stored")
                expectation.fulfill()
            case .error(let error):
                XCTFail("Should not receive error, but received \(error.localizedDescription)")
                expectation.fulfill()
            default:
                break
            }
        }
        viewModel.fetchQustion()
        waitForExpectations(timeout: TimeLimit.value, handler: nil)
    }
    
    func testFetchQuestionFailure() {
        let expectation = self.expectation(description: "fetch question")
        executor.register("quiz_question_failure", forRouter: QuizAPI.question(1))
        viewModel.questionObservable.didChange = { result in
            switch result  {
            case .loaded:
                XCTFail("Should not receive success")
                expectation.fulfill()
            case .error:
                XCTAssertNil(self.viewModel.questionModel, "question should not be stored")
                expectation.fulfill()
            default:
                break
            }
        }
        viewModel.fetchQustion()
        waitForExpectations(timeout: TimeLimit.value, handler: nil)
    }
}
