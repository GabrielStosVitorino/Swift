//
//  SignInViewModel.swift
//  Estudo
//
//  Created by stefanini on 18/05/22.
//

import Foundation

enum TextFieldType: String {
    case user
    case password
}

protocol SignInViewModelProtocol {
    var showAlert: ((String, String) -> Void)? { get set }
    
    func change(text: String, type: TextFieldType)
    func login()
    
}

class SignInViewModel: SignInViewModelProtocol {
    var showAlert: ((String, String) -> Void)?
    
    private var user: String?
    private var password: String?
    
    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let validateRegex = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return validateRegex.evaluate(with: user)
    }
    
    private func validatePassword() -> Bool {
        let senhaRegex = ".{6,}"
        let validateRegex = NSPredicate(format: "SELF MATCHES %@", senhaRegex)
        
        return validateRegex.evaluate(with: password)
        
    }
    
    func change(text: String, type: TextFieldType) {
        switch type{
        case .user:
            user = text
        default:
            password = text
        }
    }
    
    func login() {
        if validateEmail() && validatePassword() {
            
            var predicates: [NSPredicate] = []
            if let email = user {
                predicates.append(NSPredicate(format: "emailCad == %@", email))
            }
            if let pass = password {
                predicates.append(NSPredicate(format: "senhaCad == %@", pass))
            }
            
            let parametro = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let result = DataBseController.fetchLog(logar: Cadastro.self, parametro: parametro)
            
            if result.isEmpty {
                showAlert?("Verifique novamente seu e-mail ou sua senha", "Ok")
            } else {
                if result.first != nil {
                    showAlert?("Sucesso ao logar", "Ok")
                }
            }
            
        }
        else{
            showAlert?("Caracteres insuficientes", "Ok")
        }
    }
}
