//
//  LoginViewController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 25.02.2022.
//

import UIKit
import WebKit

///  логин контроллер
class LoginViewController: UIViewController {
    let logoImageView: UIImageView = {
        let image = UIImage(named: "vkLogo")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .tertiarySystemBackground
        button.tintColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        button.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        return button
    }()
    
    let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: webConfiguration)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let service = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// настройка контроллера
    private func setupUI(){
        view.backgroundColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
    
    @objc private  func actionButton(){
        runWebView()
    }
}
