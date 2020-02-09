//
//  LoadingView.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 09/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    init(with frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed(LoadingView.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
