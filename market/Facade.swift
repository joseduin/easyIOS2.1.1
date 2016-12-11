//
//  Facade.swift
//  market
//
//  Created by Jose Duin on 11/18/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import SwiftyJSON

class Facade {
    
    // Github -> https://github.com/lordedumax/easyIOS.git
    //      lordedumax : 852f77ab4c68936989c71668189ba22c714adf69
    
    let KEY = "ID1TSBAWH6DRZ3TBGY2Q3MK2NJ11KEVT"
    let COOKIE_KEY = "GDgdWYxjQFPOyabc7OCT5zk8L4xB2UZzTyyIzZ7E4KLUOw8g4i67Q9s2"
    
    let WEB_PAGE = "http://easymarket.ec/alpha/api"                             // Configurado
    let WEB_API_AUX = "https://webserviceeasy-kevingn.c9users.io/examples/"     // Configurado
    let ERROR_LOADING = "Revise su conexion a internet"
    
    let STR_DATE_FORMAT = "yyyy-MM-dd"
    
    func parametrosBasicos() -> String {
        return "output_format=JSON&\(parametrosKey())"
    }
    
    func parametrosKey() -> String {
        return "&ws_key=\(KEY)"
    }
    
    func buscarJson(json: JSON, element: String) -> String {
        
        if (!json["\(element)"].exists()) {
            return ""
        } else {
            return json["\(element)"].stringValue
        }
    }
    
    func buscarEstado(res: Any) -> (color: String, nombre: String) {
        let json = JSON(res)
        let elemento = json["order_state"]
        
        let color = buscarJson(json: elemento, element: "color")
        let nombre = buscarJson(json: elemento, element: "name")
        
        return (color, nombre)
    }
    
    // Orders
    
    func existeOrdenes(res: Any) -> [String] {
        var id = [String]()
        let json = JSON(res)
        let array = json["orders"]
        
        for (_, subJson):(String, JSON) in array {
            id.append(subJson["id"].stringValue)
        }
        return id;
    }
    
    func buscarOrden(res: Any) -> Order {
        let json = JSON(res)
        let elemento = json["order"]
        let assocations = json["associations"]
        let array = assocations["order_rows"]
        
        var orderItem = [OrderItem]()
        for (_, subJson):(String, JSON) in array {
            orderItem.append(OrderItem(id: buscarJson(json: subJson, element: "id"),
                                       product_id: buscarJson(json: subJson, element: "product_id"),
                                       product_attribute_id: buscarJson(json: subJson, element: "product_attribute_id"),
                                       product_quantity: buscarJson(json: subJson, element: "product_quantity"),
                                       product_name: buscarJson(json: subJson, element: "product_name"),
                                       product_reference: buscarJson(json: subJson, element: "product_reference"),
                                       product_ean13: buscarJson(json: subJson, element: "product_ean13"),
                                       product_upc: buscarJson(json: subJson, element: "product_upc"),
                                       product_price: buscarJson(json: subJson, element: "product_price"),
                                       unit_price_tax_incl: buscarJson(json: subJson, element: "unit_price_tax_incl"),
                                       unit_price_tax_excl: buscarJson(json: subJson, element: "unit_price_tax_excl")))
        }
        
        return Order(id: buscarJson(json: elemento, element: "id"),
                     id_address_delivery: buscarJson(json: elemento, element: "id_address_delivery"),
                     id_address_invoice: buscarJson(json: elemento, element: "id_address_invoice"),
                     id_cart: buscarJson(json: elemento, element: "id_cart"),
                     id_currency: buscarJson(json: elemento, element: "id_currency"),
                     id_lang: buscarJson(json: elemento, element: "id_lang"),
                     id_customer: buscarJson(json: elemento, element: "id_customer"),
                     id_carrier: buscarJson(json: elemento, element: "id_carrier"),
                     current_state: buscarJson(json: elemento, element: "current_state"),
                     module: buscarJson(json: elemento, element: "module"),
                     invoice_number: buscarJson(json: elemento, element: "invoice_number"),
                     invoice_date: buscarJson(json: elemento, element: "invoice_date"),
                     delivery_number: buscarJson(json: elemento, element: "delivery_number"),
                     delivery_date: buscarJson(json: elemento, element: "delivery_date"),
                     valid: buscarJson(json: elemento, element: "valid"),
                     date_add: buscarJson(json: elemento, element: "date_add"),
                     date_upd: buscarJson(json: elemento, element: "date_upd"),
                     shipping_number: buscarJson(json: elemento, element: "shipping_number"),
                     id_shop_group: buscarJson(json: elemento, element: "id_shop_group"),
                     id_shop: buscarJson(json: elemento, element: "id_shop"),
                     secure_key: buscarJson(json: elemento, element: "secure_key"),
                     payment: buscarJson(json: elemento, element: "payment"),
                     recyclable: buscarJson(json: elemento, element: "recyclable"),
                     gift: buscarJson(json: elemento, element: "gift"),
                     gift_message: buscarJson(json: elemento, element: "gift_message"),
                     mobile_theme: buscarJson(json: elemento, element: "mobile_theme"),
                     total_discounts: buscarJson(json: elemento, element: "total_discounts"),
                     total_discounts_tax_incl: buscarJson(json: elemento, element: "total_discounts_tax_incl"),
                     total_discounts_tax_excl: buscarJson(json: elemento, element: "total_discounts_tax_excl"),
                     total_paid: buscarJson(json: elemento, element: "total_paid"),
                     total_paid_tax_incl: buscarJson(json: elemento, element: "total_paid_tax_incl"),
                     total_paid_tax_excl: buscarJson(json: elemento, element: "total_paid_tax_excl"),
                     total_paid_real: buscarJson(json: elemento, element: "total_paid_real"),
                     total_products: buscarJson(json: elemento, element: "total_products"),
                     total_products_wt: buscarJson(json: elemento, element: "total_products_wt"),
                     total_shipping: buscarJson(json: elemento, element: "total_shipping"),
                     total_shipping_tax_incl: buscarJson(json: elemento, element: "total_shipping_tax_incl"),
                     total_shipping_tax_excl: buscarJson(json: elemento, element: "total_shipping_tax_excl"),
                     carrier_tax_rate: buscarJson(json: elemento, element: "carrier_tax_rate"),
                     total_wrapping: buscarJson(json: elemento, element: "total_wrapping"),
                     total_wrapping_tax_incl: buscarJson(json: elemento, element: "total_wrapping_tax_incl"),
                     total_wrapping_tax_excl: buscarJson(json: elemento, element: "total_wrapping_tax_excl"),
                     round_mode: buscarJson(json: elemento, element: "round_mode"),
                     round_type: buscarJson(json: elemento, element: "round_type"),
                     conversion_rate: buscarJson(json: elemento, element: "conversion_rate"),
                     reference: buscarJson(json: elemento, element: "reference"),
                     productos: orderItem)
    }
    
