//
//  ViewController.swift
//  PokemonApp
//
//  Created by Matthew Hollyhead on 23/08/2021.
//

import UIKit

private let reuseIdentifier = "NameCell"

class TableViewController: UITableViewController {
    
    //var pokemon: [Pokemon] = []
    //var pokemon: [Form] = []
    //var names: [String] = []
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
        
        loadData()
        loadImages()
        //print("Sprite - \(spriteURLList[0].front_default)")
        //print("Pokemon- \(pokemon[0])")

    }
    
    func loadData() {
        for _ in 0...55 {
            nameURL = "https://pokeapi.co/api/v2/pokemon/?offset=\(count)&;amp;limit=20"
            count += 20
            print(count)
            print(nameURL)
            
            if let url = URL(string: nameURL!) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    //return
                }
            }
        }
    }
    
    
    func loadImages() {
        var spriteIndex = 0
        for index in 1...1118 {
            imageURL = "https://pokeapi.co/api/v2/pokemon-form/\(index)/"
            
            spriteURLList.append(imageURL!)
            //print(imageURL!)
            
            /*
            if let url = URL(string: imageURL!) {
                if let data = try? Data(contentsOf: url) {
                    parseImageJSON(json: data)
                    //return
                }
            }
            */
            
            //fetchImage(urlString: spriteURLList[spriteIndex].front_default)
            print(spriteIndex)
            spriteIndex += 1
                       
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResults = try? decoder.decode(Results.self, from: json) {
            //pokemon = jsonResults.results
            pokemon.append(contentsOf: jsonResults.results)
        }
    }
    
    /*
    func parseImageJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResults = try? decoder.decode(PokemonDetails.self, from: json) {
            //pokemon = jsonResults.results
            //sprite.append(contentsOf: jsonResults.sprites)
            sprite = jsonResults.sprites
            spriteURLList.append(sprite!)
            
            //view.reloadInputViews()
        }
    }
    */
    /*
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
                self.sprites.append(imageData)
                
            }
        }
        
        getDataTask.resume()
    }
    */
    
    
    /*
    func fetchImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.sprites.append(image)
                    }
                }
            }
        }
    }
    */
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemon.count
        //names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NameCell else {
            fatalError("Unable to dequeue NameCell")
        }
        
        let pokemon = pokemon[indexPath.row]
        let url = spriteURLList[indexPath.row]
        //let image = sprites[indexPath.row]
        //let name = names[indexPath.row]
        cell.nameLabel.text = pokemon.name
        //cell.fetchImage(urlString: url.front_default)
        cell.networkCall(imageURL: url)
        //cell.sprite.image = image
        //cell.nameLabel.text = name
        return cell
    }


    
}

