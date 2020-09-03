//
//  DrinkTableViewCell.swift
//  JustDrink
//
//  Created by usr on 2020/8/26.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mPriceLabel: UILabel!
    @IBOutlet weak var lPriceLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        drinkImageView.image = nil
        
    }
    
    func setup(with drink: Drink) {
        nameLabel.text = drink.name
        categoryLabel.text = drink.category.rawValue
        mPriceLabel.text = "\(drink.options[0].price)"
        lPriceLabel.text = "\(drink.options[1].price)"
        drinkImageView.image = UIImage(named: drink.id)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
