//
//  CarritoTransporteTableViewCell.swift
//  market
//
//  Created by Jose Duin on 1/9/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit

class CarritoTransporteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var duracion: UILabel!
    @IBOutlet weak var tiempo: UILabel!
    @IBOutlet weak var check: checkBox!
    
    var controller: CarritoViewController?
    var row: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkSelected(_ sender: Any) {
        if (check.isChecked) {
            controller?.check(envio: (controller!.listaEnvios[row]), hijo: row)
        }
    }
   
}
