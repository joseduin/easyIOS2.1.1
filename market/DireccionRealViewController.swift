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
    
    @IBOutlet weak var ruc: UITextField!
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
            limpiarCampos()
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
    
    func limpiarCampos() {
        txtNombre.text = ""
        txtApellido.text = ""
        ruc.text = ""
        txtCompany.text = ""
        txtDireccion1.text = ""
        txtDireccion2.text = ""
        txtCiudad.text = ""
        txtEstado.text = "Azuay"
        txtPais.text = "Ecuador"
        txtTelefono1.text = ""
        txtTelefono2.text = ""
        txtAdicional.text = ""
        txtAlias.text = ""
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
        let dni = ruc.text
        
        if ( (firstname?.isEmpty)! || (lastname?.isEmpty)! || (dni?.isEmpty)! || (address1?.isEmpty)! || (city?.isEmpty)! || (state?.isEmpty)! || (id_country.isEmpty) || ((phone?.isEmpty)! && (phone_mobile?.isEmpty)!) || (alias?.isEmpty)!) {
            
            mensaje(mensaje: "Rellene los campos requeridos", cerrar: false)
            return;
        }
        
        let idcustomer = "\(UserDefaults.standard.value(forKey: "id")!)"
        let id = dirPass.id //ADDRESS ID?
        
        var request = URLRequest(url: URL(string: "\(facade.WEB_API_AUX)UAddress.php?id=\(id)")!)
        request.httpMethod = "POST"
        let postString = "id_customer=\(idcustomer)&id=\(id)&firstname=\(firstname!)&lastname=\(lastname!)&company=\(company!)&address1=\(address1!)&address2=\(address2!)&city=\(city!)&id_state=313&id_country=81&phone=\(phone!)&phone_mobile=\(phone_mobile!)&other=\(other!)&alias=\(alias!)&dni=\(dni)"
        print("AQUIII \(postString)")
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            DispatchQueue.main.sync {
                self.mensaje(mensaje: "Cambios guardados!", cerrar: true)
            }
        }
        task.resume()
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
        let dni = ruc.text
        
        if ( (firstname?.isEmpty)! || (lastname?.isEmpty)! || (dni?.isEmpty)! || (address1?.isEmpty)! || (city?.isEmpty)! || (state?.isEmpty)! || (id_country.isEmpty) || ((phone?.isEmpty)! && (phone_mobile?.isEmpty)!) || (alias?.isEmpty)!) {
            
            mensaje(mensaje: "Rellene los campos requeridos", cerrar: false)
            return;
        }
        
        let idcustomer = "\(UserDefaults.standard.value(forKey: "id")!)"
        let id = dirPass.id //ADDRESS ID?
        
        var request = URLRequest(url: URL(string: "\(facade.WEB_API_AUX)CAddress.php?Create=Creating")!)
        request.httpMethod = "POST"
        let postString = "id_customer=\(idcustomer)&id=\(id)&firstname=\(firstname!)&lastname=\(lastname!)&company=\(company!)&address1=\(address1!)&address2=\(address2!)&city=\(city!)&id_state=313&id_country=81&phone=\(phone!)&phone_mobile=\(phone_mobile!)&other=\(other!)&alias=\(alias!)&dni=\(dni)"
        print("AQUIII \(postString)")
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            DispatchQueue.main.sync {
                self.mensaje(mensaje: "Direccióón Registrada!", cerrar: true)
            }
        }
        task.resume()
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
