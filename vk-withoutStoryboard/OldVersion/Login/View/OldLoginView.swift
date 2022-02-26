//
//  Login.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 26.01.2022.
//

import UIKit

protocol OldLoginViewDelegate: AnyObject{
    func checkLoginPassword(_ sender: Bool)
}

class OldLoginView: UIView {
    private let imageLogo: UIImageView = {
        let image = UIImage(named: "vkLogo")
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let buttonLogin: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupTextField()
        self.setupButton()
        //  Прописал для удобной проверки
        self.fastEntry()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: OldLoginViewDelegate?
    
    private func setupUI(){
        addSubview(imageLogo)
        NSLayoutConstraint.activate([
            imageLogo.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            imageLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        addSubview(loginTextField)
        let indentVerticalConstraint:CGFloat = 20
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: indentVerticalConstraint),
            loginTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            loginTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            loginTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        addSubview(passTextField)
        NSLayoutConstraint.activate([
            passTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 1),
            passTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor)
        ])
        
        addSubview(buttonLogin)
        NSLayoutConstraint.activate([
            buttonLogin.topAnchor.constraint(equalTo: passTextField.bottomAnchor, constant: indentVerticalConstraint),
            buttonLogin.bottomAnchor.constraint(equalTo: bottomAnchor, constant: indentVerticalConstraint),
            buttonLogin.leadingAnchor.constraint(equalTo: passTextField.leadingAnchor),
            buttonLogin.trailingAnchor.constraint(equalTo: passTextField.trailingAnchor),
            buttonLogin.heightAnchor.constraint(equalTo: passTextField.heightAnchor),
        ])
    }
    
    private func setupTextField(){
        loginTextField.placeholder = "Email или Телефон"
        passTextField.placeholder = "Пароль"
        
        let fontStyle:UIFont = .systemFont(ofSize: 18)
        let backgroundColor:UIColor = .white
        let cornerRadius:CGFloat = 5
        
        loginTextField.font = fontStyle
        loginTextField.backgroundColor = backgroundColor
        loginTextField.layer.cornerRadius = cornerRadius
    
        passTextField.font = fontStyle
        passTextField.backgroundColor = backgroundColor
        passTextField.layer.cornerRadius = cornerRadius
        passTextField.isSecureTextEntry = true
    }
    
    private func setupButton(){
        buttonLogin.setTitle("Войти", for: .normal)
        buttonLogin.layer.cornerRadius = 5
        buttonLogin.backgroundColor = .tertiarySystemBackground
        buttonLogin.tintColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        buttonLogin.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
    }
    
    @objc private func actionButton(){
        guard loginTextField.text != "" && passTextField.text != "" else{
            return
        }
        
        guard loginTextField.text == "admin" && passTextField.text == "admin" else{
            delegate?.checkLoginPassword(false)
            return
        }
        
        UserDefaults.standard.set(false, forKey: "isLogin")
        
        delegate?.checkLoginPassword(true)
    }
    
    private func fastEntry(){
        loginTextField.text = "admin"
        passTextField.text = "admin"
    }
}
