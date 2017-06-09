//
//  AlertManager.swift
//  Blocks
//
//  Created by Volodya on 6/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

protocol AlertShowable {
    func showAlert(in viewController: UIViewController,
              title: String,
              message: String,
              okActionTitle: String,
              cancelActionTitle: String,
              okActionCompletion: @escaping () -> ())
}

// MARK: - Default implementation

extension AlertShowable {
    func showAlert(in viewController: UIViewController,
              title: String,
              message: String,
              okActionTitle: String,
              cancelActionTitle: String,
              okActionCompletion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .destructive) { (action) in
            okActionCompletion()
        }
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        // TODO: - Investigate what is better alert type
        alert.addAction(okAction)
        // alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
