//
//  ErrorCell.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 21/04/23.
//

import UIKit

class ErrorCell: UITableViewCell {

    @IBOutlet weak var errorBox: UIView!
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var errorCellLabel: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        cellIcon.layer.cornerRadius = 2.0
        
        errorCellLabel.textColor = UIColor(named: "TextColor")
        errorBox.layer.borderWidth   = 1
        errorBox.layer.borderColor   = UIColor(named: "ErrorBorder")?.cgColor
        errorBox.layer.cornerRadius  = 4
        errorBox.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }
    
}
