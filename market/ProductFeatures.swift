//
//  ProductFeatures.swift
//  market
//
//  Created by Jose Duin on 12/14/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class ProductFeatures {
    
    var id: String
    var id_feature_value: String
    
    init(id: String, id_feature_value: String) {
        self.id = id
        self.id_feature_value = id_feature_value
    }

    convenience init() {
        self.init(id: "", id_feature_value: "")
    }
}
