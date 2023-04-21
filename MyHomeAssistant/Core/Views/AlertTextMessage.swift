//
//  AlertTextMessage.swift
//  MySchoolAssistant
//
//  Created by EdwImac03 on 2023-03-24.
//

import SwiftUI

struct AlertTextMessage: View {
    var placeHolderMessage: String
    @Binding var alerte: String
    var body: some View {
        TextField(placeHolderMessage, text: $alerte)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.body)
    }
}

struct AlertTextMessage_preview: PreviewProvider {
    static var previews: some View {
        AlertTextMessage(placeHolderMessage: "Hello", alerte: .constant("hello"))
    }
}
