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
            let cgRect = self.navigationController?.view.bounds ?? self.view.bounds
            let loadingView = LoadingView(with: cgRect)
            self.loadingView = loadingView
            let parentView: UIView = self.navigationController?.view ?? self.view
            parentView.addSubview(loadingView)
        } else {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
