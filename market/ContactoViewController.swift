//
//  ContactoViewController.swift
//  market
//
//  Created by Jose Duin on 1/5/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire


class ContactoViewController: UIViewController {
    
    @IBOutlet weak var telefonoMovil: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telefonoFijo: UILabel!
    
    let facade: Facade = Facade()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Contacte con nosotros"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        buscarDatos()
    }
    
    func buscarDatos() {
        Alamofire.request("\(self.facade.WEB_PAGE)/addresses/1?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let direccion: Direccion = self.facade.buscarDireccion(res: JSON)
                    
                    self.telefonoMovil.text = direccion.phone_mobile
                    self.telefonoFijo.text = direccion.phone
                    self.email.text = direccion.other
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func sitioWeb(_ sender: Any) {
        if let url = URL(string: "http://easymarket.ec") {
            UIApplication.shared.open(url)
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

}
