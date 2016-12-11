//
//  MenuViewCell.swift
//  market
//
//  Created by Jose Duin on 11/21/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation
import UIKit

class MenuViewCell: UITableViewCell {

    @IBOutlet weak var imagenIcon: UIImageView!
    @IBOutlet weak var descripcion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        descripcion.textColor = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (selected) {
            
        }
    }
    
}
