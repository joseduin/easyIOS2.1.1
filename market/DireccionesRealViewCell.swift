//
//  DireccionesRealViewCell.swift
//  market
//
//  Created by Kevin Garcia on 12/26/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//
import UIKit

class DireccionesRealViewCell: UITableViewCell {
    
    // Outlet
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var apellido: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var direccion1: UILabel!
    @IBOutlet weak var ciudad: UILabel!
    @IBOutlet weak var pais: UILabel!
    @IBOutlet weak var telefono1: UILabel!
    @IBOutlet weak var alias: UILabel!
    @IBOutlet weak var direccion2: UILabel!
    @IBOutlet weak var telefono2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
