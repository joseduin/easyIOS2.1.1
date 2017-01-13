//
//  RegistroViewController.swift
//  market
//
//  Created by Jose Duin on 11/18/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire
import LTHRadioButton
import DatePickerDialog

class RegistroViewController: UIViewController {
    
    // Probar esta verga

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!
    @IBOutlet weak var f_nacimiento: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var clave: UITextField!
    @IBOutlet weak var dir: UITextField!
    @IBOutlet weak var dir2: UITextField!
    @IBOutlet weak var ciudad: UITextField!
    @IBOutlet weak var pais: UITextField!
    @IBOutlet weak var estado: UITextField!
    @IBOutlet weak var adicional: UITextField!
    @IBOutlet weak var tlf: UITextField!
    @IBOutlet weak var tlf_m: UITextField!
    @IBOutlet weak var alias: UITextField!
    @IBOutlet weak var btnSr: UIButton!
    @IBOutlet weak var btnSra: UIButton!
    @IBOutlet weak var contenedor_principal: UIView!
    @IBOutlet weak var contenedor_direccion: UIView!
    
    let radioSr = LTHRadioButton(selectedColor: UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1))
    let radioSra = LTHRadioButton(selectedColor: UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1))
    
    let facade: Facade = Facade()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Registrarse"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        btnSr.addSubview(radioSr)
        btnSra.addSubview(radioSra)
        
        radioSr.select()
        
        contenedor_direccion.isHidden = true
        pais.text = "Ecuador"
        estado.text = "Azuay"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func selectRadioSr(_ sender: Any) {
        if (radioSra.isSelected) {
            radioSr.select()
            radioSra.deselect()
        }
    }
    @IBAction func selectRadioSra() {
        if (radioSr.isSelected) {
            radioSra.select()
            radioSr.deselect()
        }
    }
 
    
    @IBAction func btnDatePicker(_ sender: Any) {
        DatePickerDialog().show(title: "Fecha de Nacimento", doneButtonTitle: "Ok", cancelButtonTitle: "Cancelar", datePickerMode: .date) {
            (date) -> Void in
            if (String(describing: date).isEmpty) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = self.facade.STR_DATE_FORMAT
                
                self.f_nacimiento.text = dateFormatter.string(from: date!)
            }
        }
    }
    
    @IBAction func btnSiguiente(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.contenedor_principal.isHidden = true
            self.contenedor_direccion.isHidden = false
        })
    }
    
    @IBAction func btnRegistrarse(_ sender: Any) {
        let nom = nombre.text
        let ape = apellido.text
        let fnac = f_nacimiento.text
        let email = correo.text!
        let cla = clave.text
        let d1 = dir.text
        let d2 = dir2.text
        let city = ciudad.text
        let country = pais.text
        let state = estado.text
        let add = adicional.text
        let tele = tlf.text
        let tele_m = tlf_m.text
        let alia = alias.text
        
        if ((nom?.isEmpty)! && (ape?.isEmpty)! && (fnac?.isEmpty)! && (email.isEmpty) && (cla?.isEmpty)! && (d1?.isEmpty)! && (d2?.isEmpty)! && (city?.isEmpty)! && (country?.isEmpty)! && (state?.isEmpty)! && (add?.isEmpty)! && (alia?.isEmpty)! && ((tele?.isEmpty)! || (tele_m?.isEmpty)!)) {
            
            mensaje(mensaje: "Todos los campos son requeridos", cerrar: false)
            return;
        }
        
        let genero: String = radioSr.isSelected ? "1" : "2"
        let params: Parameters = ["firstname": "\(nom)",
                                "lastname": "\(ape)",
                                "birthday": "\(fnac)",
                                "email": "\(email)",
                                "passwd": "\(cla)",
                                "id_gender": genero]

        
        Alamofire.request("\(facade.WEB_API_AUX)CCustomer.php?Create=Creating", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success: break
                
            //case .failure(let error):
            //    self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
            //    print(error)
            default:
              self.buscarCustomerId(nom: nom!, ape: ape!, email: email);
            }
        }
    }
    
    func buscarCustomerId(nom: String, ape: String, email: String) {
        Alamofire.request("\(facade.WEB_PAGE)/customers?filter[firstname]=\(nom)&filter[lastname]=\(ape)&filter[email]=\(email)&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    
                    let id: String = self.facade.existeCustomer(res: JSON);
                    self.agregarNuevaDireccion(id: id);
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)
            }
        }

    }
    
    func agregarNuevaDireccion(id: String) {
        let telefono: String = (tlf.text?.isEmpty)! ? "" : tlf.text!
        let movil: String = (tlf_m.text?.isEmpty)! ? "" : tlf_m.text!
        
        let params: Parameters = ["id_customer": "\(id)",
                                "id_country": "81",
                                "id_state": "313",
                                "alias": "\(alias.text)",
                                "firstname": "\(nombre.text)",
                                "lastname": "\(apellido)",
                                "phone": "\(telefono)",
                                "address1": "\(dir.text)",
                                "address2": "\(dir2.text)",
                                "city": "\(ciudad.text)",
                                "phone_mobile": "\(movil)",
                                "other": "\(adicional.text)"]
        
        
 
        Alamofire.request("\(facade.WEB_API_AUX)CAddress.php?Create=Creating", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success: break
                
            //case .failure(let error):
            //    self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
            //    print(error)
            default:
                self.buscarCustomer(id: id);
            }
        }
    }
    
    func buscarCustomer(id: String) {
        Alamofire.request("\(facade.WEB_PAGE)/customers/\(id)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let customer = self.facade.buscarCustomer(res: JSON)
                    self.login(customer: customer)
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)
            }
        }
        
    }
    
    func login(customer: Customer) {
        UserDefaults.standard.set(true, forKey: "isLogin")
        
        UserDefaults.standard.setValue(customer.id, forKey: "id")
        UserDefaults.standard.setValue(customer.lastname, forKey: "lastname")
        UserDefaults.standard.setValue(customer.firstname, forKey: "firstname")
        UserDefaults.standard.setValue(customer.email, forKey: "email")
        UserDefaults.standard.setValue(customer.id_gender, forKey: "id_gender")
        UserDefaults.standard.setValue(customer.birthday, forKey: "birthday")
        UserDefaults.standard.setValue(customer.company, forKey: "company")
        UserDefaults.standard.setValue(customer.passwd, forKey: "password")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "inicioView", sender: self)
    }
    
    

    @IBAction func btnAtras(_ sender: Any) {
        if (contenedor_principal.isHidden) {
            UIView.animate(withDuration: 0.2, animations: {
                self.contenedor_principal.isHidden = false
                self.contenedor_direccion.isHidden = true
            })
        } else {
            self.dismiss(animated: true, completion: nil)
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
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
