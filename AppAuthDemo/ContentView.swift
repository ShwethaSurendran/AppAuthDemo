//
//  ContentView.swift
//  AppAuthDemo
//
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel:ContentViewModel = ContentViewModel()
    @State var showPopOver: Bool = false
    var body: some View {
        Button("Show Menu") {
            showPopOver = true
                }
                .fullScreenCover(isPresented: $showPopOver) {
                    AuthLoginView(dismissPopUp: $showPopOver,
                                  loginURL: viewModel.loginURL.loginURL )
                    .onOpenURL { url in
                        showPopOver = false
                        viewModel.handleRedirection(url:url)
                    }
                }
    }
}

#Preview {
    ContentView()
}
