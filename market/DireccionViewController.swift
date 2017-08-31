//
//  DireccionViewController.swift
//  market
//
//  Created by Jose Duin on 12/7/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire

class DireccionViewController: UIViewController {
    
    // Pasar a kevin
    
    let facade: Facade = Facade()
    
    var dir_entrega: String = ""
    var dir_envio: String = ""
    var dir_cobro: String = ""
    var envio: String = ""
    var tabla: String = ""
    
    @IBOutlet weak var estatus: UIWebView!
    @IBOutlet var label: UILabel!
    var orderPass: Order = Order()
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var tablaproductos: UIWebView!
    
    @IBOutlet weak var foot: UIWebView!
    
    @IBOutlet weak var tablaenvio: UIWebView!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productTotal: UILabel!
    
    @IBOutlet weak var orderTotal: UILabel!
    
    @IBOutlet weak var orderCarrier: UILabel!
    
    @IBOutlet weak var addressDelivery: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaproductos.scrollView.isScrollEnabled = true
        self.navigationItem.title = orderPass.payment
        self.label.text = orderPass.payment
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        buscarEstado(web: self.estatus, order: orderPass)
        cargarproductos(order: orderPass)
        if (orderPass.id_address_delivery == orderPass.id_address_invoice) {
            buscarDirecciones(order: orderPass, iguales: true);
        } else {
            buscarDirecciones(order: orderPass, iguales: false);
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cargarproductos(order: Order) {
        tabla = "<style> table, th, td {        border: 1px solid black;        border-collapse: collapse;    }    th, td {       padding: 5px;       text-align: left;    }   </style><table style=\"width:100%\">    <thead>    <tr>    <th style=\"background-color: #f77e40 !important; color: white;\">Producto</th>    <th style=\"background-color: #f77e40 !important; color: white;\">Cant</th> <th style=\"background-color: #f77e40 !important; color: white;\">Precio unitario</th>  <th style=\"background-color: #f77e40 !important; color: white;\">Precio total</th>   </tr>    </thead>  <tbody>"
        
        
        for index in 0..<order.productos.count {
            
            let item: OrderItem = order.productos[index]
            if (item.product_quantity != "0") {
                let precio: Double = Double(item.unit_price_tax_incl)! * Double(order.total_paid)!
                tabla = "\(tabla)<tr>    <th>  \(item.product_name) </th>    <th>  \(item.product_quantity)  </th><th> $  \(String(format: "%.2f", Double(item.unit_price_tax_incl)!)) </th><th> $  \(String(format: "%.2f", precio)) </th>  </tr>"
            }
        }
        
        tabla = "\(tabla)</tbody>        </table>"
        
        let footer: String = "<br><style>table, th, td { border: 1px solid black;   border-collapse: collapse;   }  th, td { padding: 5px; text-align: left;} }    </style> <table>    <tr>    <th colspan=\"1\">    <strong>Artículos</strong>    </th>    <th colspan=\"3\"> $  \(String(format:"%.2f", Double(order.total_products_wt)!)) </th>    </tr>    <tr>    <th colspan=\"1\">    <strong>Envío</strong>    </th>    <th colspan=\"3\"> $ \(String(format: "%.2f", Double(order.total_shipping_tax_incl)!)) </th>    </tr>    <tr>    <th colspan=\"1\" style=\"background-color: #FC5F10 !important; color: white;\">    <strong>Total</strong>    </th>    <th colspan=\"3\"> $  \(String(format: "%.2f", Double(order.total_paid_tax_incl)!))</th>    </tr>    </table>"
        
        tabla = "\(tabla)\(footer)"
        //tablaproductos.loadHTMLString(tabla, baseURL: nil)
        
        //foot.loadHTMLString(footer, baseURL: nil)
    }
    
    
    
    func buscarEstado(web: UIWebView, order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/order_states/\(order.current_state)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let valor = self.facade.buscarEstado(res: JSON)
                    let estado: String = "<span style=\"background-color:\(valor.color); border-color:\(valor.color);padding: 6px 10px; color: white;\">\(valor.nombre)</span>"
                    web.loadHTMLString(estado, baseURL: nil)
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    
    func buscarDirecciones(order: Order, iguales: Bool) {
        Alamofire.request("\(facade.WEB_PAGE)/addresses/\(order.id_address_delivery)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    
                    
                    
                    self.dir_entrega = self.facade.buscarDireccion(res: JSON).alias
                    if (iguales) {
                        
                        self.dir_cobro = self.dir_entrega;
                        self.buscarEnvio(order: order);
                    } else {
                        print("diferente")
                        self.buscarOtraDireccion(order: order);
                    }
                    
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
        
    }
    
    
    func buscarEnvio(order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/carriers/\(order.id_carrier)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.envio = self.facade.buscarEnvio(res: JSON).name;
                    
                    self.cargarenvio();
                }
                
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
    }
    
    func buscarOtraDireccion(order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/addresses/\(order.id_address_invoice)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.dir_cobro = self.facade.buscarDireccion(res: JSON).alias;
                    self.buscarEnvio(order: order);
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //     print(error)        // Poner en comentario
            }
            
        }
    }
    
    func cargarenvio(){
        let als: String = self.envio
        let dir1: String = self.dir_entrega
        let dir2: String = self.dir_cobro
        tabla = "\(tabla) <br><style> table, th, td {  border: 1px solid black; border-collapse: collapse;  } th, td { padding: 5px; text-align: left;  }           </style> <table style=\"width:100%\"><tbody><tr><th colspan=\"1\" style=\"background-color: #f77e40 !important; color: white;\">Transportista</th><th colspan=\"3\">\(als.capitalized)</th></tr><tr><th colspan=\"1\" style=\"background-color: #f77e40 !important; color: white;\">Dirección de entrega</th><th colspan=\"3\">\(dir1.capitalized) </th></tr> <tr><th colspan=\"1\" style=\"background-color: #f77e40 !important; color: white;\">Dirección de facturación</th><th colspan=\"3\">\(dir2.capitalized)</th></tr></tbody></table>"
        
        tablaproductos.loadHTMLString(tabla, baseURL: nil)
    }
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
