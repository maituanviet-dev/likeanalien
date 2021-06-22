//
//  UtilManager.swift
//  DinoGame
//
//  Created by Quynh Nguyen on 6/7/21.
//

import UIKit

class UtilManager: NSObject {
    class func showAlertOK(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        if let vc = UIApplication.shared.windows.first?.rootViewController {
            vc.present(alertView, animated: true, completion: nil)
        }
    }
}
