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
        print("\(facade.WEB_API_AUX)UCartItemQuantity.php?id=\(carrito.id)&row=\(position)&qua=\(cantidad)")
        Alamofire.request("\(facade.WEB_API_AUX)UCartItemQuantity.php?id=\(carrito.id)&row=\(position)&qua=\(cantidad)").validate().responseJSON { response in
            switch response.result {
            case .success:
                let precioString = self.precioUnitario.text?.replacingOccurrences(of: "$", with: "")
                self.precioTotal.text = "$" + String(format: "%.2f", (Double(precioString!)! * cantidad))
                self.controller?.calcularTotales()
            default: break
                
            }
        }
        
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        confirmarEliminarProductoCarrito(nombre: "")
    }
    
    func confirmarEliminarProductoCarrito(nombre: String) {
        /*AlertDialog.Builder builder = new AlertDialog.Builder(this);
         
         builder.setTitle("Confirmación");
         builder.setMessage("¿Seguro de sacar del carrito \"" + nombre + "\" ?");
         
         builder.setPositiveButton("SI", new DialogInterface.OnClickListener() {
         public void onClick(DialogInterface dialog, int which) {
         // Do something
         dialog.dismiss();
         }
         });
         
         builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
         @Override
         public void onClick(DialogInterface dialog, int which) {
         
         dialog.dismiss();
         }
         });
         
         AlertDialog alert = builder.create();
         alert.show();*/
    }
}
