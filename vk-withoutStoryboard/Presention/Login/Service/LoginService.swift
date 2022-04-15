//
//  LoginService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 05.04.2022.
//

import Foundation
import Firebase

/// Сервисный слой для LoginViewController.
class LoginService{
    private let ref: DatabaseReference = Database.database().reference(withPath: "Authorized_Id")
    
    /// Отправка  id авторизированных юзеров в firebase.
    /// - Parameter id: Autorized user id.
    func firebaseAutorizedId(_ id: String){
        let autorizedId: LoginAutorized = LoginAutorized(id)
        let autorizedRef: DatabaseReference = self.ref.child(autorizedId.userId)
        autorizedRef.setValue(autorizedId.toAnyObject())
    }
}
