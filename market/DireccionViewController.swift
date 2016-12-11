//
//  DireccionViewController.swift
//  market
//
//  Created by Jose Duin on 12/7/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit

class DireccionViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var orderPass: Order = Order()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inicializarPantalla(order: orderPass)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inicializarPantalla(order: Order) {
        label.text = order.payment
    }
    

}
