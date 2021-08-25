//
//  TableViewCell.swift
//  PokemonApp
//
//  Created by Matthew Hollyhead on 24/08/2021.
//

import UIKit

class NameCell: UITableViewCell {
    
    var aSprite: Sprite?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sprite: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        sprite.image = nil
    }
    
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
                //self.sprites.append(imageData)
                self.sprite.image = imageData
            }
        }
        getDataTask.resume()
    }
    
    func parseImageJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResults = try? decoder.decode(PokemonDetails.self, from: json) {
            //pokemon = jsonResults.results
            //sprite.append(contentsOf: jsonResults.sprites)
            aSprite = jsonResults.sprites
            fetchImage(urlString: (aSprite?.front_default)!)
            //spriteURLList.append(sprite!)
            
            //view.reloadInputViews()
        }
    }

    
}
