//
//  ContentView.swift
//  AppAuthDemo
//
//

import SwiftUI
import SwiftData
import AppAuthSwift

struct ContentView: View {
    @StateObject private var viewModel:ContentViewModel = ContentViewModel()
    @State var showPopOver: Bool = false
    var body: some View {
        Button("Show Menu") {
            showPopOver = true
                }
                .fullScreenCover(isPresented: $showPopOver) {
                    if let url = viewModel.loginURL.loginURL {
                        AuthLoginView(url: url)
                        .onOpenURL { url in
                            showPopOver = false
                            viewModel.handleRedirection(url:url)
                        }
                    }
                }
    }
}

#Preview {
    ContentView()
}
