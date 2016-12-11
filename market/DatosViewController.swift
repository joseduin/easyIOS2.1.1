//
//  DatosViewController.swift
//  market
//
//  Created by Jose Duin on 12/6/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire
import LTHRadioButton
import DatePickerDialog

class DatosViewController: UIViewController {
    
    @IBOutlet weak var btnSr: UIButton!
    @IBOutlet weak var btnSra: UIButton!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFechaNac: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var txtReClave: UITextField!
    @IBOutlet weak var txtConfClave: UITextField!
    
    let radioSr = LTHRadioButton(selectedColor: UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1))
    let radioSra = LTHRadioButton(selectedColor: UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1))
    
    let facade: Facade = Facade()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Datos Personales"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        btnSr.addSubview(radioSr)
        btnSra.addSubview(radioSra)
        
        radioSr.select()
        
        // Poner los valores en los txt
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectSr() {
        if (radioSra.isSelected) {
            radioSr.select()
            radioSra.deselect()
        }
    }
    
    @IBAction func selectSra() {
        if (radioSr.isSelected) {
            radioSra.select()
            radioSr.deselect()
        }
    }
    
    @IBAction func btnDatePicker() {
        DatePickerDialog().show(title: "Fecha de Nacimento", doneButtonTitle: "Ok", cancelButtonTitle: "Cancelar", datePickerMode: .date) {
            (date) -> Void in
            if (String(describing: date).isEmpty) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = self.facade.STR_DATE_FORMAT
                
                self.txtFechaNac.text = dateFormatter.string(from: date!)
            }
        }
    }

    @IBAction func guardarDatos() {
        let nombre = txtNombre.text
        let apellido = txtApellido.text
        let correo = txtEmail.text
        let clave = txtClave.text
        
        if ((nombre?.isEmpty)! && (apellido?.isEmpty)! && (correo?.isEmpty)! && (clave?.isEmpty)!) {
            
            mensaje(mensaje: "Rellene los campos requeridos", cerrar: false)
            return;
        }
        
        let id = UserDefaults.standard.value(forKey: "id")
        let genero: String = radioSr.isSelected ? "1" : "2"
        let valor = validarCambioDeClave()
        let reClave = valor  ? txtReClave.text : clave
        
        Alamofire.request("\(facade.WEB_API_AUX)UCustomerData.php?id=\(id)&lstn=\(apellido)&fstn=\(nombre)&eml=\(correo)&gndr=\(genero)&brdy=\(txtFechaNac.text)&pssw=\(facade.MD5(string: clave!))&nwpw=\(reClave)&nwpwcn=\(reClave)").validate().responseJSON {
            
            response in
            switch response.result {
            case .success:
                self.mensaje(mensaje: "Cambios guardados!", cerrar: false)
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)
            }
        }
    }
    
    func validarCambioDeClave() -> Bool {
        if ((txtReClave.text?.isEmpty)! || (txtConfClave.text?.isEmpty)!) {

            
            if (txtReClave.text == txtConfClave.text) {
                return true
            } else {
                mensaje(mensaje: "Contraseñas no coinciden", cerrar: false)
                return false
            }
        }
        return false
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
