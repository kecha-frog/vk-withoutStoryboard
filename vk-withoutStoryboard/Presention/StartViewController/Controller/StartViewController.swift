//
//  StartViewController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 07.03.2022.
//

import UIKit
import Firebase

/// стартовый контроллер на котором проверяется токен на работоспособность
class StartViewController: UIViewController {
    private let service =  StartViewControllerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkToken()
    }
    
    private func loadViewChange(){
        let loadView = LoadingView()
        // изменил на цвета стартовой страницы
        loadView.changeToStartPageColor()
        loadView.animationLoad(.on)
        
        view = loadView
    }
    
    /// проверка токена и выбор контроллера исходя из ответа
    private func checkToken(){
        //Анонильная авторизация
        Auth.auth().signInAnonymously()
        
        loadViewChange()
        service.fetchApiCheckToken { result in
            let controller:UIViewController = result ? TabBarViewController() : LoginViewController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
}
