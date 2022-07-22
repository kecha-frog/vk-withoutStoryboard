//
//  StartInteractor.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 22.07.2022.
//

import Foundation

protocol StartInteractorInput {
    func checkToken() async throws -> Bool
}

class StartInteractor: ApiLayer, StartInteractorInput {

    // MARK: - Private Methods

    private func requestCheckTokenAsync() async throws -> Bool {
        let data = try await requestBase(endpoint: .getUser)

        let json: [String: Any]? = try JSONSerialization.jsonObject(
            with: data,
            options: .mutableContainers
        ) as? [String: Any]

        let result = json?.keys.contains("response") ?? false

        return result
    }

    // MARK: - Public Methods

    func checkToken() async throws -> Bool {
        return await withCheckedContinuation { continuation in
            Task {
                do {
                    let tokenIsValid = try await requestCheckTokenAsync()

                    if tokenIsValid {
                        continuation.resume(returning: tokenIsValid)
                    } else {

                        continuation.resume(returning: false)
                    }
                } catch {
                    throw MyError.tokenNotValid
                }
            }
        }
    }
}
