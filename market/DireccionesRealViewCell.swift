//
//  DireccionesRealViewCell.swift
//  market
//
//  Created by Kevin Garcia on 12/26/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//
import UIKit

class DireccionesRealViewCell: UITableViewCell {
    
    // pasar a kevin
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var apellido: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var direccion1: UILabel!
    @IBOutlet weak var ciudad: UILabel!
    @IBOutlet weak var pais: UILabel!
    @IBOutlet weak var telefono1: UILabel!
    @IBOutlet weak var ruc: UILabel!
    @IBOutlet weak var alias: UILabel!
    @IBOutlet weak var direccion2: UILabel!
    @IBOutlet weak var telefono2: UILabel!
    
    var controller: DireccionesRealViewController?
    var row: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func btnEliminar(_ sender: Any) {
        confirmarEliminarDireccion()
    }
    @IBAction func btnActualizar(_ sender: Any) {
        self.controller?.dirPass = (self.controller?.items[row])!
        self.controller?.irDireccion()
    }
    
    func confirmarEliminarDireccion() {
        let alert = UIAlertController(title: "Confirmación", message: "¿Seguro de eliminar la direccion \"\(alias.text!)\" ?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { action in
            self.controller?.borrarDireccion(hijo: self.row)
        }))
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
}
