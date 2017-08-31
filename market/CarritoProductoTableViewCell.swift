//
//  CarritoProductoTableViewCell.swift
//  market
//
//  Created by Jose Duin on 1/9/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire

class CarritoProductoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var precioUnitario: UILabel!
    @IBOutlet weak var valor: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var precioTotal: UILabel!
    
    var controller: CarritoViewController?
    var position: Int = 0
    var carrito: Carrito = Carrito()
    var producto_id: String = ""
    let facade: Facade = Facade()

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    @IBAction func selectedStepper(_ sender: UIStepper) {
        valor.text = Int(sender.value).description
        actualizarCantidadDeProductosEnCarrito(cantidad: Double(sender.value))
    }
    
    func actualizarCantidadDeProductosEnCarrito(cantidad: Double) {
        Alamofire.request("\(facade.WEB_API_AUX)UCartItemQuantity.php?id=\(carrito.id)&row=\(position)&qua=\(Int(cantidad))").validate().responseJSON { response in
            switch response.result {
            case .success: break
  
            default:
                let precioString = self.precioUnitario.text?.replacingOccurrences(of: "$ ", with: "")
                self.precioTotal.text = "$ \(String(format: "%.2f", (Double(precioString!)! * cantidad)))"
                self.controller?.CARRITO_ACTUAL.carritoDetalles[self.position].quantity = "\(cantidad)"
                self.controller?.calcularTotales()
                break
            }
        }
        
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        confirmarEliminarProductoCarrito(nombre: self.descripcion.text!)
    }
    
    func confirmarEliminarProductoCarrito(nombre: String) {
        let alert = UIAlertController(title: "Confirmación", message: "¿Seguro de sacar del carrito \"\(nombre)\" ?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { action in
            self.deletingProduct()
        }))
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    func deletingProduct() {
        let params: Parameters = Parameters()
        print("\(self.facade.WEB_API_AUX)AddItemToCart.php?removeItem=true&idCart=\(carrito.id)&idPro=\(producto_id)&proQua=0")
        Alamofire.request("\(self.facade.WEB_API_AUX)AddItemToCart.php?removeItem=true&idCart=\(carrito.id)&addItem=true&idPro=\(producto_id)&proQua=0", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success: break
                
            default:
                // Eliminar todo lo referente al producto en el carrito
                self.controller?.CARRITO_ACTUAL.carritoDetalles.remove(at: self.position)
                self.controller?.preciosNetos.remove(at: self.position)
                self.controller?.productos.remove(at: self.position)
                self.controller?.tableProductos.reloadData()
                self.controller?.calcularTotales()
                break
            }
        }
    }
    
}
