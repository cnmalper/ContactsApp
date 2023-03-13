//
//  Common.swift
//  ContactsApp
//
//  Created by Alper Canımoğlu on 6.01.2023.
//

import Foundation
import UIKit

class Common {
    
    class func showAlert(errorTitle: String, errorMessage: String, vc: UIViewController) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        let okButon = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButon)
        vc.present(alert, animated: true)
    }
    
}



