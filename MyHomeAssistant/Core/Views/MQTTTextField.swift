//
//  MQTTTextField.swift
//  MySchoolAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//

import SwiftUI

struct MQTTTextField: View {
    var placeHolderMessage: String
    var isDisabled: Bool
    @Binding var message: String
    var body: some View {
        TextField(placeHolderMessage.localized, text: $message)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.body)
            .disableAutocorrection(true)
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.5 : 1.0)
    }
}

struct MQTTTextField_Previews: PreviewProvider {
    static var previews: some View {
        MQTTTextField(placeHolderMessage: "Hello".localized, isDisabled: true, message: .constant("hello"))
    }
}
