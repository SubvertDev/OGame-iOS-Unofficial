//
//  LoginPresenter.swift
//  OGame
//
//  Created by Subvert on 06.03.2022.
//

import Foundation

protocol LoginPresenterDelegate {
    init(view: LoginViewDelegate)
    @MainActor func login(username: String, password: String)
}

final class LoginPresenter: LoginPresenterDelegate {
    unowned let view: LoginViewDelegate
    private let loginProvider = LoginProvider()
    
    required init(view: LoginViewDelegate) {
        self.view = view
    }

    func login(username: String, password: String) {
        view.showLoading(true)
        Task {
            do {
                let servers = try await loginProvider.loginIntoAccountWith(username: username, password: password)
                view.performLogin(servers: servers)
            } catch {
                view.showAlert(error: error)
            }
            view.showLoading(false)
        }
    }
}
