//
//  ClickableLinkView.swift
//  ShopMate
//
//  Created by שיראל זכריה on 16/01/2024.
//

import SwiftUI

struct ClickableLinkView: View {
    let text: String
    let url: URL

    var body: some View {
        Button(action: {
            // Open the link when tapped
            UIApplication.shared.open(url)
        }) {
            Text(text)
                .foregroundColor(.blue) // Apply desired link styling
                .underline()
        }
    }
    
    func formatText(inputText: String) {
//        var formattedText: Text = Text("")

        // Find URLs in the input text
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: inputText, options: [], range: NSRange(location: 0, length: inputText.utf16.count))

//        formattedText = Text("")
//        for match in matches {
//            // Create ClickableLinkView for each URL
//            let url = match.url!
//            let linkText = inputText[Range(match.range, in: inputText)!]
//            formattedText = formattedText + Text(inputText[Range(formattedText.string.endIndex, in: inputText)!..<match.range.lowerBound]) + ClickableLinkView(text: String(linkText), url: url)
//        }
//
//        formattedText = formattedText + Text(inputText[Range(formattedText.string.endIndex, in: inputText)!..<inputText.endIndex])
    }
}


//#Preview {
//    ClickableLinkView(text: "Link", url: (URL(string: "ab www.google.com") ?? URL(fileURLWithPath: "")))
//}
