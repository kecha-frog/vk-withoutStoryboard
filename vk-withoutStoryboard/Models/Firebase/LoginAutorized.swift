//
//  FirebaseStart.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 05.04.2022.
//

// import Firebase

/// Модель для Firebase.
/*
final class LoginAutorized{
    let userId: String
    let ref: DatabaseReference?

    init(_ id: String){
        self.ref = nil
        self.userId = String(id)
    }

    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String:Any],
            let id = value["userId"] as? Int
        else{
            return nil
        }
        self.ref = snapshot.ref
        self.userId = String(id)
    }

    func toAnyObject() -> Any{
        Int(self.userId) as Any
    }
}
*/
