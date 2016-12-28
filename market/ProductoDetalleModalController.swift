//
//  ProductoDetalleModalController.swift
//  market
//
//  Created by Jose Duin on 12/27/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class ProductoDetalleModalController: UIViewController {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var cantidad: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var popover: UIView!
    
    var imagen_desc: String = ""
    var nombre_desc: String = ""
    var cantidad_desc: String = ""
    var total_desc: String = ""
    var ID_USUARIO: String = ""
    
    let facade: Facade = Facade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popover.layer.cornerRadius = 10
        popover.layer.masksToBounds = true
        
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

    @IBAction func irCaja(_ sender: Any) {
        existeCarrito()
    }
    
    func existeCarrito() {
        Alamofire.request("\(self.facade.WEB_PAGE)/carts?filter[id_customer]=\(ID_USUARIO)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                // ir al carrito
                break
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func mensaje(mensaje: String, cerrar: Bool) {
        let mostrarMensaje = UIAlertController(title: "Mensaje", message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        if (cerrar) {
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                action in
                self.dismiss(animated: true, completion: nil)
            }
            mostrarMensaje.addAction(okAction)
        } else {
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            mostrarMensaje.addAction(okAction)
        }
        
        self.present(mostrarMensaje, animated: true, completion: nil)
    }
   
}
