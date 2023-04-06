//
//  ChadPropertyWrapper.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 06/04/23.
//

import SwiftUI
// Custom Property Wrapper of bool type. Used for toggling Secure Field
@propertyWrapper struct EyeState: DynamicProperty {
    @State private var value = true // For loading data after the View is Reloaded
    var wrappedValue: Bool {
        get { // Return The Current Value
            return value
        }
        nonmutating set { // Update the current Value
            value = newValue
        }
    }
}
