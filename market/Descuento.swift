//
//  Descuento.swift
//  market
//
//  Created by Jose Duin on 12/14/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Descuento {
    
    var id: String
    var id_shop_group: String
    var id_shop: String
    var id_cart: String
    var id_product: String
    var id_product_attribute: String
    var id_currency: String
    var id_country: String
    var id_group: String
    var id_customer: String
    var id_specific_price_rule: String
    var price: String
    var from_quantity: String
    var reduction: String
    var reduction_tax: String
    var reduction_type: String
    var from: String
    var to: String
    
    init(id: String, id_shop_group: String, id_shop: String, id_cart: String, id_product: String, id_product_attribute: String, id_currency: String, id_country: String, id_group: String, id_customer: String, id_specific_price_rule: String, price: String, from_quantity: String, reduction: String, reduction_tax: String, reduction_type: String, from: String, to: String) {
        
        self.id = id
        self.id_shop_group = id_shop_group
        self.id_shop = id_shop
        self.id_cart = id_cart
        self.id_product = id_product
        self.id_product_attribute = id_product_attribute
        self.id_currency = id_currency
        self.id_country = id_country
        self.id_group = id_group
        self.id_customer = id_customer
        self.id_specific_price_rule = id_specific_price_rule
        self.price = price
        self.from_quantity = from_quantity
        self.reduction = reduction
        self.reduction_tax = reduction_tax
        self.reduction_type = reduction_type
        self.from = from
        self.to = to
    }
    
    convenience init() {
        self.init(id: "", id_shop_group: "", id_shop: "", id_cart: "", id_product: "", id_product_attribute: "", id_currency: "", id_country: "", id_group: "", id_customer: "", id_specific_price_rule: "", price: "", from_quantity: "", reduction: "", reduction_tax: "", reduction_type: "", from: "", to: "")
    }
    
}
