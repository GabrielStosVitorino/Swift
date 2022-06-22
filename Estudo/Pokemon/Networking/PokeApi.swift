//
//  PokeApi.swift
//  Estudo
//
//  Created by stefanini on 22/06/22.
//

import Foundation

protocol PokeProtocol {
    func getPokemons(completion: @escaping((PokemonList?) -> Void)) -> Void
}

class PokeApi: PokeProtocol {
    private let pokeUrl: URL? = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0")
    func getPokemons(completion: @escaping((PokemonList?) -> Void)) -> Void {
        guard let url = pokeUrl
        else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url){ (data, response, erro) in
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
}
