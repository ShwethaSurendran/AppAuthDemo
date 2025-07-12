//
//  WebView.swift
//  AppAuthDemo
//
//

import Foundation
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    @ObservedObject var webViewModel: WebViewModel

    let webView:WKWebView
    
    init(url:String) {
        webView = WKWebView()
        webViewModel = WebViewModel(url: url)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, webViewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        loadURL()
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    func loadURL() {
        webView.load(URLRequest(url: URL(string: webViewModel.url)!))
    }
    
}
