//
//  Observable.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

class Observable<T> {
    
    private var _value: T?
    
    var didChange: ((T) -> Void)?
    
    var value: T {
        set {
            _value = newValue
            didChange?(newValue)
        }
        get {
            guard let value = _value else { fatalError("Unexpected value access!") }
            return value
        }
    }
    
    init(_ value: T) {
        _value = value
    }
    
    deinit {
        _value  = nil
        didChange = nil
    }
}
