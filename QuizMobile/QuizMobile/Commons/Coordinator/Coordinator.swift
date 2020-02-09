//
//  Coordinator.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 07/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import UIKit

enum Presentation {
    case push(navigation: UINavigationController)
    case present(viewController: UIViewController)
}

protocol Coordinator: AnyObject {
    
    associatedtype V: UIViewController
    
    var view: V? { get set }
    
    var navigation: UINavigationController? { get set }
    
    func start() -> V
    
    func stop()
}

extension Coordinator {
    func start(with presentation: Presentation) {
        switch presentation {
        case .push(let navigation):
            let view = start()
            self.navigation = navigation
            navigation.pushViewController(view, animated: true)
        case .present(let viewController):
            let view = start()
            let navigation = UINavigationController(rootViewController: view)
            self.navigation = navigation
            navigation.modalPresentationStyle = .fullScreen
            viewController.present(navigation, animated: true, completion: nil)
        }
    }
}
