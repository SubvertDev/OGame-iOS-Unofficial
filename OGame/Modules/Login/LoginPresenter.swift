//
//  LoginPresenter.swift
//  OGame
//
//  Created by Subvert on 06.03.2022.
//

import Foundation

protocol LoginPresenterDelegate {
    init(view: LoginViewDelegate)
    func login(username: String, password: String)
}

final class LoginPresenter: LoginPresenterDelegate {
    
    unowned let view: LoginViewDelegate
    private let loginProvider = LoginProvider()
    
    required init(view: LoginViewDelegate) {
        self.view = view
    }
    
    // MARK: - Login
    func login(username: String, password: String) {
        guard isInputValid(username, password) else { return }
        view.showLoading(true)
        Task {
            do {
                let servers = try await loginProvider.loginIntoAccountWith(username: username, password: password)
                await MainActor.run { view.performLogin(servers: servers) }
            } catch {
                await MainActor.run { view.showAlert(error: error) }
            }
            await MainActor.run { view.showLoading(false) }
        }
    }
    
    // MARK: - Is Input Valid
    private func isInputValid(_ username: String, _ password: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let emailCheck = username
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .range(of: emailPattern, options: .regularExpression)
        
        if emailCheck == nil {
            view.showAlert(error: OGError(message: "Error", detailed: "Please enter valid email"))
            return false
        } else if password.isEmpty {
            view.showAlert(error: OGError(message: "Error", detailed: "Please enter valid password"))
            return false
        }
        return true
    }
}
