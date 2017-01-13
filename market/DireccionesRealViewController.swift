//
//  DireccionesRealController.swift
//  market
//
//  Created by Kevin Garcia on 12/24/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire

class DireccionesRealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // IBOutlet
    
    @IBOutlet weak var contenedorDirecciones: UITableView!
    
    var items = [Direccion]()
    var ids = [String]()
    var dirPass: Direccion = Direccion()
    
    let facade: Facade = Facade()
    var direccionRealViewController: DireccionRealViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Mis Direcciones"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        contenedorDirecciones.delegate = self
        contenedorDirecciones.dataSource = self
        contenedorDirecciones.separatorStyle = .none
        contenedorDirecciones.backgroundColor = UIColor.clear
        contenedorDirecciones.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        
        existenDirecciones()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func existenDirecciones() {
        let id: String = UserDefaults.standard.string(forKey: "id")!
        
        Alamofire.request("\(facade.WEB_PAGE)/addresses?filter[id_customer]=\(id)&sort=[id_DESC]&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.ids = self.facade.existenDirecciones(res: JSON);
                    
                    if (self.ids.count > 0) {
                        self.buscarDireccion(hijo: 0);
                    } else {
                        self.mensaje(mensaje: "Ud aún no tiene direcciones registradas.", cerrar: true);
                    }
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarDireccion(hijo: Int) {
        Alamofire.request("\(facade.WEB_PAGE)/addresses/\(self.ids[hijo])?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let dir: Direccion = self.facade.buscarDireccion(res: JSON)
                    self.seguirBuscando(dir: dir, hijo: hijo);
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func seguirBuscando(dir: Direccion, hijo: Int) {
        insertNewObject(dir: dir)
        
        let hijoAux = hijo + 1
        if (hijoAux < ids.count) {
            buscarDireccion(hijo: hijoAux)
        }
    }
    
    // Enviar dir a la otra vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "direccionRealView" {
            
            let nav = segue.destination as! UINavigationController
            let addEventViewController = nav.topViewController as! DireccionRealViewController
            
            addEventViewController.dirPass = self.dirPass
            
        }
    }
    
    // Direcciones dinamicas
    
    func insertNewObject(dir: Direccion) {
        items.append(dir)
        contenedorDirecciones.reloadData()
        //let indexPath = IndexPath(row: 0, section: 0)
        //contenedorDirecciones.insertRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    /*******************************CELL***********************************************************/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DireccionesRealViewCell") as! DireccionesRealViewCell
        
        let dir: Direccion = items[indexPath.row]
        
        cell.nombre.text = dir.firstname
        cell.apellido.text = dir.lastname
        cell.company.text = dir.company
        cell.direccion1.text = dir.address1
        cell.ciudad.text = dir.city
        cell.pais.text = "Ecuador"
        cell.direccion2.text = dir.address2
        cell.alias.text = dir.alias
        cell.telefono1.text = dir.phone
        cell.telefono2.text = dir.phone_mobile
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dirPass = items[indexPath.row]
        
        performSegue(withIdentifier: "direccionRealView", sender: nil)
        
        
    }
    /*
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
     */
   
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
    
    
    
    
    
    func borrarDireccion(dir: Direccion, hijo: CFIndex) {
        
        if (ids.count == 1) {
            self.mensaje(mensaje: "No puede borrar todas las direcciones", cerrar: false);
            return;
        }
        
        
        Alamofire.request("\(facade.WEB_API_AUX)/DAddress?DeleteID=/\(self.ids[hijo])?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success: break
                
                
            //case .failure( _):
            //    self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
            default:
                if response.result.value != nil {
                    //  mContainerView.removeViewAt(hijo);              REMOVER DE VISTA
                    self.ids.remove(at: hijo);
                    self.mensaje(mensaje: "Se elimino correctamente la direccion", cerrar: false);
                }
            }
        }
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
