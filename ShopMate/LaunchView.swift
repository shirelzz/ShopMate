//
//  LaunchView.swift
//  ShopMate
//
//  Created by שיראל זכריה on 14/01/2024.
//

import SwiftUI

struct LaunchView: View {
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        
        let imageName = colorScheme == .dark ? "aesthetic" : "storeLogo"

        Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
    }
}

#Preview {
    LaunchView()
}
