//
//  SignUpViewController.swift
//  Estudo
//
//  Created by stefanini on 02/05/22.
//

import Foundation
import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nome: UITextField?
    @IBOutlet weak var email: UITextField?
    @IBOutlet weak var senha: UITextField?
    @IBOutlet weak var cadastrar: UIButton?
    
    var dadosCadastro:Cadastro? = nil
    var listaAtividade:[Cadastro]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nome?.delegate = self
        self.email?.delegate = self
        self.senha?.delegate = self
        
        self.nome?.roundCorners(cornerRadiuns: 20.0, typeCorners: [.inferiorEsquerdo,.inferitoDireito,.superiorDireito,.superiorEsquerdo])
        
        self.email?.roundCorners(cornerRadiuns: 20.0, typeCorners: [.superiorEsquerdo,.superiorDireito,.inferitoDireito,.inferiorEsquerdo])
        
        self.senha?.roundCorners(cornerRadiuns: 20.0, typeCorners: [.inferiorEsquerdo,.inferitoDireito,.superiorDireito,.superiorEsquerdo])
        
        self.cadastrar?.roundCorners(cornerRadiuns: 25.0, typeCorners: [.superiorEsquerdo,.inferitoDireito])
    }
        
    // Botão cadastrar
    @IBAction func cadastrar(_ sender: UIButton) {
        
        if self.email?.validateEmailCadastro() ?? false
            && self.senha?.validateSenhaCadastro() ?? false
            && self.nome?.validateNome() ?? false {
            
            let db = DataBseController.getContext()
            
            dadosCadastro = Cadastro(context: db)
            dadosCadastro?.nomeCad = nome?.text
            dadosCadastro?.emailCad = email?.text
            dadosCadastro?.senhaCad = senha?.text
            if DataBseController.saveContext() {
                self.nome?.text = ""
                self.email?.text = ""
                self.senha?.text = ""
                self.showAlert(title: "Cadastrado com sucesso")
            }
            else{
                self.showAlert(title: "Ops! Tente novamente.")
            }
            
            dismiss(animated: true, completion: nil)
        }
        else{
            self.showAlert(title: "Caracteres insuficientes")
        }
        
    }
         
    // Botão de voltar
    @IBAction func voltar(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Alertas
    func showAlert(title:String){
        
        let alerta = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true,
                          completion: nil)
        })
        alerta.addAction(okButton)
        self.present(alerta, animated: true, completion: nil)
    }
    
    // Próximo campo com Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.nome{
            self.email?.becomeFirstResponder()
        }
        else if textField == self.email{
            self.senha?.becomeFirstResponder()
        }
        else{
            self.senha?.resignFirstResponder()
        }
        return true
    }
}
    
    // Validações dos campos
    extension UITextField{
        
        func validateNome()->Bool{
            let nomeRegex = "([A-Za-z ]+){4,}"
            let validateRegex = NSPredicate(format: "SELF MATCHES %@", nomeRegex)
            
            return validateRegex.evaluate(with: self.text)
        }
        
        func validateEmailCadastro()->Bool{
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
            let validateRegex = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            return validateRegex.evaluate(with: self.text)
        }
        
        func validateSenhaCadastro()->Bool{
            let senhaRegex = ".{6,}"
            let validateRegex = NSPredicate(format: "SELF MATCHES %@", senhaRegex)
            
            return validateRegex.evaluate(with: self.text)
        }
    }


