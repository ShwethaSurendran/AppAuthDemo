//
//  WebViewModel.swift
//  AppAuthDemo
//
//

import Foundation

class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false

    var url: String

    init(url: String) {
        self.url = url
    }
}
