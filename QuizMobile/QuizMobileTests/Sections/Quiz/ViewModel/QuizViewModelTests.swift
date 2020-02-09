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
    
    override func setUp() {
        super.setUp()
        service = QuizService()
        viewModel = QuizViewModel(service: service)
    }
    
    func testAnswerTestDidUpdate() {
        
    }
}
