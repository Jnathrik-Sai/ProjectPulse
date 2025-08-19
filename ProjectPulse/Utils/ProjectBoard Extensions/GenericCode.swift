//
//  GenericCode.swift
//  Trello
//
//  Created by aj sai on 04/08/25.
//

import Foundation
import SwiftUI

func safelyAssign<T>(_ binding: Binding<T>, to value: T) {
    DispatchQueue.main.async {
        binding.wrappedValue = value
    }
}
