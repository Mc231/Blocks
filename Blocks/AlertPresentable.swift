//
//  AlertManager.swift
//  Blocks
//
//  Created by Volodya on 6/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

/// This protocol describes presentation of game alerts
protocol AlertPresentable {
    func present(title: String,
                   message: String,
                   okActionTitle: String,
                   cancelActionTitle: String,
                   okActionCompletion: @escaping () -> Void)
}

// MARK: - Default implementation

extension AlertPresentable where Self: UIViewController {
    func present(title: String,
                   message: String,
                   okActionTitle: String,
                   cancelActionTitle: String,
                   okActionCompletion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .destructive) { (_) in
            okActionCompletion()
        }

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
