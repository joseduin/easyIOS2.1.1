//
//  Producto.swift
//  market
//
//  Created by Jose Duin on 12/14/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Producto {
    
    var id: String
    var id_manufacturer: String
    var id_supplier: String
    var id_category_default: String
    var neew: String
    var cache_default_attribute: String
    var id_default_image: String
    var id_default_combination: String
    var id_tax_rules_group: String
    var position_in_category: String
    var type: String
    var id_shop_default: String
    var reference: String
    var supplier_reference: String
    var location: String
    var width: String
    var height: String
    var depth: String
    var weight: String
    var quantity_discount: String
    var ean13: String
    var upc: String
    var cache_is_pack: String
    var cache_has_attachments: String
    var is_virtual: String
    var on_sale: String
    var online_only: String
    var ecotax: String
    var minimal_quantity: String
    var price: String
    var wholesale_price: String
    var unity: String
    var unit_price_ratio: String
    var additional_shipping_cost: String
    var customizable: String
    var text_fields: String
    var uploadable_files: String
    var active: String
    var redirect_type: String
    var id_product_redirected: String
    var available_for_order: String
    var available_date: String
    var condition: String
    var show_price: String
    var indexed: String
    var visibility: String
    var advanced_stock_management: String
    var date_add: String
    var date_upd: String
    var pack_stock_type: String
    var meta_description: String
    var meta_keywords: String
    var meta_title: String
    var link_rewrite: String
    var name: String
    var description: String
    var description_short: String
    var available_now: String
    var available_later: String
    var categoria: [String]
    var imagenes: [String] = [String]()
    var tags: [String]
    var stock_availables: [String]
    var descuentos: [Descuento]
    var features: [ProductFeatures]
    
    init(id: String, id_manufacturer: String, id_supplier: String, id_category_default: String,neew: String, cache_default_attribute: String, id_default_image: String, id_default_combination: String, id_tax_rules_group: String, position_in_category: String, type: String, id_shop_default: String, reference: String, supplier_reference: String, location: String, width: String, height: String, depth: String, weight: String, quantity_discount: String, ean13: String, upc: String, cache_is_pack: String, cache_has_attachments: String, is_virtual: String, on_sale: String, online_only: String, ecotax: String, minimal_quantity: String, price: String, wholesale_price: String, unity: String, unit_price_ratio: String, additional_shipping_cost: String, customizable: String, text_fields: String, uploadable_files: String, active: String, redirect_type: String, id_product_redirected: String, available_for_order: String, available_date: String, condition: String, show_price: String, indexed: String, visibility: String, advanced_stock_management: String, date_add: String, date_upd: String, pack_stock_type: String, meta_description: String, meta_keywords: String, meta_title: String, link_rewrite: String, name: String, description: String, description_short: String, available_now: String, available_later: String, categoria: [String], imagenes: [String], tags: [String], stock_availables: [String], descuentos: [Descuento], features: [ProductFeatures]) {
        
            self.id = id
            self.id_manufacturer = id_manufacturer
            self.id_supplier = id_supplier
            self.id_category_default = id_category_default
            self.neew = neew
            self.cache_default_attribute = cache_default_attribute
            self.id_default_image = id_default_image
            self.id_default_combination = id_default_combination
            self.id_tax_rules_group = id_tax_rules_group
            self.position_in_category = position_in_category
            self.type = type
            self.id_shop_default = id_shop_default
            self.reference = reference
            self.supplier_reference = supplier_reference
            self.location = location
            self.width = width
            self.height = height
            self.depth = depth
            self.weight = weight
            self.quantity_discount = quantity_discount
            self.ean13 = ean13
            self.upc = upc
            self.cache_is_pack = cache_is_pack
            self.cache_has_attachments = cache_has_attachments
            self.is_virtual = is_virtual
            self.on_sale = on_sale
            self.online_only = online_only
            self.ecotax = ecotax
            self.minimal_quantity = minimal_quantity
            self.price = price
            self.wholesale_price = wholesale_price
            self.unity = unity
            self.unit_price_ratio = unit_price_ratio
            self.additional_shipping_cost = additional_shipping_cost
            self.customizable = customizable
            self.text_fields = text_fields
            self.uploadable_files = uploadable_files
            self.active = active
            self.redirect_type = redirect_type
            self.id_product_redirected = id_product_redirected
            self.available_for_order = available_for_order
            self.available_date = available_date
            self.condition = condition
            self.show_price = show_price
            self.indexed = indexed
            self.visibility = visibility
            self.advanced_stock_management = advanced_stock_management
            self.date_add = date_add
            self.date_upd = date_upd
            self.pack_stock_type = pack_stock_type
            self.meta_description = meta_description
            self.meta_keywords = meta_keywords
            self.meta_title = meta_title
            self.link_rewrite = link_rewrite
            self.name = name
            self.description = description
            self.description_short = description_short
            self.available_now = available_now
            self.available_later = available_later
            self.categoria = categoria
            self.imagenes = imagenes
            self.tags = tags
            self.stock_availables = stock_availables
            self.descuentos = descuentos
            self.features = features
    }
    
    convenience init() {
        self.init(id: "", id_manufacturer: "", id_supplier: "", id_category_default: "",neew: "", cache_default_attribute: "", id_default_image: "", id_default_combination: "", id_tax_rules_group: "", position_in_category: "", type: "", id_shop_default: "", reference: "", supplier_reference: "", location: "", width: "", height: "", depth: "", weight: "", quantity_discount: "", ean13: "", upc: "", cache_is_pack: "", cache_has_attachments: "", is_virtual: "", on_sale: "", online_only: "", ecotax: "", minimal_quantity: "", price: "", wholesale_price: "", unity: "", unit_price_ratio: "", additional_shipping_cost: "", customizable: "", text_fields: "", uploadable_files: "", active: "", redirect_type: "", id_product_redirected: "", available_for_order: "", available_date: "", condition: "", show_price: "", indexed: "", visibility: "", advanced_stock_management: "", date_add: "", date_upd: "", pack_stock_type: "", meta_description: "", meta_keywords: "", meta_title: "", link_rewrite: "", name: "", description: "", description_short: "", available_now: "", available_later: "", categoria: [String](), imagenes: [String](), tags: [String](), stock_availables: [String](), descuentos: [Descuento](), features: [ProductFeatures]())
    }
    
}
