//
//  CarritoDetalle.swift
//  market
//
//  Created by Jose Duin on 12/21/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class CarritoDetalle {
    
    var id_product: String
    var id_product_attribute: String
    var id_address_delivery: String
    var quantity: String
    
    init(id_product: String, id_product_attribute: String, id_address_delivery: String, quantity: String) {
        self.id_product = id_product
        self.id_product_attribute = id_product_attribute
        self.id_address_delivery = id_address_delivery
        self.quantity = quantity
    }

    convenience init() {
        self.init(id_product: "", id_product_attribute: "", id_address_delivery: "", quantity: "")
    }
    
}
