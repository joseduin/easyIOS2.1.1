//
//  DireccionesViewController.swift
//  market
//
//  Created by Jose Duin on 12/6/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire

class DireccionesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contenedorDirecciones: UITableView!
    
    var items = [Order]()
    var ids = [String]()
    var orderPass: Order = Order()
    
    let facade: Facade = Facade()
    var direccionViewController: DireccionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Mis Pedidos"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        contenedorDirecciones.delegate = self
        contenedorDirecciones.dataSource = self
        contenedorDirecciones.separatorStyle = .none
        contenedorDirecciones.backgroundColor = UIColor.clear
        contenedorDirecciones.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        
        existeOrdenes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func existeOrdenes() {
        let id: String = UserDefaults.standard.string(forKey: "id")!

        Alamofire.request("\(facade.WEB_PAGE)/orders?filter[id_customer]=\(id)&sort=[id_DESC]&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.ids = self.facade.existeOrdenes(res: JSON);
        
                    if (self.ids.count > 0) {
                        self.buscarOrden(hijo: 0);
                    } else {
                        self.mensaje(mensaje: "Ud aún no tiene un historial de ordenes.", cerrar: true);
                    }
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarOrden(hijo: Int) {
        Alamofire.request("\(facade.WEB_PAGE)/orders/\(self.ids[hijo])?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let order: Order = self.facade.buscarOrden(res: JSON)
                    self.seguirBuscando(order: order, hijo: hijo);
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func seguirBuscando(order: Order, hijo: Int) {
        insertNewObject(order: order)
    
        let hijoAux = hijo + 1
        if (hijoAux < ids.count) {
            buscarOrden(hijo: hijoAux)
        }
    }
    
    // Enviar dir a la otra vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "direccionView" {
            
            let nav = segue.destination as! UINavigationController
            let addEventViewController = nav.topViewController as! DireccionViewController
            
            addEventViewController.orderPass = self.orderPass
        }
    }
    
    // Ordenes dinamicas
    
    func insertNewObject(order: Order) {
        items.insert(order, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        contenedorDirecciones.insertRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DireccionesViewCell") as! DireccionesViewCell
        
        let order: Order = items[indexPath.row]

        cell.fecha.text = order.date_add
        cell.referencia.text = order.reference
        cell.total.text = "$\(String(format: "%.2f", Double(order.total_paid)!))"
        cell.pago.text = order.payment
        buscarEstado(web: cell.esttus, order: order)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.orderPass = items[indexPath.row]
        performSegue(withIdentifier: "direccionView", sender: nil)
    }
    
    func buscarEstado(web: UIWebView, order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/order_states/\(order.current_state)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let valor = self.facade.buscarEstado(res: JSON)
                    let estado: String = "<span style=\"background-color:\(valor.color); border-color:\(valor.color);padding: 6px 10px; color: white;\">\(valor.nombre)</span>";
                    web.loadHTMLString(estado, baseURL: nil)                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    @IBAction func btnAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
