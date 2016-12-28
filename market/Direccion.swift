//
//  Direccion.swift
//  market
//
//  Created by Kevin Garcia on 12/21/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Direccion {
    
    var id: String
    var id_customer: String
    var id_manufacturer: String
    var id_supplier: String
    var id_warehouse: String
    var id_country: String
    var id_state: String
    var alias: String
    var company: String
    var lastname: String
    var firstname: String
    var vat_number: String
    var address1: String
    var address2: String
    var postcode: String
    var city: String
    var other: String
    var phone: String
    var phone_mobile: String
    var dni: String
    var deleted: String
    var date_add: String
    var date_upd: String
    
    init(id: String, id_customer: String, id_manufacturer: String, id_supplier: String, id_warehouse: String, id_country: String, id_state: String, alias: String, company: String, lastname: String, firstname: String, vat_number: String, address1: String, address2: String, postcode: String, city: String, other: String, phone: String, phone_mobile: String, dni: String, deleted: String, date_add: String, date_upd: String) {
        self.id = id
        self.id_customer = id_customer
        self.id_manufacturer = id_manufacturer
        self.id_supplier = id_supplier
        self.id_warehouse = id_warehouse
        self.id_country = id_country
        self.id_state = id_state
        self.alias = alias
        self.company = company
        self.lastname = lastname
        self.firstname = firstname
        self.vat_number = vat_number
        self.address1 = address1
        self.address2 = address2
        self.postcode = postcode
        self.city = city
        self.other = other
        self.phone = phone
        self.phone_mobile = phone_mobile
        self.dni = dni
        self.deleted = deleted
        self.date_add = date_add
        self.date_upd = date_upd
    }
    
    
    convenience init() {
        self.init(id: "", id_customer: "", id_manufacturer: "", id_supplier: "", id_warehouse: "", id_country: "", id_state: "", alias: "", company: "", lastname: "", firstname: "", vat_number: "", address1: "", address2: "", postcode: "", city: "", other: "", phone: "", phone_mobile: "", dni: "", deleted: "", date_add: "", date_upd: "")
    }
}
