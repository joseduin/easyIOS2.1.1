//
//  Carrier.swift
//  market
//
//  Created by Kevin Garcia on 12/21/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Carrier {
    
    var id: String
    var deleted: String
    var is_module: String
    var id_tax_rules_group: String      // 1.- TIENE IVA                           0.- NO TIENE IVA
    var id_reference: String
    var name: String
    var active: String
    var is_free: String
    var url: String
    var shipping_handling: String       // COSTES DE MANIPULACION 1.- SI            0.- NO
    var shipping_external: String
    var range_behavior: String          //1.- Aplicar el coste mas alto de la gama  0.- Desabilitar transportista
    var shipping_method: String
    var max_width: String
    var max_height: String
    var max_depth: String
    var max_weight: String
    var grade: String
    var external_module_name: String
    var need_range: String
    var position: String
    var delay: String
    var deliveries: Deliveries
    
    init(delay: String, id: String, deleted: String, is_module: String, id_tax_rules_group: String, id_reference: String, name: String, active: String, is_free: String, url: String, shipping_handling: String, shipping_external: String, range_behavior: String, shipping_method: String, max_width: String, max_height: String, max_depth: String, max_weight: String, grade: String, external_module_name: String, need_range: String, position: String, deliveries: Deliveries) {
        
        self.delay = delay
        self.id = id
        self.deleted = deleted
        self.is_module = is_module
        self.id_tax_rules_group = id_tax_rules_group
        self.id_reference = id_reference
        self.name = name
        self.active = active
        self.is_free = is_free
        self.url = url
        self.shipping_handling = shipping_handling
        self.shipping_external = shipping_external
        self.range_behavior = range_behavior
        self.shipping_method = shipping_method
        self.max_width = max_width
        self.max_height = max_height
        self.max_depth = max_depth
        self.max_weight = max_weight
        self.grade = grade
        self.external_module_name = external_module_name
        self.need_range = need_range
        self.position = position
        self.deliveries = deliveries
    }
    
    convenience init() {
        self.init(delay: "",
                  id: "",
                  deleted: "",
                  is_module: "",
                  id_tax_rules_group: "",
                  id_reference: "",
                  name: "",
                  active: "",
                  is_free: "",
                  url: "",
                  shipping_handling: "",
                  shipping_external: "",
                  range_behavior: "",
                  shipping_method: "",
                  max_width: "",
                  max_height: "",
                  max_depth: "",
                  max_weight: "",
                  grade: "",
                  external_module_name: "",
                  need_range: "",
                  position: "",
                  deliveries: Deliveries())
    }
}
