//
//  LanguageAppState.swift
//  MySchoolAssistant
//
//  Created by EdwImac03 on 2023-05-05.
//

import Combine
import Foundation

class LanguageAppState: ObservableObject {
    @Published var appLanguage: String = ""

    func setAppLanguage(language: String) {
        appLanguage = language
    }
}
