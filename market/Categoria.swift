//
//  Categoria.swift
//  market
//
//  Created by Jose Duin on 12/14/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import Foundation

class Categoria {
    
    var id: String
    var id_parent: String
    var level_depth: String
    var nb_products_recursive: String
    var active: String
    var id_shop_default: String
    var is_root_category: String
    var position: String
    var  date_add: String
    var  date_upd: String
    var  name: String
    var link_rewrite: String
    var description: String
    var meta_title: String
    var meta_description: String
    var meta_keywords: String
    var imagen: String
    var imagen_default: String
    var subCategorias: [String]
    var productos: [String]
    
    init(id: String, id_parent: String, level_depth: String, nb_products_recursive: String, active: String, id_shop_default: String, is_root_category: String, position: String,  date_add: String,  date_upd: String,  name: String, link_rewrite: String, description: String, meta_title: String, meta_description: String, meta_keywords: String, imagen: String, imagen_default: String, subCategorias: [String], productos: [String]) {
        
            self.id = id
            self.id_parent = id_parent
            self.level_depth = level_depth
            self.nb_products_recursive = nb_products_recursive
            self.active = active
            self.id_shop_default = id_shop_default
            self.is_root_category = is_root_category
            self.position = position
            self.date_add = date_add
            self.date_upd = date_upd
            self.name = name
            self.link_rewrite = link_rewrite
            self.description = link_rewrite
            self.meta_title = meta_title
            self.meta_description = meta_description
            self.meta_keywords = meta_keywords
            self.imagen = imagen
            self.imagen_default = imagen_default
            self.subCategorias = subCategorias
            self.productos = productos
    }
    
    convenience init() {
        self.init(id: "", id_parent: "", level_depth: "", nb_products_recursive: "", active: "", id_shop_default: "", is_root_category: "", position: "",  date_add: "",  date_upd: "",  name: "", link_rewrite: "", description: "", meta_title: "", meta_description: "", meta_keywords: "", imagen: "", imagen_default: "", subCategorias: [String](), productos: [String]())
    }
    
}
