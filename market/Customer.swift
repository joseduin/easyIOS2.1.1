//
//  Customer.swift
//  market
//
//  Created by Jose Duin on 11/20/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Customer {
    
    var id : String
    var id_default_group : String
    var id_lang : String
    var newsletter_date_add : String
    var ip_registration_newsletter : String
    var last_passwd_gen : String
    var secure_key : String
    var deleted : String
    var passwd : String
    var lastname : String
    var firstname : String
    var email : String
    var id_gender : String
    var birthday : String
    var newsletter : String
    var optin : String
    var website : String
    var company : String
    var siret : String
    var ape : String
    var outstanding_allow_amount : String
    var show_public_prices : String
    var id_risk : String
    var max_payment_days : String
    var active : String
    var note : String
    var is_guest : String
    var id_shop : String
    var id_shop_group : String
    var date_add : String
    var date_upd : String
    
    init(id: String, date_upd: String, id_default_group: String, id_lang: String, newsletter_date_add: String, ip_registration_newsletter: String, last_passwd_gen: String, secure_key: String, deleted: String,passwd: String,lastname: String,firstname: String,email: String,id_gender: String,birthday: String,newsletter: String,optin: String,website: String,company: String,siret: String,ape: String,outstanding_allow_amount: String,show_public_prices: String,id_risk: String,max_payment_days: String,active: String,note: String,is_guest: String,id_shop: String,id_shop_group: String, date_add: String) {
        
        self.id = id;
        self.date_upd = date_upd;
        self.id_default_group = id_default_group;
        self.id_lang = id_lang;
        self.newsletter_date_add = newsletter_date_add;
        self.ip_registration_newsletter = ip_registration_newsletter;
        self.last_passwd_gen = last_passwd_gen;
        self.secure_key = secure_key;
        self.deleted = deleted;
        self.passwd = passwd;
        self.lastname = lastname;
        self.firstname = firstname;
        self.email = email;
        self.id_gender = id_gender;
        self.birthday = birthday;
        self.newsletter = newsletter;
        self.optin = optin;
        self.website = website;
        self.company = company;
        self.siret = siret;
        self.ape = ape;
        self.outstanding_allow_amount = outstanding_allow_amount;
        self.show_public_prices = show_public_prices;
        self.id_risk = id_risk;
        self.max_payment_days = max_payment_days;
        self.active = active;
        self.note = note;
        self.is_guest = is_guest;
        self.id_shop = id_shop;
        self.id_shop_group = id_shop_group;
        self.date_add = date_add;
    }
}
