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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectedStepper(_ sender: UIStepper) {
    }
    
    func actualizarCantidadDeProductosEnCarrito(cantidad: Int, position: Int, carrito: Carrito/*, final TextView precioTotalCarrito,*/, precio: String) {
        
        Alamofire.request("\(facade.WEB_API_AUX)/UCartItemQuantity.php?id=\(carrito.id)&row=\(position)&qua=\(cantidad)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //precioTotalCarrito.setText("$" + String.format("%.2f", (Double.valueOf(precio.replace(",", ".")) * cantidad)));
                    self.calcularTotales();
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
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
