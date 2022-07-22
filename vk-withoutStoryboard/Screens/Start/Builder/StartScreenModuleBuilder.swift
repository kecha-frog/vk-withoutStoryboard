//
//  StartScreenModuleBuilder.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 22.07.2022.
//

import UIKit

class StartScreenModuleBuilder {
    
    // MARK: - Static Methods

    static func startScreenBuild() -> (UIViewController & StartViewInput) {
        let interactor = StartInteractor()
        let router = StartRouter()
        let presenter = StartPresenter(interactor, router)

        let viewController = StartViewController(presenter: presenter)

        router.viewController = viewController
        presenter.viewInput = viewController

        return viewController
    }
}
