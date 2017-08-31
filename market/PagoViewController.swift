//
//  PagoViewController.swift
//  market
//
//  Created by Jose Duin on 1/9/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit

class PagoViewController: UIViewController {

    @IBOutlet weak var contenedorEfectivo: UIView!
    @IBOutlet weak var contenedorTransferencia: UIView!
    
    @IBOutlet weak var importe: UILabel!
    @IBOutlet weak var propietario: UILabel!
    @IBOutlet weak var datos: UILabel!
    @IBOutlet weak var banco: UILabel!
    @IBOutlet weak var referencia: UILabel!
    
    var payment: String = ""
    var importePass: String = ""
    var propietarioPass: String = ""
    var datosPass: String = ""
    var bancoPass: String = ""
    var referenciaPass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Easy Market"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        contenedorEfectivo.isHidden = true
        contenedorTransferencia.isHidden = true

        if (payment == "Cash on delivery (COD)") {
            contenedorEfectivo.isHidden = false
                
        } else {
            contenedorTransferencia.isHidden = false
                
            importe.text = "- Importe \(importePass)"
            propietario.text = "- Propietario de la cuenta \(propietarioPass)"
            datos.text = "- Con los siguientes datos \(datosPass)"
            banco.text = "- Banco \(bancoPass)"
            referencia.text = "- No se olvde de indicar su número de pedido \(referenciaPass) en el concepto de su tranferencia bancaria"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func irHome(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Inicio2", sender: self)
        //dismiss(animated: true, completion: nil)
    }

}
