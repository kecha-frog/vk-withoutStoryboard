//
//  LoginViewController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 25.02.2022.
//

import UIKit
import WebKit

/// Экран авторизации пользователя.
final class LoginViewController: UIViewController {
    // MARK: - Private properties
    fileprivate let logoImage: UIImageView = {
        let nameImage = "vkLogo"
        let image: UIImage? = UIImage(named: nameImage)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .tertiarySystemBackground
        button.tintColor = .vkColor
        button.addTarget(LoginViewController.self, action: #selector(loginButtonActions), for: .touchUpInside)
        return button
    }()
    
    fileprivate let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: webConfiguration)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Провайдер.
    fileprivate let provider = LoginScreenProvider()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        webView.navigationDelegate = self
    }
    
    // MARK: - Setting UI
    /// Настройка UI.
    private func setupUI() {
        view.backgroundColor = .vkColor
        
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    // MARK: - Actions
    /// Action loginButton.
    ///
    /// Запуск WebView с страницей логина  VK.
    @objc private  func loginButtonActions() {
        runWebView()
    }
}

// MARK: - WebViewDelegate
extension LoginViewController: WKNavigationDelegate {
    // MARK: - Private Methods
    /// Запуск WebView.
    fileprivate func runWebView() {
        // удаление лого и кнопки
        logoImage.removeFromSuperview()
        loginButton.removeFromSuperview()
        
        view.backgroundColor = .white
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // Данные для загрузки страницы
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8088608"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "offline, friends, photos, groups, wall"),
            URLQueryItem(name: "response_type", value: "token")
        ]
        
        guard let url = urlComponents.url else { return }
        // Загрузка страницы
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard let url: URL = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
        
        // Полученные параметры из ответа WebView
        let params: [String: String] = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        // Запись токена и id
        if let token: String = params["access_token"], let id: String = params["user_id"] {
            KeychainLayer.standart.set(token, key: .token)
            KeychainLayer.standart.set(id, key: .id)
            
            // service.firebaseAutorizedId(id)
        }
        
        // Переход на контроллер
        let controller = TabBarViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}
