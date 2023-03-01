//
//  WeatherCell.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 01/03/23.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIView!
    @IBOutlet weak var cellText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
