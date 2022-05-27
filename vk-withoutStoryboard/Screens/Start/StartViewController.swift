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

    private let loadingView: LoadingView = {
        let view = LoadingView(.blue)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        choiceScreen()
    }

    // MARK: - Setting UI Method
    /// Настройка UI.
    private func setupUI() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Private Methods
    private func choiceScreen() {
        Task {
            let controller: UIViewController
            loadingView.animation(.on)
            do {
                let tokenIsValid = try await provider.requestCheckTokenAsync()
                if !tokenIsValid {
                    throw MyError.tokenNotValid
                }
                controller  = TabBarViewController()
            } catch {
                controller  = LoginViewController()
                print(error)
            }
            self.loadingView.animation(.off)
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
}
