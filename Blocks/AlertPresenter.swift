//
//  AlertManager.swift
//  Blocks
//
//  Created by Volodya on 6/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

protocol AlertPresenter {
    func showAlert(title: String,
                   message: String,
                   okActionTitle: String,
                   cancelActionTitle: String,
                   okActionCompletion: @escaping () -> ())
}

// MARK: - Default implementation

extension AlertPresenter where Self: UIViewController {
    func showAlert(title: String,
                   message: String,
                   okActionTitle: String,
                   cancelActionTitle: String,
                   okActionCompletion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .destructive) { (action) in
            okActionCompletion()
        }
     
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
