//
//  UIViewControllerExtensions.swift
//  TableViewPaginationSample
//
//  Created by 松島勇貴 on 2020/03/24.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, description: String, buttonTitle: String = "OK") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}
