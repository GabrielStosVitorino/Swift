//
//  Pokemon.swift
//  Estudo
//
//  Created by stefanini on 27/05/22.
//

import Foundation

struct PokemonList: Decodable {
    let results: [Pokemon]
}
struct Pokemon: Decodable {
    let name:String?
    let url:String?
}
