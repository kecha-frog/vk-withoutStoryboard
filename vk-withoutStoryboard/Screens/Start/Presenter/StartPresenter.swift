//
//  StartPresenter.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 22.07.2022.
//

import UIKit

protocol StartViewInput {
    func loadAnimation(_ on: Bool)
}

protocol StartViewOutput {
    func choiceScreen()
}

class StartPresenter: StartViewOutput {
    
    // MARK: - Public Properties

    weak var viewInput: (UIViewController & StartViewInput)?

    // MARK: - Private Properties

    private let interactor: StartInteractorInput
    private let router: StartRouterInput

    // MARK: - Initialization

    init(_ interactor: StartInteractorInput, _ router: StartRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Public Methods

    func choiceScreen() {
        Task { @MainActor in
            viewInput?.loadAnimation(true)
            
            do {
                let tokenIsValid = try await interactor.checkToken()
                if tokenIsValid {
                    router.openMainScreen()
                } else {
                    router.openLoginScreen()
                }
            } catch {
                print(error)
                router.openLoginScreen()
            }
            viewInput?.loadAnimation(false)
        }
    }
}
