//
//  DireccionesViewCell.swift
//  market
//
//  Created by Jose Duin on 12/7/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit

class DireccionesViewCell: UITableViewCell {
    
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var referencia: UILabel!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var pago: UILabel!
    @IBOutlet weak var esttus: UIWebView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
