//
//  DetailViewController.swift
//  PokemonApp
//
//  Created by Matthew Hollyhead on 26/08/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var pokemonName:                    String
    var pokemonNumber:                  Int
    var pokemonSpriteURL:               String
    var pokemonBaseExp:                 Int
    var pokemonTypeDescription:         [type]
    var pokemonAbilitiesDescription:    [Ability]
    
    var sprite: Sprite?
    
    @IBOutlet weak var nameLabel:                 UILabel?
    @IBOutlet weak var numberLabel:               UILabel?
    @IBOutlet weak var spriteImageView:           UIImageView?
    @IBOutlet weak var baseExpLabel:              UILabel!
    @IBOutlet weak var baseExpDescriptionLabel:   UILabel!
    @IBOutlet weak var typeLabel:                 UILabel?
    @IBOutlet weak var typeDescriptionLabel:      UILabel?
    @IBOutlet weak var abilitiesLabel:            UILabel?
    @IBOutlet weak var abilitiesDescriptionLabel: UILabel?
    
    init?(coder: NSCoder, name: String, number: Int, spriteURL: String, experience: Int, type: [type], abilities: [Ability]) {
        pokemonName =                   name
        pokemonNumber =                 number
        pokemonSpriteURL =              spriteURL
        pokemonBaseExp =                experience
        pokemonTypeDescription =        type
        pokemonAbilitiesDescription =   abilities
        super.init(coder:coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates pokemon type and ability string
        let typeString = listPokemonTypeDetails(types: pokemonTypeDescription)
        let abilityString = listPokemonAbilityDetails(abilities: pokemonAbilitiesDescription)
        
        nameLabel?.text =                   pokemonName.capitalizingFirstLetter()
        numberLabel?.text =                 String("#\(pokemonNumber)")
        baseExpLabel?.text =                "Base Experience:"
        baseExpDescriptionLabel?.text =     String(pokemonBaseExp)
        typeLabel?.text =                   "Type:"
        typeDescriptionLabel?.text =        typeString
        abilitiesLabel?.text =              "Abilities:"
        abilitiesDescriptionLabel?.text =   abilityString
        
        networkCall(imageURL: pokemonSpriteURL)
        
    }

}

// MARK: Network call and image parse for Pokemon Sprite

extension DetailViewController {
    
    func networkCall(imageURL: String) {
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            if let url = URL(string: imageURL) {
                if let data = try? Data(contentsOf: url) {
                    parseImageJSON(json: data)
                    //return
                }
            }
        }
    }
    
    func fetchImage(urlString: String) {
        // Get data
        guard let url = URL(string: urlString) else {
            fatalError("Could not load urlString")
        }
        
        // Convert data to image
        let getDataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                // Set image to image View
                let imageData = UIImage(data: data)!
                self.spriteImageView?.image = imageData
            }
        }
        getDataTask.resume()
    }
    
    func parseImageJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResults = try? decoder.decode(PokemonDetails.self, from: json) {
            sprite = jsonResults.sprites
            fetchImage(urlString: (sprite?.front_default)!)
        }
    }
    
    func listPokemonTypeDetails(types: [type]) -> String {
        var returnString = ""
        
        // iterated through array and appends each type to a string separated by a ' , '
        // capitalizing the first letter of each type
        for type in types {
            returnString = returnString + type.type.name.capitalizingFirstLetter() + ", "
        }
        
        // removes the comma and space at the end of the string
        returnString.removeLast()
        returnString.removeLast()
        
        return returnString
    }
    
    func listPokemonAbilityDetails(abilities: [Ability]) -> String {
        var returnString = ""
        
        // iterated through array and appends each ability to a string separated by a ' , '
        // capitalizing the first letter of each type
        for ability in abilities {
            returnString = returnString + ability.ability.name.capitalizingFirstLetter() + ", "
        }
        
        // removes the comma and space at the end of the string
        returnString.removeLast()
        returnString.removeLast()
        
        return returnString
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
