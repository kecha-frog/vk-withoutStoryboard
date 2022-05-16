//
//  StartViewController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 07.03.2022.
//

import UIKit

/// Стартовый экран.
///
/// Проверяется работоспособность токена.
final class StartViewController: UIViewController {
    // MARK: - Private Properties
    /// Провайдер.
    private let provider = StartScreenProvider()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // service.authInFirebase()
    }
    
    // MARK: - Setting UI
    /// Настройка UI.
    private func setupUI() {
        // Анимация загрузки
        let loadView = LoadingView(.blue)
        loadView.animation(.on)
        view = loadView
        
        provider.fetchApiAsync { result in
            // Если токен не валидный то перейдёт на контроллер логина
            let controller: UIViewController = result ? TabBarViewController() : LoginViewController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
}
