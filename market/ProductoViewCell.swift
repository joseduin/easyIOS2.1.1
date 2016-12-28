//
//  ProductoViewCell.swift
//  market
//
//  Created by Jose Duin on 12/14/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit

class ProductoViewCell: UITableViewCell {

    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var precio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
