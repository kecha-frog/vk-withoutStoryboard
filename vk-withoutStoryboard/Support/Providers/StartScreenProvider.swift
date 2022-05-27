//
//  StartScreenProvider.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 02.04.2022.
//

import Foundation
// import Firebase

/// Провайдер для StartViewController.
final class StartScreenProvider: ApiLayer {
    // MARK: - Public Methods
    /// Проверка токена на валидность.
    func requestCheckTokenAsync() async throws -> Bool {
        let data = try await requestBase(endpoint: .getUser)

        let json: [String: Any]? = try JSONSerialization.jsonObject(
            with: data,
            options: .mutableContainers
        ) as? [String: Any]

        let result = json?.keys.contains("response") ?? false

        return result
    }

    /// Анонимная авторизация в Firebase.
    //    func authInFirebase(){
    //        Auth.auth().signInAnonymously()
    //    }
}
