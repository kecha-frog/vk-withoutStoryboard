//
//  StartViewController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 07.03.2022.
//

import UIKit

// MARK: Controller
/// Стартовый экран.
///
///Проверяется работоспособность токена.
class StartViewController: UIViewController {
    /// Сервисный слой.
    private let service: StartViewControllerService =  StartViewControllerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //service.authInFirebase()
    }
    
    /// Настройка UI.
    private func setupUI(){
        // Анимация загрузки
        let loadView: LoadingView = LoadingView(.blue)
        loadView.animationLoad(.on)
        view = loadView
        
        service.fetchApiCheckToken { result in
            // Если токен не валидный то перейдёт на контроллер логина
            let controller:UIViewController = result ? TabBarViewController() : LoginViewController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
}
