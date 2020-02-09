//
//  URL+Router.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

extension URL {
    init<T: Router>(router: T) {
        if router.path.isEmpty {
            self = router.host
        } else {
            self = router.host.appendingPathComponent(router.path)
        }
    }
}
