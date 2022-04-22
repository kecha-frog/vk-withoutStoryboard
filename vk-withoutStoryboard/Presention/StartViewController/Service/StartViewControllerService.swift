//
//  StartService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 02.04.2022.
//

import Foundation
//import Firebase

/// Сервисный слой для StartViewController.
class StartViewControllerService{
    /// Проверка токена на валидность.
    /// - Parameter completion: Замыкание. Передает: Bool - исходя из валидности токена.
    func fetchApiCheckToken(_ completion: @escaping (_ result: Bool)-> Void){
        ApiVK.standart.requestCheckToken { result in
            completion(result)
        }
    }
    
    /// Анонимная авторизация в Firebase.
//    func authInFirebase(){
//        Auth.auth().signInAnonymously()
//    }
}
