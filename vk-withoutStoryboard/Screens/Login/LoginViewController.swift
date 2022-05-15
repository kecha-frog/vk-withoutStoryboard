//
//  LoginViewController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 25.02.2022.
//

import UIKit
import WebKit

/// Экран авторизации пользователя.
class LoginViewController: UIViewController {
    // MARK: Public properties
    let logoImageView: UIImageView = {
        let image: UIImage? = UIImage(named: "vkLogo")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loginButton: UIButton = {
        let button: UIButton  = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .tertiarySystemBackground
        button.tintColor = .vkColor
        button.addTarget(LoginViewController.self, action: #selector(loginButtonActions), for: .touchUpInside)
        return button
    }()
    
    let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: webConfiguration)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Сервисный слой.
    let service: LoginService = LoginService()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        webView.navigationDelegate = self
    }
    
    // MARK: Setting UI
    /// Настройка UI.
    private func setupUI(){
        view.backgroundColor = .vkColor
        
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: Actions
    /// Action loginButton.
    ///
    /// Запуск WebView с страницей логина  VK.
    @objc private  func loginButtonActions(){
        runWebView()
    }
}
