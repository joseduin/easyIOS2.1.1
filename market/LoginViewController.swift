//
//  LoginViewController.swift
//  market
//
//  Created by Jose Duin on 11/18/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    // Implementar .resignFirstResponder() en todas las vistas con textFiedl

    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    
    let facade: Facade = Facade()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Easy Market"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        txtCorreo.resignFirstResponder()
        txtContraseña.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnIngresar(_ sender: Any) {
        let correo = txtCorreo.text
        let contraseña = txtContraseña.text
        
        if ((correo?.isEmpty)! || (contraseña?.isEmpty)!) {
            
            mensaje(mensaje: "Todos los campos son requeridos", cerrar: false)
            return;
        }
        
        existeCustomer(email: correo!, password: contraseña!)
    }
    
    func existeCustomer(email: String, password: String) {
        let pass = facade.MD5(string: password)

        Alamofire.request("\(facade.WEB_PAGE)/customers?filter[passwd]=\(pass!)&filter[email]=\(email)&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        let existe = self.facade.existeCustomer(res: JSON)

                        if (existe != "no") {
                            self.buscarCustomer(id: existe);
                        } else {
                            self.mensaje(mensaje: "La combinación de correo/contraseña incorrecta", cerrar: false);
                        }
                    }
                case .failure(let error):
                    self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                    print(error)
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
                print(error)        // Poner en comentario
            }
        }
    }
    
    func login(customer: Customer) {
        
        UserDefaults.standard.set(true, forKey: "isLogin")

        UserDefaults.standard.set(customer.id, forKey: "id")
        UserDefaults.standard.set(customer.lastname, forKey: "lastname")
        UserDefaults.standard.set(customer.firstname, forKey: "firstname")
        UserDefaults.standard.set(customer.email, forKey: "email")
        UserDefaults.standard.set(customer.id_gender, forKey: "id_gender")
        UserDefaults.standard.set(customer.birthday, forKey: "birthday")
        UserDefaults.standard.set(customer.company, forKey: "company")
        UserDefaults.standard.set(customer.passwd, forKey: "password")
        UserDefaults.standard.synchronize()
        
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
