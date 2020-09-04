//
//  OrderTableViewCell.swift
//  DrinkDemo
//
//  Created by usr on 2020/9/4.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
