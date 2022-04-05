//
//  StartService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 02.04.2022.
//

import Foundation

class StartViewControllerService{
    func fetchApiCheckToken(_ completion: @escaping (_ result: Bool)-> Void){
        ApiVK.standart.checkToken { result in
            completion(result)
        }
    }
}
