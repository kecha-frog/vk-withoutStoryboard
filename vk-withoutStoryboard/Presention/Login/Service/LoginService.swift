//
//  LoginService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 05.04.2022.
//

import Foundation
import Firebase

class LoginService{
    let ref = Database.database().reference(withPath: "Authorized_Id")
    
    /// отправка  в firebase авторизированных юзеров
    /// - Parameter id: autorized user id
    func firebaseAutorizedId(_ id: String){
        let autorizedId = loginAutorized(id)
        let autorizedRef = self.ref.child(autorizedId.userId)
        autorizedRef.setValue(autorizedId.toAnyObject())
    }
}
