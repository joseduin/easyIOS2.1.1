//
//  ProductoDetalleModalController.swift
//  market
//
//  Created by Jose Duin on 12/27/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Haneke

class ProductoDetalleModalController: UIViewController {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var cantidad: UILabel!
    @IBOutlet weak var total: UILabel!
    
    var imagen_desc: String = ""
    var nombre_desc: String = ""
    var cantidad_desc: String = ""
    var total_desc: String = ""
    
    let facade: Facade = Facade()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buscarImagen(id: imagen_desc, tipo: "products", imagenSize: "medium_default", image: imagen)
        nombre.text = nombre_desc
        cantidad.text = cantidad_desc
        total.text = total_desc
    }

    func buscarImagen(id: String, tipo: String, imagenSize: String, image: UIImageView) {
        print("\(self.facade.WEB_PAGE)/images/\(tipo)/\(id)/\(imagenSize)?\(facade.parametrosKey())")
        let url = URL(string: "\(self.facade.WEB_PAGE)/images/\(tipo)/\(id)/\(imagenSize)?\(facade.parametrosKey())")
        image.hnk_setImage(from: url!)
    }
    
    @IBAction func continuarCompra(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var irCaja: UIButton!
   
}
