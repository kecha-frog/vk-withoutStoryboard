//
//  StartScreenProvider.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 02.04.2022.
//

import Foundation
// import Firebase

/// Провайдер для StartViewController.
final class StartScreenProvider {
    // MARK: - Public Methods
    /// Проверка токена на валидность.
    /// - Parameter completion: Замыкание. Передает: Bool - исходя из валидности токена.
    func fetchApiAsync(_ completion: @escaping (_ result: Bool) -> Void) {
        ApiLayer.standart.requestCheckToken { result in
            completion(result)
        }
    }

    /// Анонимная авторизация в Firebase.
    //    func authInFirebase(){
    //        Auth.auth().signInAnonymously()
    //    }
}
