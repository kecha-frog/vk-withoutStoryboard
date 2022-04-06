//
//  LoginViewController+WebView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 06.04.2022.
//

import UIKit
import WebKit


extension LoginViewController: WKNavigationDelegate{
    /// настройка вебвью
    func runWebView(){
        logoImageView.removeFromSuperview()
        loginButton.removeFromSuperview()
        
        webView.navigationDelegate = self
        view.backgroundColor = .white
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            .init(name: "client_id", value:"8088608"),
            .init(name: "display", value: "mobile"),
            .init(name: "redirect_uri",value:"https://oauth.vk.com/blank.html"),
            .init(name: "scope", value:"offline, friends, photos, groups"),
            .init(name: "response_type",value:"token"),
        ]
        let myRequest = URLRequest(url: urlComponents.url!)
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void){
        guard let url = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
        
        let params = fragment
            .components(separatedBy: "&")
            .map({$0.components(separatedBy: "=")})
            .reduce([String:String](), { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            })
        
        if let token = params["access_token"], let id = params["user_id"]{
            Keychain.standart.set(token, key: .token)
            Keychain.standart.set(id, key: .id)
            
            service.firebaseAutorizedId(id)
        }
        
        let controller = TabBarViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}
