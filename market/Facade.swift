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
    let WEB_API_AUX = "https://app-easymarket.com/service/examples/"            // Configurado
    let ERROR_LOADING = "Revise su conexion a internet"
    
    let STR_DATE_FORMAT = "yyyy-MM-dd"
    let IVA: Double = 12.00
    
    func parametrosBasicos() -> String {
        return "output_format=JSON&\(parametrosKey())"
    }
    
    func parametrosKey() -> String {
        return "ws_key=\(KEY)"
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
        return id
    }
    
    func buscarOrden(res: Any) -> Order {
        let json = JSON(res)
        let elemento = json["order"]
        let assocations = elemento["associations"]
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
    
    //Address
    func existenDirecciones(res: Any) -> [String] {
        var id = [String]()
        let json = JSON(res)
        let array = json["addresses"]
        
        for (_, subJson):(String, JSON) in array {
            id.append(subJson["id"].stringValue)
        }
        return id
    }
    
    func buscarDireccion(res: Any) -> Direccion {
        let json = JSON(res)
        let elemento = json["address"]
        return Direccion(id: buscarJson(json: elemento, element: "id"),
                         id_customer: buscarJson(json: elemento, element:"id_customer" ),
                         id_manufacturer: buscarJson(json: elemento, element: "id_manufacturer" ),
                         id_supplier: buscarJson(json: elemento, element: "id_supplier" ),
                         id_warehouse: buscarJson(json: elemento, element: "id_warehouse" ),
                         id_country: buscarJson(json: elemento, element: "id_country" ),
                         id_state: buscarJson(json: elemento, element: "id_state" ),
                         alias: buscarJson(json: elemento, element: "alias" ),
                         company: buscarJson(json: elemento, element: "company" ),
                         lastname: buscarJson(json: elemento, element: "lastname" ),
                         firstname: buscarJson(json: elemento, element: "firstname" ),
                         vat_number: buscarJson(json: elemento, element: "vat_number" ),
                         address1: buscarJson(json: elemento, element: "address1" ),
                         address2: buscarJson(json: elemento, element: "address2" ),
                         postcode: buscarJson(json: elemento, element: "postcode" ),
                         city: buscarJson(json: elemento, element: "city" ),
                         other: buscarJson(json: elemento, element: "other" ),
                         phone: buscarJson(json: elemento, element: "phone" ),
                         phone_mobile: buscarJson(json: elemento, element: "phone_mobile" ),
                         dni: buscarJson(json: elemento, element: "dni" ),
                         deleted: buscarJson(json: elemento, element: "deleted" ),
                         date_add: buscarJson(json: elemento, element: "date_add" ),
                         date_upd: buscarJson(json: elemento, element: "date_upd" )
        )
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
    
    // Categorias
    
    func buscarCategoria(res: Any) -> Categoria {
        let json = JSON(res)
        let elemento = json["category"]
        let assocations = elemento["associations"]
        
        var categorias = [String]()
        if (assocations["categories"].exists()) {
            let categories = assocations["categories"]
            for (_, subJson):(String, JSON) in categories {
                categorias.append(buscarJson(json: subJson, element: "id"))
            }
        }
       
        
        var productos = [String]()
        if (assocations["products"].exists()) {
            let products = assocations["products"]
            for (_, subJson):(String, JSON) in products {
                productos.append(buscarJson(json: subJson, element: "id"))
            }
        }
        
        return Categoria(id: buscarJson(json: elemento, element: "id"),
                         id_parent: buscarJson(json: elemento, element: "id_parent"),
                         level_depth: buscarJson(json: elemento, element: "level_depth"),
                         nb_products_recursive: buscarJson(json: elemento, element: "nb_products_recursive"),
                         active: buscarJson(json: elemento, element: "active"),
                         id_shop_default: buscarJson(json: elemento, element: "id_shop_default"),
                         is_root_category: buscarJson(json: elemento, element: "is_root_category"),
                         position: buscarJson(json: elemento, element: "position"),
                         date_add: buscarJson(json: elemento, element: "date_add"),
                         date_upd: buscarJson(json: elemento, element: "date_upd"),
                         name: buscarJson(json: elemento, element: "name"),
                         link_rewrite: buscarJson(json: elemento, element: "link_rewrite"),
                         description: buscarJson(json: elemento, element: "description"),
                         meta_title: buscarJson(json: elemento, element: "meta_title"),
                         meta_description: buscarJson(json: elemento, element: "meta_description"),
                         meta_keywords: buscarJson(json: elemento, element: "meta_keywords"),
                         imagen: buscarJson(json: elemento, element: "imagen"),
                         imagen_default: buscarJson(json: elemento, element: "imagen_default"),
                         subCategorias: categorias,
                         productos: productos)
    }
    
    // Productos
    
    func buscarProducto(res: Any) -> Producto {
        let json = JSON(res)
        let elemento = json["product"]
        
        return getProductos(elemento: elemento)
    }
    
    func getProductos(elemento: JSON) -> Producto {
        var categoria = [String]();
        var imagenes = [String]();
        var tags = [String]();
        var stock_availables = [String]();
        var features = [ProductFeatures]();
        
        if (elemento["associations"].exists()) {
            let assocations = elemento["associations"]
            
            if (assocations["categories"].exists()) {
                let arrayCategories = assocations["categories"]
                for (_, subJson):(String, JSON) in arrayCategories {
                    categoria.append(buscarJson(json: subJson, element: "id"))
                }
            }
            if (assocations["images"].exists()) {
                let arrayImages = assocations["images"]
                for (_, subJson):(String, JSON) in arrayImages {
                    imagenes.append(buscarJson(json: subJson, element: "id"))
                }
            }
            if (assocations["tags"].exists()) {
                let arrayTags = assocations["tags"]
                for (_, subJson):(String, JSON) in arrayTags {
                    tags.append(buscarJson(json: subJson, element: "id"))
                }
            }
            if (assocations["stock_availables"].exists()) {
                let arrayStock = assocations["stock_availables"]
                for (_, subJson):(String, JSON) in arrayStock {
                    stock_availables.append(buscarJson(json: subJson, element: "id"))
                }
            }
            if (assocations["product_features"].exists()) {
                let arrayFeatures = assocations["product_features"]
                for (_, subJson):(String, JSON) in arrayFeatures {
                    features.append(ProductFeatures(id: buscarJson(json: subJson, element: "id") ,id_feature_value:  buscarJson(json: subJson, element: "id_feature_value")))
                }
            }
        }
        
        return Producto(id: buscarJson(json: elemento, element: "id"),
                        id_manufacturer: buscarJson(json: elemento, element: "id_manufacturer"),
                        id_supplier: buscarJson(json: elemento, element: "id_supplier"),
                        id_category_default: buscarJson(json: elemento, element: "id_category_default"),
                        neew: buscarJson(json: elemento, element: "new"),
                        cache_default_attribute: buscarJson(json: elemento, element: "cache_default_attribute"),
                        id_default_image: buscarJson(json: elemento, element: "id_default_image"),
                        id_default_combination: buscarJson(json: elemento, element: "id_default_combination"),
                        id_tax_rules_group: buscarJson(json: elemento, element: "id_tax_rules_group"),
                        position_in_category: buscarJson(json: elemento, element: "position_in_category"),
                        type: buscarJson(json: elemento, element: "type"),
                        id_shop_default: buscarJson(json: elemento, element: "id_shop_default"),
                        reference: buscarJson(json: elemento, element: "reference"),
                        supplier_reference: buscarJson(json: elemento, element: "supplier_reference"),
                        location: buscarJson(json: elemento, element: "location"),
                        width: buscarJson(json: elemento, element: "width"),
                        height: buscarJson(json: elemento, element: "height"),
                        depth: buscarJson(json: elemento, element: "depth"),
                        weight: buscarJson(json: elemento, element: "weight"),
                        quantity_discount: buscarJson(json: elemento, element: "quantity_discount"),
                        ean13: buscarJson(json: elemento, element: "ean13"),
                        upc: buscarJson(json: elemento, element: "upc"),
                        cache_is_pack: buscarJson(json: elemento, element: "cache_is_pack"),
                        cache_has_attachments: buscarJson(json: elemento, element: "cache_has_attachments"),
                        is_virtual: buscarJson(json: elemento, element: "is_virtual"),
                        on_sale: buscarJson(json: elemento, element: "on_sale"),
                        online_only: buscarJson(json: elemento, element: "online_only"),
                        ecotax: buscarJson(json: elemento, element: "ecotax"),
                        minimal_quantity: buscarJson(json: elemento, element: "minimal_quantity"),
                        price: String(format: "%.2f", Double(buscarJson(json: elemento, element: "price"))! + (Double(buscarJson(json: elemento, element: "price"))! * IVA / 100)),
                        wholesale_price: buscarJson(json: elemento, element: "wholesale_price"),
                        unity: buscarJson(json: elemento, element: "unity"),
                        unit_price_ratio: buscarJson(json: elemento, element: "unit_price_ratio"),
                        additional_shipping_cost: buscarJson(json: elemento, element: "additional_shipping_cost"),
                        customizable: buscarJson(json: elemento, element: "customizable"),
                        text_fields: buscarJson(json: elemento, element: "text_fields"),
                        uploadable_files: buscarJson(json: elemento, element: "uploadable_files"),
                        active: buscarJson(json: elemento, element: "active"),
                        redirect_type: buscarJson(json: elemento, element: "redirect_type"),
                        id_product_redirected: buscarJson(json: elemento, element: "id_product_redirected"),
                        available_for_order: buscarJson(json: elemento, element: "available_for_order"),
                        available_date: buscarJson(json: elemento, element: "available_date"),
                        condition: buscarJson(json: elemento, element: "condition") == "new" ? "Nuevo" : buscarJson(json: elemento, element: "condition") == "used" ? "Usado" : "Renovado",
                        show_price: buscarJson(json: elemento, element: "show_price"),
                        indexed: buscarJson(json: elemento, element: "indexed"),
                        visibility: buscarJson(json: elemento, element: "visibility"),
                        advanced_stock_management: buscarJson(json: elemento, element: "advanced_stock_management"),
                        date_add: buscarJson(json: elemento, element: "date_add"),
                        date_upd: buscarJson(json: elemento, element: "date_upd"),
                        pack_stock_type: buscarJson(json: elemento, element: "pack_stock_type"),
                        meta_description: buscarJson(json: elemento, element: "meta_description"),
                        meta_keywords: buscarJson(json: elemento, element: "meta_keywords"),
                        meta_title: buscarJson(json: elemento, element: "meta_title"),
                        link_rewrite: buscarJson(json: elemento, element: "link_rewrite"),
                        name: buscarJson(json: elemento, element: "name"),
                        description: buscarJson(json: elemento, element: "description"),
                        description_short: buscarJson(json: elemento, element: "description_short"),
                        available_now: buscarJson(json: elemento, element: "available_now"),
                        available_later: buscarJson(json: elemento, element: "available_later"),
                        categoria: categoria,
                        imagenes: imagenes,
                        tags: tags,
                        stock_availables: stock_availables,
                        descuentos: [Descuento](),
                        features: features)
    }
    
    func buscarProductoSearch(res: Any) -> [Producto] {
        var productos: [Producto] = [Producto]()
        let json = JSON(res)
        let array = json["products"]

        for (_, subJson):(String, JSON) in array {
            productos.append(getProductos(elemento: subJson))
        }
        return productos;
    }
    
    func buscarFeatures(res: Any) -> String {
        let json = JSON(res)
        let elemento = json["product_feature_value"]
        
        return buscarJson(json: elemento, element: "value")
    }
    
    func buscarFeaturesMedidas(res: Any) -> String {
        let json = JSON(res)
        let elemento = json["product_feature"]
        
        return buscarJson(json: elemento, element: "name")
    }
    
    func buscarStock(res: Any) -> String {
        let json = JSON(res)
        let elemento = json["stock_available"]
        
        return buscarJson(json: elemento, element: "quantity") == "0" ? "No está disponible" : buscarJson(json: elemento, element: "quantity")
    }
    
    //Deliveries
    func buscarDeliveries(res: Any) -> Array<String> {
        let json = JSON(res)
        var ids: Array<String> = Array<String>();
        if (json == "[]") {
            return ids;
        } else {
            let json = JSON(res)
            let array = json["deliveries"]
            
            for (_, subJson):(String, JSON) in array {
                ids.append(subJson["id"].stringValue)
            }
            return ids;
        }
    }
    
    func buscarDelivery(res: Any) -> Deliveries{
        let json = JSON(res)
        let elemento = json["delivery"]
        
        return Deliveries(id: buscarJson(json: elemento, element: "id"),
                          id_range_price: buscarJson(json: elemento, element: "id_range_price"),
                          id_range_weight: buscarJson(json: elemento,element:  "id_range_weight"),
                          id_zone: buscarJson(json: elemento, element: "id_zone"),
                          id_shop_group: buscarJson(json: elemento, element: "id_shop_group"),
                          price: buscarJson(json: elemento, element: "price")
        )
        
    }
    
    // Carrito
    
    func existeCarrito(res: Any) -> String {
        var id: String = "no"
        let json = JSON(res)
        let array = json["carts"]
        
        for (_, subJson):(String, JSON) in array {
            id = subJson["id"].stringValue
        }
        return id
    }
    
    func buscarCarrito(res: Any) -> Carrito {
        let json = JSON(res)
        let elemento = json["cart"]
        
        var carritoDetalle: [CarritoDetalle] = [CarritoDetalle]()
        
        var existenArticulosEnElCarrito: Bool = true
        
        if (elemento["associations"].exists()) {
            let assocations = elemento["associations"]
            
            
            if (assocations["cart_rows"].exists()) {
                let array = assocations["cart_rows"]
                for (_, subJson):(String, JSON) in array {
                    carritoDetalle.append(CarritoDetalle(id_product: buscarJson(json: subJson, element: "id_productd"),
                                                         id_product_attribute: buscarJson(json: subJson, element: "id_product_attribute"),
                                                         id_address_delivery: buscarJson(json: subJson, element: "id_address_delivery"),
                                                         quantity: buscarJson(json: subJson, element: "quantity")))
                }
            }
        } else {
            existenArticulosEnElCarrito = false        // No se encontraron articulos en el carrito
        }
        
        var carrito: Carrito = Carrito()
        if (!existenArticulosEnElCarrito) {
            carrito.id = "no"
        } else {
            carrito = Carrito(id: buscarJson(json: elemento, element: "id"),
                              id_address_delivery: buscarJson(json: elemento, element: "id_address_delivery"),
                              id_address_invoice: buscarJson(json: elemento, element: "id_address_invoice"),
                              id_currency: buscarJson(json: elemento, element: "id_currency"),
                              id_customer: buscarJson(json: elemento, element: "id_customer"),
                              id_guest: buscarJson(json: elemento, element: "id_guest"),
                              id_lang: buscarJson(json: elemento, element: "id_lang"),
                              id_shop_group: buscarJson(json: elemento, element: "id_shop_group"),
                              id_shop: buscarJson(json: elemento, element: "id_shop"),
                              id_carrier: buscarJson(json: elemento, element: "id_carrier"),
                              recyclable: buscarJson(json: elemento, element: "recyclable"),
                              gift: buscarJson(json: elemento, element: "gift"),
                              gift_message: buscarJson(json: elemento, element: "gift_message"),
                              mobile_theme: buscarJson(json: elemento, element: "mobile_theme"),
                              delivery_option: buscarJson(json: elemento, element: "delivery_option"),
                              secure_key: buscarJson(json: elemento, element: "secure_key"),
                              allow_seperated_package: buscarJson(json: elemento, element: "allow_seperated_package"),
                              date_add: buscarJson(json: elemento, element: "date_add"),
                              date_upd: buscarJson(json: elemento, element: "date_upd"),
                              carritoDetalles: carritoDetalle)
        }
         return carrito
    }
    
    func validarQueCarritoNoSeaUnaOrden(res: Any) -> String {
        var id: String = "no"
        let json = JSON(res)
        let array = json["orders"]
        
        for (_, subJson):(String, JSON) in array {
            id = subJson["id"].stringValue
        }
        return id
    }
    
    // Envio
    
    func buscarEnvios(res: Any) -> [String]{
        var id: [String] = [String]()
        let json = JSON(res)
        let array = json["carriers"]
        
        for (_, subJson):(String, JSON) in array {
            id.append(subJson["id"].stringValue)
        }
        return id
    }
    
    func buscarEnvio(res: Any) -> Carrier {
        let json = JSON(res)
        let elemento = json["carrier"]
        
        return Carrier(delay: buscarJson(json: elemento, element: "delay"),
                       id: buscarJson(json: elemento, element: "id"),
                       deleted: buscarJson(json: elemento, element: "deleted"),
                       is_module: buscarJson(json: elemento, element: "is_module"),
                       id_tax_rules_group: buscarJson(json: elemento, element: "id_tax_rules_group"),
                       id_reference: buscarJson(json: elemento, element: "id_reference"),
                       name: buscarJson(json: elemento, element: "name"),
                       active: buscarJson(json: elemento, element: "active"),
                       is_free: buscarJson(json: elemento, element: "is_free"),
                       url: buscarJson(json: elemento, element: "url"),
                       shipping_handling: buscarJson(json: elemento, element: "shipping_handling"),
                       shipping_external: buscarJson(json: elemento, element: "shipping_external"),
                       range_behavior: buscarJson(json: elemento, element: "range_behavior"),
                       shipping_method: buscarJson(json: elemento, element: "shipping_method"),
                       max_width: buscarJson(json: elemento, element: "max_width"),
                       max_height: buscarJson(json: elemento, element: "max_height"),
                       max_depth: buscarJson(json: elemento, element: "max_depth"),
                       max_weight: buscarJson(json: elemento, element: "max_weight"),
                       grade: buscarJson(json: elemento, element: "grade"),
                       external_module_name: buscarJson(json: elemento, element: "external_module_name"),
                       need_range: buscarJson(json: elemento, element: "need_range"),
                       position: buscarJson(json: elemento, element: "position"),
                       deliveries: Deliveries()
        )
    }
    
    
    // Conf 
    func configurations(res: Any) -> String {
        var id: String = "";
        /*if (res == "[]") {
         return id;
         } else {*/
        let json = JSON(res)
        let elemento = json["configurations"]
        
        for (_, subJson):(String, JSON) in elemento {
            id = subJson["id"].stringValue
        }
        
        return id;
        //}
    }
    
    
    func configuration(res: Any) -> String {
        let json = JSON(res)
        let elemento = json["configuration"]
        
        return buscarJson(json: elemento, element: "value");
    }
    
    // Conversores
    
    func MD5(string: String) -> String? {
        let cadena = COOKIE_KEY + string
        return cadena.md5()
    }
        
}

