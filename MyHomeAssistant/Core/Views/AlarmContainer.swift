//
//  AlarmContainer.swift
//  MySchoolAssistant
//
//  Created by Mira Paquin on 2023-04-20.
//

import SwiftUI

struct AlarmContainer: View {
    var sensor: String
    var isDetected: Bool
    var body: some View {
        HStack {
            Text(sensor)
                .font(.title3)
                .foregroundColor(.white)
                .padding(10)
        }.frame(maxWidth: .infinity)
        .background(isDetected ? Color.red : Color.teal)
    }
}

struct AlarmContainer_Previews: PreviewProvider {
    static var previews: some View {
        AlarmContainer(sensor: "None", isDetected: false)
    }
}
