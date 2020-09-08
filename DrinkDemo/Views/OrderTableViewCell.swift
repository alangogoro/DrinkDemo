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
    
    func setup(with order: Order) {
        drinkImageView.image = UIImage(named: order.drinkId)
        nameLabel.text  = order.name
        drinkLabel.text = order.drink
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
