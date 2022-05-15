//
//  LoginViewController+WebView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 06.04.2022.
//

import UIKit
import WebKit

extension LoginViewController: WKNavigationDelegate{
    /// Запуск WebView.
    func runWebView() {
        // удаление лого и кнопки
        logoImageView.removeFromSuperview()
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
        var urlComponents: URLComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem.init(name: "client_id", value: "8088608"),
            URLQueryItem.init(name: "display", value: "mobile"),
            URLQueryItem.init(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem.init(name: "scope", value: "offline, friends, photos, groups, wall"),
            URLQueryItem.init(name: "response_type", value: "token")
        ]
        
        guard let url = urlComponents.url else { return }
        // Загрузка страницы
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void){
        guard let url:URL = navigationResponse.response.url, url.path == "/blank.html",
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
        if let token: String = params["access_token"], let id: String = params["user_id"]{
            Keychain.standart.set(token, key: .token)
            Keychain.standart.set(id, key: .id)
            
            // service.firebaseAutorizedId(id)
        }
        
        // Переход на контроллер
        let controller: TabBarViewController = TabBarViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}
