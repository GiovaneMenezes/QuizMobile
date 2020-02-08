//
//  AppCoordinator.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 07/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    typealias V = UINavigationController

    var view: UINavigationController?
    
    var navigation: UINavigationController?
    
    var quizCoordinator: QuizCoordinator?
    
    func start() -> UINavigationController {
        let view = UINavigationController()
        self.view = view
        self.navigation = view
        view.setNavigationBarHidden(true, animated: false)
        let quizCoordinator = QuizCoordinator()
        self.quizCoordinator = quizCoordinator
        view.pushViewController(quizCoordinator.start(), animated: false)
        quizCoordinator.navigation = navigation
        return view
    }
    
    func stop() {
        view = nil
        navigation = nil
    }
}
