//
//  CustomTabBar.swift
//  ShopMate
//
//  Created by שיראל זכריה on 17/01/2024.
//

import Foundation
import SwiftUI

enum Tab: String, CaseIterable {
    
    case home = "house" // or case cart
    case favorites = "heart"
    case settings = "gear"
    
    var tabName: String {
        switch self {
            
        case .favorites:
            return "Favorites"
            
        case .home:
            return "Home"
            
        case .settings:
            return "Settings"
        
        }
    }
        
}

struct CustomTabView: View { //TabView
    
    @State private var currentTab: Tab = .home
    @Namespace var animation
    
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        TabView(selection: $currentTab) {
            
            ContentView()
                .tag(Tab.home)

            FavoritesView()
                .tag(Tab.favorites)

            SettingsView()
                .tag(Tab.settings)

//                           ContentView()
//                               .navigationBarHidden(true)
//                               .navigationBarBackButtonHidden(true)
//                       }
//                       .tag(Tab.home)
//
//                       NavigationView {
//                           FavoritesView()
//                               .navigationBarHidden(true)
//                               .navigationBarBackButtonHidden(true)
//                       }
//                       .tag(Tab.favorites)
//
//                       NavigationView {
//                           SettingsView()
//                               .navigationBarHidden(true)
//                               .navigationBarBackButtonHidden(true)
//                       }
//                       .tag(Tab.settings)
            
        }
        .overlay {
            
            HStack(alignment: .bottom , spacing: 0,
             content: {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    tabButton(tab: tab)
                }
                .padding(.vertical)
                .padding(.bottom, getSafeArea().bottom == 0 ? 5 : getSafeArea().bottom - 15)
                .background(.white)

            })
        }
        .ignoresSafeArea(.all, edges: .bottom)
       
    }
    
    func tabButton(tab: Tab) -> some View {
        
        GeometryReader { proxy in
            
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }, label: {
                VStack(spacing: 0, content: {
                    Image(systemName: currentTab == tab && currentTab.rawValue != "gear" ? tab.rawValue + ".fill" : tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(currentTab == tab ? .primary : .secondary)
                        .padding(currentTab == tab ? 15 : 0)
                        .background(
                            ZStack{
                                if currentTab == tab {
                                    MaterialEffect(style: .light)
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                    
                                    Text(tab.tabName).foregroundStyle(.primary)
                                        .font(.footnote)
                                        .padding(.top, 50)
                                }
                            })
                        .contentShape(Rectangle())
                        .offset(y: currentTab == tab ? -35 : 0)
                    
                })
            })
        }
        .frame(height: 25)
        
    }


}

struct MaterialEffect: UIViewRepresentable {
    var style:  UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

#Preview {
    CustomTabView()
}
