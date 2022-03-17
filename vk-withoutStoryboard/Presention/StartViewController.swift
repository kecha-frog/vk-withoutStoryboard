//
//  StartViewController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 07.03.2022.
//

import UIKit

/// стартовый контроллер на котором проверяется токен на работоспособность
class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        checkToken()
    }
    
    /// проверка токена и выбор контроллера исходя из ответа
    private func checkToken(){
        let loadView = LoadingView()
        // изменил на цвета стартовой страницы
        loadView.changeToStartPageColor()
        
        view = loadView
    
        ApiVK.standart.checkToken { [weak self] result in
            let controller:UIViewController = result ? TabBarViewController() : LoginViewController()
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: false, completion: nil)
        }
    }
}
