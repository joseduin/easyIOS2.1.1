//
//  Delivery.swift
//  market
//
//  Created by Kevin Garcia on 12/21/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Deliveries {
    
    var id: String
    var id_range_price: String
    var id_range_weight: String
    var id_zone: String
    var id_shop_group: String
    var price: String
    
    init(id: String, id_range_price: String, id_range_weight: String, id_zone: String, id_shop_group: String, price: String) {
        self.id = id;
        self.id_range_price = id_range_price;
        self.id_range_weight = id_range_weight;
        self.id_zone = id_zone;
        self.id_shop_group = id_shop_group;
        self.price = price;
    }
    
    convenience init() {
        self.init(id: "", id_range_price: "", id_range_weight: "", id_zone: "", id_shop_group: "", price: "")
    }
    
}
