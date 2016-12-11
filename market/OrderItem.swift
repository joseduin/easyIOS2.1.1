//
//  OrderItem.swift
//  market
//
//  Created by Jose Duin on 12/7/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class OrderItem {
    
    var id: String
    var product_id: String
    var product_attribute_id: String
    var product_quantity: String
    var product_name: String
    var product_reference: String
    var product_ean13: String
    var product_upc: String
    var product_price: String
    var unit_price_tax_incl: String
    var unit_price_tax_excl: String
    
    init(id: String, product_id: String, product_attribute_id: String, product_quantity: String, product_name: String, product_reference: String, product_ean13: String, product_upc: String, product_price: String, unit_price_tax_incl: String, unit_price_tax_excl: String) {
        
        self.id = id
        self.product_id = product_id
        self.product_attribute_id = product_attribute_id
        self.product_quantity = product_quantity
        self.product_name = product_name
        self.product_reference = product_reference
        self.product_ean13 = product_ean13
        self.product_upc = product_upc
        self.product_price = product_price
        self.unit_price_tax_incl = unit_price_tax_incl
        self.unit_price_tax_excl = unit_price_tax_excl
    }
    
    convenience init() {
        self.init(id: "", product_id: "", product_attribute_id: "", product_quantity: "", product_name: "", product_reference: "", product_ean13: "", product_upc: "", product_price: "", unit_price_tax_incl: "", unit_price_tax_excl: "")
    }
    
}
