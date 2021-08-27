//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Matthew Hollyhead on 23/08/2021.
//

import Foundation

struct Abilities: Codable {
    var abilities: [Ability]
    var base_experience: Int
    //var forms: Forms
    var id: Int
    //var types: [Type]
}
