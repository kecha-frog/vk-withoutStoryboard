//
//  LoginPresenter.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 22.07.2022.
//

import UIKit

protocol LoginViewInput {
    func loadWebView(_ request: URLRequest)
}

protocol LoginViewOutput {
    func prepareDataForLoadWebView()
    func saveToken(_ fragmant: String)
    func openMainScreen()
}

class LoginPresenter: LoginViewOutput {
    // MARK: - Public Properties

    weak var viewInput: (UIViewController & LoginViewInput)?

    // MARK: - Private Properties

    private let interactor: LoginInteractorInput
    private let router: LoginRouterInput

    // MARK: - Initialization

    init(_ interactor: LoginInteractorInput, _ router: LoginRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Public Methods
    
    func prepareDataForLoadWebView() {
        guard let request = interactor.getUrlRequest() else { return }
        
        viewInput?.loadWebView(request)
    }

    func saveToken(_ fragmant: String) {
        interactor.saveToken(fragmant)
    }

    func openMainScreen() {
        router.openMainScreen()
    }
}
