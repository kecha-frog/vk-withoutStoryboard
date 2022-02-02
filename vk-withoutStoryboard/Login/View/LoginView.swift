//
//  Login.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 26.01.2022.
//

import UIKit

// делегат
protocol LoginViewDelegate: AnyObject{
    func checkLoginPassword(_ sender: Bool)
}

class LoginView: UIView {
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
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //настройки
        self.setupUI()
        self.setupTextField()
        self.setupButton()
        //  Прописал для удобной проверки
        self.fastEntry()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // делегат
    var delegate: LoginViewDelegate?
    
    func setupUI(){
        
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
        
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: passTextField.bottomAnchor, constant: indentVerticalConstraint),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: indentVerticalConstraint),
            button.leadingAnchor.constraint(equalTo: passTextField.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: passTextField.trailingAnchor),
            button.heightAnchor.constraint(equalTo: passTextField.heightAnchor),
        ])
    }
    
    func setupTextField(){
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
    
    func setupButton(){
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .tertiarySystemBackground
        button.tintColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        button.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
    }
    
    @objc func actionButton(){
        guard loginTextField.text != "" && passTextField.text != "" else{
            return
        }
        
        guard loginTextField.text == "admin" && passTextField.text == "admin" else{
            // делегат
            delegate?.checkLoginPassword(false)
            return
        }
        
        // делегат
        delegate?.checkLoginPassword(true)
    }
    
    
    func fastEntry(){
        loginTextField.text = "admin"
        passTextField.text = "admin"
    }
}
