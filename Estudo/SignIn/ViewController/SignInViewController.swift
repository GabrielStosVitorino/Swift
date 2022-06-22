//
//  ViewController.swift
//  Estudo
//
//  Created by stefanini on 28/04/22.
//

import UIKit
import CoreData

var dadosCadastro:Cadastro? = nil
var listaAtividade:[Cadastro]=[]

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usuario: UITextField?
    @IBOutlet weak var senha: UITextField?
    @IBOutlet weak var login: UIButton?
    
    var viewModel: SignInViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegates()
        setupBorder()
        setupViewModel()
        setupBinds()
    }
    
    private func textFieldDelegates() {
        usuario?.addTarget(self, action: #selector(userDidChange), for: .editingChanged)
        usuario?.delegate = self
        senha?.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        senha?.delegate = self
    }
    
    @objc func userDidChange() {
        guard let user = usuario?.text else {return}
        viewModel?.change(text: user, type: .user)
    }
    
    @objc func passwordDidChange() {
        guard let password = senha?.text else {return}
        viewModel?.change(text: password, type: .password)
    }
    
    private func setupBorder() {
        login?.roundCorners(cornerRadiuns: 25.0, typeCorners: [.inferitoDireito,.superiorEsquerdo])
        
        usuario?.roundCorners(cornerRadiuns: 20.0, typeCorners: [.superiorEsquerdo,.superiorDireito,.inferitoDireito,.inferiorEsquerdo])
        
        senha?.roundCorners(cornerRadiuns: 20.0, typeCorners: [.superiorEsquerdo,.superiorDireito,.inferitoDireito,.inferiorEsquerdo])
    }
    
    func setupViewModel() {
        viewModel = SignInViewModel()
    }
    
    func setupBinds() {
        viewModel?.showAlert = { [weak self] title, actionTitle, buttonAction in
            let alerta = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: actionTitle, style: .default, handler: buttonAction)
            alerta.addAction(okButton)
            self?.present(alerta, animated: true, completion: nil)
        }
        viewModel?.navigateToPokemons = { [weak self] in
            self?.performSegue(withIdentifier: "showPokemonList", sender: nil)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        viewModel?.login()
    }
}

extension SignInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.usuario{
            self.senha?.becomeFirstResponder()
        }
        else{
            self.senha?.resignFirstResponder()
        }
        return true
    }
}


    
