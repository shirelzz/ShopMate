//
//  CustomDialog.swift
//  ShopMate
//
//  Created by שיראל זכריה on 15/01/2024.
//

import SwiftUI

struct CustomDialog: View {
    @Binding var isActive: Bool
    @Binding var item: ShoppingItem
    @State private var inputText = ""
    @State private var formattedText: AttributedString = AttributedString("")

    let title: String
//    let message: String
    let buttonTitle: String
//    let action: () -> ()
    @State private var offset: CGFloat = 1000

    var body: some View {

        ZStack {
            Color(.black)
                .opacity(0.4)
                .onTapGesture {
                    close()
                }

            VStack(spacing: 10)  {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()
                    .foregroundStyle(.gray)
                
                VStack {
                    TextField("Enter text", text: $inputText)
                        .padding()
                        .onChange(of: inputText) { _ in
                            updateFormattedText()
                        }
                    
                    ScrollView {
                        Text(formattedText)
                            .padding()
                            .onTapGesture {
                                // Handle tap on formatted text
                                openURLsInText()
                            }
                    }
                }
                .onAppear {
                    inputText = item.notes
                    // Initial formatting
                    updateFormattedText()
                }
                
//                // Text input field
//                TextField("Enter text", text: $inputText)
//                    .padding()
//                    .onAppear(perform: {
//                        inputText = item.notes
//                    })
//                    .foregroundStyle(.primary)
                
                Button {
                    action()
                    close()
                } label: {
                    
                    Text(buttonTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
//                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .frame(height: 50)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topTrailing) {
                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .tint(.black)
                .padding()
            }
            .shadow(radius: 20)
            .padding(20) //30
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
//                    offset = UIScreen.main.bounds.height / 4
                    offset = 0
                }
            }

        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)  // For full-screen coverage
    }
    
    func action() {
        
    }

    func close() {
        ShoppingList.shared.updateNotes(item: item, notes: inputText)
        withAnimation(.spring()) {
            offset = 1000
            isActive = false
        }
    }
    
    func parseNSAttributedString(from text: String) -> NSAttributedString {
        guard let data = text.data(using: .utf8) else {
            return NSAttributedString(string: text)
        }

        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )

            return attributedString
        } catch {
            return NSAttributedString(string: text)
        }
    }
    
    func removeNonLinkAttributes(from nsAttributedString: NSAttributedString) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: nsAttributedString)
        
        mutableAttributedString.enumerateAttributes(in: NSRange(location: 0, length: mutableAttributedString.length), options: []) { attributes, range, _ in
            let containsLink = attributes[.link] != nil
            if !containsLink {
                mutableAttributedString.removeAttribute(.link, range: range)
            }
        }
        
        return NSAttributedString(attributedString: mutableAttributedString)
    }
    
    func updateFormattedText() {
        let nsAttributedString = parseNSAttributedString(from: inputText)
        let filteredAttributes = removeNonLinkAttributes(from: nsAttributedString)
        formattedText = AttributedString(filteredAttributes)
    }
    
//    func updateFormattedText() {
//        formattedText = parseAttributedString(from: inputText)
//    }
        
        func parseAttributedString(from text: String) -> AttributedString {
            guard let data = text.data(using: .utf8) else {
                return AttributedString(text)
            }

            do {
                let attributedString = try NSAttributedString(
                    data: data,
                    options: [
                        .documentType: NSAttributedString.DocumentType.html,
                        .characterEncoding: String.Encoding.utf8.rawValue
                    ],
                    documentAttributes: nil
                )

                return AttributedString(attributedString)
            } catch {
                return AttributedString(text)
            }
        }

    func openURLsInText() {
        // Create a data detector to identify URLs in the text
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        // Find all URLs in the input text
        let matches = detector?.matches(in: inputText, options: [], range: NSRange(location: 0, length: inputText.utf16.count)) ?? []
        
        // Handle each URL (for simplicity, just print them to the console)
        for match in matches {
            if let url = match.url {
                print("Tapped on URL: \(url)")
                
                // Perform your desired action with the URL, e.g., open it in Safari
                UIApplication.shared.open(url)
            }
        }
    }

}

//struct CustomDialog_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomDialog(isActive: .constant(true), item: $ShoppingItem(), title: "Details", buttonTitle: "Save", action: {})
//    }
//}