    // Customers
    
    func existeCustomer(res: Any) -> String {
        var id: String = "no";
        let json = JSON(res)
        let array = json["customers"]

        for (_, subJson):(String, JSON) in array {
            id = subJson["id"].stringValue
        }
        return id;
    }
    
    func buscarCustomer(res: Any) -> Customer {
        let json = JSON(res)
        let elemento = json["customer"]
        
        return Customer(id: buscarJson(json: elemento, element: "id"),
                        date_upd: buscarJson(json: elemento, element: "date_upd"),
                        id_default_group: buscarJson(json: elemento, element: "id_default_group"),
                        id_lang: buscarJson(json: elemento, element: "id_lang"),
                        newsletter_date_add: buscarJson(json: elemento, element: "newsletter_date_add"),
                        ip_registration_newsletter: buscarJson(json: elemento, element: "ip_registration_newsletter"),
                        last_passwd_gen: buscarJson(json: elemento, element: "last_passwd_gen"),
                        secure_key: buscarJson(json: elemento, element: "secure_key"),
                        deleted: buscarJson(json: elemento, element: "deleted"),
                        passwd: buscarJson(json: elemento, element: "passwd"),
                        lastname: buscarJson(json: elemento, element: "lastname"),
                        firstname: buscarJson(json: elemento, element: "firstname"),
                        email: buscarJson(json: elemento, element: "email"),
                        id_gender: buscarJson(json: elemento, element: "id_gender"),
                        birthday: buscarJson(json: elemento, element: "birthday"),
                        newsletter: buscarJson(json: elemento, element: "newsletter"),
                        optin: buscarJson(json: elemento, element: "optin"),
                        website: buscarJson(json: elemento, element: "website"),
                        company: buscarJson(json: elemento, element: "company"),
                        siret: buscarJson(json: elemento, element: "siret"),
                        ape: buscarJson(json: elemento, element: "ape"),
                        outstanding_allow_amount: buscarJson(json: elemento, element: "outstanding_allow_amount"),
                        show_public_prices: buscarJson(json: elemento, element: "show_public_prices"),
                        id_risk: buscarJson(json: elemento, element: "id_risk"),
                        max_payment_days: buscarJson(json: elemento, element: "max_payment_days"),
                        active: buscarJson(json: elemento, element: "active"),
                        note: buscarJson(json: elemento, element: "note"),
                        is_guest: buscarJson(json: elemento, element: "is_guest"),
                        id_shop: buscarJson(json: elemento, element: "id_shop"),
                        id_shop_group: buscarJson(json: elemento, element: "id_shop_group"),
                        date_add: buscarJson(json: elemento, element: "date_add"))
    }
    
    // Conversores
    
    func MD5(string: String) -> String? {
        let cadena = COOKIE_KEY + string
        return cadena.md5()
    }
    
}

