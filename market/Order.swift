//
//  Order.swift
//  market
//
//  Created by Jose Duin on 12/7/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Order {
    
    var id: String
    var id_address_delivery: String
    var id_address_invoice: String
    var id_cart: String
    var id_currency: String
    var id_lang: String
    var id_customer: String
    var id_carrier: String
    var current_state: String
    var module: String
    var invoice_number: String
    var invoice_date: String
    var delivery_number: String
    var delivery_date: String
    var valid: String
    var date_add: String
    var date_upd: String
    var shipping_number: String
    var id_shop_group: String
    var id_shop: String
    var secure_key: String
    var payment: String
    var recyclable: String
    var gift: String
    var gift_message: String
    var mobile_theme: String
    var total_discounts: String
    var total_discounts_tax_incl: String
    var total_discounts_tax_excl: String
    var total_paid: String
    var total_paid_tax_incl: String
    var total_paid_tax_excl: String
    var total_paid_real: String
    var total_products: String
    var total_products_wt: String
    var total_shipping: String
    var total_shipping_tax_incl: String
    var total_shipping_tax_excl: String
    var carrier_tax_rate: String
    var total_wrapping: String
    var total_wrapping_tax_incl: String
    var total_wrapping_tax_excl: String
    var round_mode: String
    var round_type: String
    var conversion_rate: String
    var reference: String
    var productos: [OrderItem]
    
    init(id: String, id_address_delivery: String, id_address_invoice: String, id_cart: String, id_currency: String, id_lang: String, id_customer: String, id_carrier: String, current_state: String, module: String, invoice_number: String, invoice_date: String, delivery_number: String, delivery_date: String, valid: String, date_add: String, date_upd: String, shipping_number: String, id_shop_group: String, id_shop: String, secure_key: String, payment: String, recyclable: String, gift: String, gift_message: String, mobile_theme: String, total_discounts: String, total_discounts_tax_incl: String, total_discounts_tax_excl: String, total_paid: String, total_paid_tax_incl: String, total_paid_tax_excl: String, total_paid_real: String, total_products: String, total_products_wt: String, total_shipping: String, total_shipping_tax_incl: String, total_shipping_tax_excl: String, carrier_tax_rate: String, total_wrapping: String, total_wrapping_tax_incl: String, total_wrapping_tax_excl: String, round_mode: String, round_type: String, conversion_rate: String, reference: String, productos: [OrderItem]) {
        
            self.id = id
            self.id_address_delivery = id_address_delivery
            self.id_address_invoice = id_address_invoice
            self.id_cart = id_cart
            self.id_currency = id_currency
            self.id_lang = id_lang
            self.id_customer = id_customer
            self.id_carrier = id_carrier
            self.current_state = current_state
            self.module = module
            self.invoice_number = invoice_number
            self.invoice_date = invoice_date
            self.delivery_number = delivery_number
            self.delivery_date = delivery_date
            self.valid = valid
            self.date_add = date_add
            self.date_upd = date_upd
            self.shipping_number = shipping_number
            self.id_shop_group = id_shop_group
            self.id_shop = id_shop
            self.secure_key = secure_key
            self.payment = payment
            self.recyclable = recyclable
            self.gift = gift
            self.gift_message = gift_message
            self.mobile_theme = mobile_theme
            self.total_discounts = total_discounts
            self.total_discounts_tax_incl = total_discounts_tax_incl
            self.total_discounts_tax_excl = total_discounts_tax_excl
            self.total_paid = total_paid
            self.total_paid_tax_incl = total_paid_tax_incl
            self.total_paid_tax_excl = total_paid_tax_excl
            self.total_paid_real = total_paid_real
            self.total_products = total_products
            self.total_products_wt = total_products_wt
            self.total_shipping = total_shipping
            self.total_shipping_tax_incl = total_shipping_tax_incl
            self.total_shipping_tax_excl = total_shipping_tax_excl
            self.carrier_tax_rate = carrier_tax_rate
            self.total_wrapping = total_wrapping
            self.total_wrapping_tax_incl = total_wrapping_tax_incl
            self.total_wrapping_tax_excl = total_wrapping_tax_excl
            self.round_mode = round_mode
            self.round_type = round_type
            self.conversion_rate = conversion_rate
            self.reference = reference
            self.productos = productos
    }
    
    convenience init() {
        self.init(id: "", id_address_delivery: "", id_address_invoice: "", id_cart: "", id_currency: "", id_lang: "", id_customer: "", id_carrier: "", current_state: "", module: "", invoice_number: "", invoice_date: "", delivery_number: "", delivery_date: "", valid: "", date_add: "", date_upd: "", shipping_number: "", id_shop_group: "", id_shop: "", secure_key: "", payment: "", recyclable: "", gift: "", gift_message: "", mobile_theme: "", total_discounts: "", total_discounts_tax_incl: "", total_discounts_tax_excl: "", total_paid: "", total_paid_tax_incl: "", total_paid_tax_excl: "", total_paid_real: "", total_products: "", total_products_wt: "", total_shipping: "", total_shipping_tax_incl: "", total_shipping_tax_excl: "", carrier_tax_rate: "", total_wrapping: "", total_wrapping_tax_incl: "", total_wrapping_tax_excl: "", round_mode: "", round_type: "", conversion_rate: "", reference: "", productos: [OrderItem]())
    }
    
    
}
