//
//  BaseViewController.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 09/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import UIKit

class BaseViewController:  UIViewController {
    var loadingView: LoadingView?
    
    func displayLoading(show: Bool) {
        if show {
            let parentView: UIView = self.navigationController?.view ?? self.view
            let parentBounds = parentView.bounds
            let loadingView = LoadingView(with: parentBounds)
            self.loadingView = loadingView
            parentView.addSubview(loadingView)
        } else {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
