//
//  SignUpViewController.swift
//  Estudo
//
//  Created by stefanini on 02/05/22.
//

import Foundation
import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var cadastrar: UIButton!
    @IBOutlet weak var tbDados: UITableView!
    
    var dadosCadastro:Cadastro? = nil
    var listaAtividade:[Cadastro]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nome.delegate = self
        self.email.delegate = self
        self.senha.delegate = self
//        self.tbDados.delegate = self
//        tbDados.dataSource = self
//        atualizarDados()
        
        self.nome?.roundCorners(cornerRadiuns: 20.0, typeCorners: [.inferiorEsquerdo,.inferitoDireito,.superiorDireito,.superiorEsquerdo])
        
        self.email?.roundCorners(cornerRadiuns: 20.0, typeCorners: [.superiorEsquerdo,.superiorDireito,.inferitoDireito,.inferiorEsquerdo])
        
        self.senha?.roundCorners(cornerRadiuns: 20.0, typeCorners: [.inferiorEsquerdo,.inferitoDireito,.superiorDireito,.superiorEsquerdo])
        
        self.cadastrar?.roundCorners(cornerRadiuns: 25.0, typeCorners: [.superiorEsquerdo,.inferitoDireito])
    }

    func atualizarDados() {
        listaAtividade.removeAll()
        let fetch:NSFetchRequest = Cadastro.fetchRequest()

        do {
            listaAtividade = try DataBseController.getContext().fetch(fetch)
//            listaAtividade = listaAtividade.filter{
//                $0.nomeCad as! NSObject == nome
//                $0.emailCad as! NSObject == email
//                return $0.senhaCad as! NSObject == senha
//            }
//            tbDados.reloadData()
        }
        catch{

        }
    }
        
    // Botão cadastrar
    @IBAction func cadastrar(_ sender: UIButton) {
        
        if self.email.validateEmailCadastro() && self.senha.validateSenhaCadastro() && self.nome.validateNome(){
            
            let db = DataBseController.getContext()
            
            dadosCadastro = Cadastro(context: db)
            dadosCadastro?.nomeCad = nome.text
            dadosCadastro?.emailCad = email.text
            dadosCadastro?.senhaCad = senha.text
            if DataBseController.saveContext(){
                atualizarDados()
                self.nome.text = ""
                self.email.text = ""
                self.senha.text = ""
                self.showAlert(title: "Cadastrado com sucesso")
            }
            else{
                
            }
            
            self.performSegue(withIdentifier: "inicio", sender: nil)
        }
        else{
            self.showAlert(title: "Caracteres insuficientes")
        }
        
    }
        
    //Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaAtividade.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CellDadosTableViewCell", owner: self, options: nil)?.first as! CellDadosTableViewCell
        let atividade = listaAtividade[indexPath.row]
        cell.lblnome.text = "\(atividade.nomeCad!)"
        cell.lblemail.text = "\(atividade.emailCad!)"
        cell.lblsenha.text = "\(atividade.senhaCad!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
         
    // Botão de voltar
    @IBAction func voltar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "inicio", sender: nil)
    }
    
    // Alertas
    func showAlert(title:String){
        
        let alerta = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerta.addAction(okButton)
        self.present(alerta, animated: true, completion: nil)
        self.performSegue(withIdentifier: "inicio", sender: nil)

    }
    
    // Próximo campo com Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.nome{
            self.email.becomeFirstResponder()
        }
        else if textField == self.email{
            self.senha.becomeFirstResponder()
        }
        else{
            self.senha.resignFirstResponder()
        }
        return true
    }
}
    
    // Validações dos campos
    extension UITextField{
        
        func validateNome()->Bool{
            let nomeRegex = "[A-Za-z0-9]{4,}"
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


