//
//  UIViewController+Extension.swift
//  JavaScript
//
//  Created by Saurabh Gupta on 03/09/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorToast(message : String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.layer.cornerRadius = 15

        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            alert.dismiss(animated: true)
        }
    }
}
