//
//  BoardFormViewModel.swift
//  ProjectPulse
//
//  Created by aj sai on 04/08/25.
//

import Foundation
import SwiftUI

class ApiUrl {
    static let shared = ApiUrl()
    let baseURL: URL
    
    init(baseURLString: String) {
        self.baseURL = URL(string: baseURLString)!
    }
    
    convenience init() {
        self.init(baseURLString: "https://3c54abd03fe1.ngrok-free.app")
    }
}
