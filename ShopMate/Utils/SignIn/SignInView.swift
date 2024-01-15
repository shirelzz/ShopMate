//
//  SignInView.swift
//  My Orders
//
//  Created by שיראל זכריה on 12/12/2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import FirebaseAuth
import _AuthenticationServices_SwiftUI

struct SignInView: View {
        
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authState: AuthState


    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()

                Text("Choose an option:")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                
                GoogleSiginBtn {
                    
                    AuthService.share.signinWithGoogle(presenting: getRootViewController(), authState: authState) { error in
                        // TODO: Handle ERROR
                        if error != nil {
                            Toast.showToast(message: "error signing you in")
                        }
                        else {
                            authState.isAuthenticated = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                
                }
                .frame(minWidth: 0 , maxWidth: .infinity)
                .frame(height: 50)
                .padding()
                .onChange(of: authState.isAuthenticated) { isAuthenticated in
                    if isAuthenticated {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                Text("or")
                    .foregroundColor(.gray)
                    .padding()
                
                Button {
                    AuthService.share.startSignInWithAppleFlow()

                    DispatchQueue.main.async {
                        authState.isAuthenticated = true
                    }
                    
                } label: {
                    AppleButtonView()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .cornerRadius(30)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: 2)
                }
                .onChange(of: authState.isAuthenticated) { isAuthenticated in
                    if isAuthenticated {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                Spacer()
            }
            .navigationTitle("Sign In")
            
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


