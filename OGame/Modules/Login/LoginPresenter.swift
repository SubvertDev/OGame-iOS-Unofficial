//
//  LoginPresenter.swift
//  OGame
//
//  Created by Subvert on 06.03.2022.
//

import Foundation

protocol LoginPresenterDelegate {
    init(view: ILoginView)
    func login(username: String, password: String)
}

final class LoginPresenter: LoginPresenterDelegate {
    
    unowned let view: ILoginView
    private let loginProvider = LoginProvider()
    
    required init(view: ILoginView) {
        self.view = view
    }
    
    // MARK: - Public
    func login(username: String, password: String) {
        guard isInputValid(username, password) else { return }
        view.showLoading(true)
        Task {
            do {
                let servers = try await loginProvider.loginIntoAccountWith(username: username, password: password)
                await MainActor.run { view.performLogin(servers: servers) }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
            await MainActor.run { view.showLoading(false) }
        }
    }
    
    // MARK: - Private
    private func isInputValid(_ username: String, _ password: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let emailCheck = username
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .range(of: emailPattern, options: .regularExpression)
        
        if emailCheck == nil {
            view.showAlert(error: OGError(message: K.Error.errorTitle, detailed: "Please enter valid email"))
            return false
        } else if password.isEmpty {
            view.showAlert(error: OGError(message: K.Error.errorTitle, detailed: "Please enter valid password"))
            return false
        }
        return true
    }
}
