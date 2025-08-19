//
//  View+AlertTextField.swift
//  Trello
//
//  Created by aj sai on 25/07/25.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func presentAlertTextField(
        title: String,
        message: String? = nil,
        defaultTextFieldText: String? = nil,
        confirmAction: @escaping (String?) -> ()
    ) {
        
        guard let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController else {
                return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.text = defaultTextFieldText
        }

        alertController.addAction(.init(title: "Cancel", style: .cancel) { _ in
        })

        alertController.addAction(.init(title: "Save", style: .default, handler: { _ in
            let input = alertController.textFields?.first?.text
            confirmAction(input)
        }))

        DispatchQueue.main.async {
            rootVC.present(alertController, animated: true)
        }
    }
}
