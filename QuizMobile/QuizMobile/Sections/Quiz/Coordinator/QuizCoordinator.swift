//
//  QuizCoordinator.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 07/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import UIKit

class QuizCoordinator: Coordinator {
    
    typealias V = QuizViewController
    
    var view: QuizViewController?
    
    var navigation: UINavigationController?
    
    func start() -> QuizViewController {
        let viewModel = QuizViewModel()
        let viewController = QuizViewController(viewModel: viewModel)
        self.view = viewController
        return viewController
    }
    
    func stop() {
        view = nil
        navigation = nil
    }
}
