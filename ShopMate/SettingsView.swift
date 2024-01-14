//
//  SettingsView.swift
//  My Orders
//
//  Created by שיראל זכריה on 26/11/2023.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        
        NavigationStack{
            
            List{
                
                Section(header: Text("Personal Information")) {
                    
                    NavigationLink(destination: AccountView()) {
                        Label("Account", systemImage: "person")
                    }
                    
                }

            }
            
            
            
            AdBannerView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                .frame(height: 50)
                .background(Color.white)
            // test: ca-app-pub-3940256099942544/2934735716
            
        }
        
    }
    
    
    private func updateAppearance() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        if darkModeOn {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
}

extension String {
    var localized: LocalizedStringKey {
        return LocalizedStringKey(self)
    }
}

#Preview {
    SettingsView()
}
