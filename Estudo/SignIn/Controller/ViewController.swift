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

struct PokemonList: Decodable {
    let results: [Pokemon]
}
struct Pokemon:Decodable {
    let name:String?
    let url:String?
}

class ViewController: UIViewController {
    
    @IBOutlet weak var usuario: UITextField?
    @IBOutlet weak var senha: UITextField?
    @IBOutlet weak var login: UIButton?
    @IBOutlet weak var tabelaPokemon: UITableView?
    
    var viewModel: SignInViewModelProtocol?
    var sURL:URL? = nil
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0")
        
        tabelaPokemon?.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonTableViewCell")
        tabelaPokemon?.dataSource = self
        tabelaPokemon?.delegate = self
        
        
        textFieldDelegates()
        setupBorder()
        setupViewModel()
        setupBinds()
        getPokemons() { [weak self] listaPokemon in
            if let pokemons = listaPokemon?.results {
                self?.pokemons = pokemons
            }
        }
    }
    
    func getPokemons(completion: @escaping((PokemonList?) -> Void)) -> Void {
        URLSession.shared.dataTask(with: self.sURL!){(data, response, erro) in
            guard let data = data else {return}
            do {
                let listaPokemons = try JSONDecoder().decode(PokemonList.self, from: data)
                for pokemons in listaPokemons.results {
                    print("\(pokemons.name ?? "") - \(pokemons.url ?? "")")
                }
                completion(listaPokemons)
            } catch let jsonErro {
                print("Erro ao buscar dados \(jsonErro.localizedDescription)")
                completion(nil)
            }
        }.resume()
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
        viewModel?.showAlert = { [weak self] title, actionTitle in
            let alerta = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: actionTitle, style: .default, handler: nil)
            alerta.addAction(okButton)
            self?.present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        viewModel?.login()
    }
}

extension ViewController: UITextFieldDelegate{
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listaPoke.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PokemonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as? PokemonTableViewCell
        
        cell?.lblNomePokemon.text = self.listaPoke[indexPath.row]
        
        return cell ?? UITableViewCell()
    }

    
    
