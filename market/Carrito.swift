//
//  Carrito.swift
//  market
//
//  Created by Jose Duin on 12/21/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Carrito {
    
    var id: String
    var id_address_delivery: String
    var id_address_invoice: String
    var id_currency: String
    var id_customer: String
    var id_guest: String
    var id_lang: String
    var id_shop_group: String
    var id_shop: String
    var id_carrier: String
    var recyclable: String
    var gift: String
    var gift_message: String
    var mobile_theme: String
    var delivery_option: String             // Pedido
    var secure_key: String
    var allow_seperated_package: String
    var date_add: String
    var date_upd: String
    var carritoDetalles: [CarritoDetalle]
    
    init(id: String,id_address_delivery: String,id_address_invoice: String,id_currency: String,id_customer: String,id_guest: String,id_lang: String,id_shop_group: String,id_shop: String,id_carrier: String,recyclable: String,gift: String,gift_message: String,mobile_theme: String,delivery_option: String,secure_key: String,allow_seperated_package: String,date_add: String,date_upd: String,carritoDetalles: [CarritoDetalle]) {
        
            self.id = id
            self.id_address_delivery = id_address_delivery
            self.id_address_invoice = id_address_invoice
            self.id_currency = id_currency
            self.id_customer = id_customer
            self.id_guest = id_guest
            self.id_lang = id_lang
            self.id_shop_group = id_shop_group
            self.id_shop = id_shop
            self.id_carrier = id_carrier
            self.recyclable = recyclable
            self.gift = gift
            self.gift_message = gift_message
            self.mobile_theme = mobile_theme
            self.delivery_option = delivery_option
            self.secure_key = secure_key
            self.allow_seperated_package = allow_seperated_package
            self.date_add = date_add
            self.date_upd = date_upd
            self.carritoDetalles = carritoDetalles
    }
    
    convenience init() {
        self.init(id: "",id_address_delivery: "",id_address_invoice: "",id_currency: "",id_customer: "",id_guest: "",id_lang: "",id_shop_group: "",id_shop: "",id_carrier: "",recyclable: "",gift: "",gift_message: "",mobile_theme: "",delivery_option: "",secure_key: "",allow_seperated_package: "",date_add: "",date_upd: "",carritoDetalles: [CarritoDetalle]())
    }
}
