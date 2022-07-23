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
    func viewDidLoadWebView()
    func viewDidSaveToken(_ fragmant: String)
    func viewDidOpenMainScreen()
}

class LoginPresenter{
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
    
    private func getURLRequest() -> URLRequest? {
        return interactor.getUrlRequest()
    }
}

extension LoginPresenter:  LoginViewOutput {
    func viewDidLoadWebView() {
        guard let request = getURLRequest() else { return }
        viewInput?.loadWebView(request)
    }

    func viewDidSaveToken(_ fragmant: String) {
        interactor.saveToken(fragmant)
    }

    func viewDidOpenMainScreen() {
        router.openMainScreen()
    }
}
