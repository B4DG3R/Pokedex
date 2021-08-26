//
//  ViewController.swift
//  PokemonApp
//
//  Created by Matthew Hollyhead on 23/08/2021.
//

import UIKit

private let reuseIdentifier = "NameCell"

class TableViewController: UITableViewController {
    
    var pokemon: [Result] = []
    var sprite: Sprite?
    var spriteURLList: [String] = []
    var sprites: [UIImage] = []
    var count = 0
    
    var nameURL: String?
    var imageURL: String?
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        title = "Pokedex"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        //var urlString = "https://pokeapi.co/api/v2/pokemon/"
        //urlString = "https://pokeapi.co/api/v2/pokemon/?offset=\(count)&;amp;limit=20"
        //var descriptionURL = "https://pokeapi.co/api/v2/pokemon/bulbasaur"
        //var formURL = "https://pokeapi.co/api/v2/pokemon-form/1/"
        
        loadNameData()
        loadImageURL()

    }
    
    // loops through grabbing pokemon name data
    func loadNameData() {
        // loop runs 55 times as there is 20 Pokemon per page and 1118 Pokemon in total
        for _ in 0...55 {
            nameURL = "https://pokeapi.co/api/v2/pokemon/?offset=\(count)&;amp;limit=20"
            count += 20
            print(count)
            print(nameURL)
            
            // This is the actual network call which collects the data
            if let url = URL(string: nameURL!) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    //return
                }
            }
        }
    }
    
    // Loops through appending the image png URL to spriteURLList array.
    // This is so each url can be passed to NameCell class in order for it
    // to parse the image JSON.
    func loadImageURL() {
        var spriteIndex = 0
        for index in 1...1118 {
            imageURL = "https://pokeapi.co/api/v2/pokemon-form/\(index)/"
            
            spriteURLList.append(imageURL!)

            print(spriteIndex)
            spriteIndex += 1
                       
        }
    }
    
    // Parses the name JSON and appends it to the Pokemon Array
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResults = try? decoder.decode(Results.self, from: json) {
            //pokemon = jsonResults.results
            pokemon.append(contentsOf: jsonResults.results)
        }
    }
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NameCell else {
            fatalError("Unable to dequeue NameCell")
        }
        
        let pokemon = pokemon[indexPath.row]
        let url = spriteURLList[indexPath.row]

        cell.nameLabel.text = pokemon.name
        cell.networkCall(imageURL: url)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = pokemon[indexPath.row]
        let url = spriteURLList[indexPath.row]
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: "DetailViewController", creator: { coder in
            return DetailViewController (coder: coder, name: pokemon.name, number: pokemon., spriteURL: url, type: String, abilities: String)
        }) else {
            fatalError("Detail View Controller not found.")
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



