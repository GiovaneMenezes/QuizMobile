//
//  UITableView+Utils.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        let identifier = cell.identifier
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(of type: T.Type,
                                                 for indexPath: IndexPath,
                                                 configure: ((T) -> Void)? = nil) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath)
        if let cell = cell as? T {
            configure?(cell)
        }
        return cell
    }
}
