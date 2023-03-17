//
//  TextView.swift
//  MyHomeAssistant
//
//  Created by Mira-Louise Paquin on 2023-03-16.
//

import SwiftUI

struct MessageHistoryTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 14.0)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        let myRange = NSMakeRange(uiView.text.count - 1, 0)
        uiView.scrollRangeToVisible(myRange)
    }
}
