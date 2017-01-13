//
//  DireccionRealViewController.swift
//  market
//
//  Created by Kevin Garcia on 12/24/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//
import UIKit
import Alamofire

class DireccionRealViewController: UIViewController {
    
    // IBOutlet
    
    let facade: Facade = Facade()
    var dirPass: Direccion = Direccion()
    var nuevaDir: Bool = false
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtDireccion1: UITextField!
    @IBOutlet weak var txtDireccion2: UITextField!
    @IBOutlet weak var txtCiudad: UITextField!
    @IBOutlet weak var txtEstado: UITextField!
    @IBOutlet weak var txtPais: UITextField!
    @IBOutlet weak var txtTelefono1: UITextField!
    @IBOutlet weak var txtTelefono2: UITextField!
    @IBOutlet weak var txtAdicional: UITextField!
    @IBOutlet weak var txtAlias: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.dirPass.alias == ""){
            self.navigationItem.title = "Dirección"
            nuevaDir = true
        }else{
            self.navigationItem.title = self.dirPass.alias
            txtNombre.text = dirPass.firstname
            txtApellido.text = dirPass.lastname
            txtCompany.text = dirPass.company
            txtDireccion1.text = dirPass.address1
            txtDireccion2.text = dirPass.address2
            txtCiudad.text = dirPass.city
            txtEstado.text = "Azuay" //dirPass.id_city
            txtPais.text = "Ecuador" //dirPass.id_country 81=ecuador
            txtTelefono1.text = dirPass.phone
            txtTelefono2.text = dirPass.phone_mobile
            txtAdicional.text = dirPass.other
            txtAlias.text = dirPass.alias
            
        }
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Poner los valores en los txt
    }
    
    
    @IBAction func guardar(_ sender: Any) {
        if (nuevaDir) {
            agregarNuevaDireccion()
        } else {
            actualizarDireccion()
            
        }
    }
    
    func actualizarDireccion() {
        let firstname = txtNombre.text
        let lastname = txtApellido.text
        let company = txtCompany.text
        let address1 = txtDireccion1.text
        let address2 = txtDireccion2.text
        let city = txtCiudad.text
        let state = txtEstado.text
        let id_country = "81" //Ecuador
        let phone = txtTelefono1.text
        let phone_mobile = txtTelefono2.text
        let other = txtAdicional.text
        let alias = txtAlias.text
        
        
        if ( (firstname?.isEmpty)! || (lastname?.isEmpty)! || (address1?.isEmpty)! || (city?.isEmpty)! || (state?.isEmpty)! || (id_country.isEmpty) || ((phone?.isEmpty)! && (phone_mobile?.isEmpty)!) || (alias?.isEmpty)!) {
            
            mensaje(mensaje: "Rellene los campos requeridos", cerrar: false)
            return;
        }
        
        let id = dirPass.id //ADDRESS ID?
        
        //POST?
        let params: [String: Any] = ["id": id, "firstname": firstname!, "lastname": lastname!, "company": company!, "address1": address1!, "address2": address2!, "city": city!, "state": state!, "id_country": id_country, "phone": phone!, "phone_mobile": phone_mobile!, "other": other!, "alias": alias!]
        
        Alamofire.request("\(facade.WEB_API_AUX)UAddress.php?id=\(id)", method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON {
            
            
            response in
            switch response.result {
            case .success: break
                
            //case .failure(let error):
            //    self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
            //    print(error)
            default:
                self.mensaje(mensaje: "Cambios guardados!", cerrar: false)
            }
        }
    }
    
    
    func agregarNuevaDireccion(){
        let firstname = txtNombre.text
        let lastname = txtApellido.text
        let company = txtCompany.text
        let address1 = txtDireccion1.text
        let address2 = txtDireccion2.text
        let city = txtCiudad.text
        let state = txtEstado.text
        let id_country = "81" //Ecuador
        let phone = txtTelefono1.text
        let phone_mobile = txtTelefono2.text
        let other = txtAdicional.text
        let alias = txtAlias.text
        
        
        if ((firstname?.isEmpty)! && (lastname?.isEmpty)! && (address1?.isEmpty)! && (city?.isEmpty)! && (state?.isEmpty)! && (id_country.isEmpty) && ((phone?.isEmpty)! || (phone_mobile?.isEmpty)!) && (alias?.isEmpty)!) {
            
            mensaje(mensaje: "Rellene los campos requeridos", cerrar: false)
            return;
        }
        let id_customer = UserDefaults.standard.value(forKey: "id")
        
        
        //POST?
        let params: [String: Any] = ["firstname": firstname!, "lastname": lastname!, "company": company!, "address1": address1!, "address2": address2!, "city": city!, "state": state!, "id_country": id_country, "phone": phone!, "phone_mobile": phone_mobile!, "other": other!, "alias": alias!, "id_customer": id_customer!]
        
        Alamofire.request("\(facade.WEB_API_AUX)CAddress.php?Create=Creating", method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON {
            
            
            response in
            switch response.result {
            case .success: break
                
            //case .failure(let error):
            //    self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
            //    print(error)
            default:
                self.mensaje(mensaje: "Direccióón Registrada!", cerrar: false)
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
    
    @IBAction func btnAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}//class
