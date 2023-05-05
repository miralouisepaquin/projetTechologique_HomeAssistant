//
//  LanguageManager.swift
//  MySchoolAssistant
//
//  Created by Mira Paquin on 2023-05-04.
//

import UIKit
extension String {

    var localized: String {
        let lang = currentLanguage()
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    //Remove here and add these in utilities class
    func saveLanguage(_ lang: String) {
        UserDefaults.standard.set(lang, forKey: "Locale")
        UserDefaults.standard.synchronize()
    }

    func currentLanguage() -> String {
        return UserDefaults.standard.string(forKey: "Locale") ?? ""
    }
}

enum Language: String {
    case english = "English"
    case français = "Français"
}

class ViewController: UIViewController {
    var language = Language.english

    override func viewDidLoad() {
        super.viewDidLoad()

        //Initial Setup
        String().saveLanguage("en")
        languageLabel.text = "hello".localized
        languageButton.setTitle(language.rawValue, for: .normal)
    }

    func updateLanguage() {
        if language == .english {
            String().saveLanguage("fr")
            language = .français
        } else {
            String().saveLanguage("en")
            language = .english
        }

        languageLabel.text = "hello".localized
        languageButton.setTitle(language.rawValue, for: .normal)
    }

    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!

    @IBAction func changeLanguageButtonTapped(_ sender: UIButton) {
        updateLanguage()
    }
}


