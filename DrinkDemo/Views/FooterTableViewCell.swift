//
//  FooterTableViewCell.swift
//  DrinkDemo
//
//  Created by usr on 2020/9/8.
//

import UIKit

class FooterTableViewCell: UITableViewCell {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(count: Int, amount: Int) {
        /* 設定 contentView 背景顏色 */
        self.contentView.backgroundColor = UIColor.systemGray6
        lineView.layer.cornerRadius = 2
        
        let totalText = numberFormatter(intValue: amount)
        totalLabel.text = "合計：\(count)杯 \(totalText)"
    }
    
    /**
     利用 NumberFormatter 轉換 Int 成貨幣文字
     */
    func numberFormatter(intValue: Int) -> String {
        
        let nsNumber = NSNumber(value: intValue)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        
        formatter.numberStyle = .currency
        let str = formatter.string(from: nsNumber) ?? ""
        
        return str
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
