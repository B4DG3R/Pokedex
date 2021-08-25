//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Matthew Hollyhead on 23/08/2021.
//

import Foundation
import UIKit

struct Pokemon: Codable {
    var abilities: [Ability]
    var base_experience: Int
    var forms: Forms
}
