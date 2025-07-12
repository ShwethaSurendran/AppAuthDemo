//
//  AuthLoginView.swift
//  AppAuthDemo
//
//

import SwiftUI

struct AuthLoginView: View {
    @StateObject private var viewModel: AuthLoginViewModel
    private let webView: SafariWebView
    @Binding var dismissPopUp: Bool
    
    init(dismissPopUp: Binding<Bool>, loginURL:String) {
        self._viewModel = StateObject(wrappedValue: AuthLoginViewModel())
        webView = SafariWebView(url: loginURL)
        self._dismissPopUp = dismissPopUp
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismissPopUp = !dismissPopUp
                }){
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                }
            }
            webView
        }
    }
}

#Preview {
    AuthLoginView(dismissPopUp: .constant(false), loginURL: "http://www.google.com")
}
