//
//  PokemonViewController.swift
//  Estudo
//
//  Created by stefanini on 22/06/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    var pokemons: [Pokemon] = []
    let api: PokeProtocol = PokeApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView?.dataSource = self
        tableView?.delegate = self
        api.getPokemons() { [weak self] listaPokemon in
            if let pokemons = listaPokemon?.results {
                self?.pokemons = pokemons
                DispatchQueue.main.async { [weak self] in
                    self?.tableView?.reloadData()
                }
            }
        }
    }
}

extension PokemonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PokemonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath) as? PokemonTableViewCell
        cell?.lblNomePokemon?.text = self.pokemons[indexPath.row].name
        
        return cell ?? UITableViewCell()
    }
}
