//
//  URLClickableTextEditor.swift
//  ShopMate
//
//  Created by שיראל זכריה on 16/01/2024.
//

import SwiftUI
import UIKit

struct URLClickableTextView: UIViewRepresentable { //
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = .link
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = context.coordinator
        
        if #available(iOS 15.0, *) {
            textView.overrideUserInterfaceStyle = .light
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Only update the text if the view is not being edited
        if !uiView.isFirstResponder {
            uiView.text = text
        }
        enableLinkDetection(textView: uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: URLClickableTextView

        init(_ parent: URLClickableTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.text = textView.text
            }
        }

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            // Handle URL interaction here if needed
            UIApplication.shared.open(URL)
            return false
        }
    }

    func enableLinkDetection(textView: UITextView) {
        guard !text.isEmpty else {
               return
           }
        
        textView.textStorage.beginEditing()
        let range = NSRange(location: 0, length: textView.textStorage.length)
        textView.textStorage.removeAttribute(.link, range: range)
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: range) ?? []
        for match in matches {
            textView.textStorage.addAttribute(.link, value: match.url!, range: match.range)
        }

        textView.textStorage.endEditing()
    }
}

