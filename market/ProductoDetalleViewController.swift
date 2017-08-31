//
//  ProductoDetalleViewController.swift
//  market
//
//  Created by Jose Duin on 12/21/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class ProductoDetalleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // identifer: FeatureViewCell, en la vista ProductoDetalle
    
    @IBOutlet weak var ImagenMuestra: UIImageView!
    @IBOutlet weak var galeria: UICollectionView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var condicion: UILabel!
    @IBOutlet weak var referencia: UILabel!
    @IBOutlet weak var existenca: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var descripcioon: UITextView!
    @IBOutlet weak var descripcion: UIWebView!
    @IBOutlet weak var contenedorFeatures: UICollectionView!
    @IBOutlet weak var agregarCarrito: UIButton!
    @IBOutlet weak var valorStepper: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    let facade: Facade = Facade()
    
    var feature_lista: [ProductFeatures] = [ProductFeatures]()
    var productoPass: Producto = Producto()
    var ID_USUARIO: String = ""
    var STOCK: Int = 0
    var PRECIO_NETO: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = productoPass.name
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        galeria.delegate = self
        galeria.dataSource = self
        
        contenedorFeatures.delegate = self
        contenedorFeatures.dataSource = self
        contenedorFeatures.isHidden = true
        
        condicion.text = productoPass.condition
        nombre.text = productoPass.name
        referencia.text = productoPass.reference
        
        descripcioon.attributedText = try! NSAttributedString(
            data: productoPass.description_short.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        					
        buscarImagen(id: "\(productoPass.id)/\(productoPass.imagenes[0])", tipo: "products", imagenSize: "large_default", imagen: ImagenMuestra)
        
        //if (producto.getDescuentos() == null) {
        self.precio.text = "$\(productoPass.price) impuesto inc."
        PRECIO_NETO = Double(productoPass.price)!
        //} else {
        //    buscarHoraEcuador(producto);
        //}
        
        // Buscamos la cantidad que hay en el stock
        buscarStock(stock: productoPass.stock_availables[0]);
        
        if (productoPass.features.count > 0) {
            buscarFeatures(features: productoPass.features, hijo: 0);
        } else {
            self.contenedorFeatures.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let isLogin: Bool = UserDefaults.standard.bool(forKey: "isLogin")
        if (isLogin) {
            ID_USUARIO = UserDefaults.standard.string(forKey: "id")!
        } else {
            ID_USUARIO = ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count:Int?
        
        if collectionView == self.contenedorFeatures {
            if (feature_lista.count > 0 ) {
                contenedorFeatures.isHidden = false
                count = feature_lista.count
            } else {
                contenedorFeatures.isHidden = true
                count = 0
            }
        }
        
        if collectionView == self.galeria {
            count =  productoPass.imagenes.count
        }
        
        return count!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var celi: UICollectionViewCell?
        
        if collectionView == self.contenedorFeatures {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureViewCell", for: indexPath) as! FeatureViewCell
            
            let feature = feature_lista[indexPath.row]
            cell.nombre.text = feature.id_feature_value
            // tamaño de letra nombre 18
            cell.descripcion.text = feature.id
            celi = cell
        }
        
        if collectionView == self.galeria {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GaleriaViewCell", for: indexPath) as! GaleriaViewCell

            self.buscarImagen(id: "\(productoPass.id)/\(productoPass.imagenes[indexPath.row])", tipo: "products", imagenSize: "medium_default", imagen: cell.imagen)
            celi = cell
        }
        
        return celi!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.galeria {
            buscarImagen(id: "\(productoPass.id)/\(productoPass.imagenes[indexPath.row])", tipo: "products", imagenSize: "large_default", imagen: self.ImagenMuestra)
        }
    }
    
    
    func buscarImagen(id: String, tipo: String, imagenSize: String, imagen: UIImageView) {
        print("ID: \(id)")
        let url = URL(string: "\(self.facade.WEB_PAGE)/images/\(tipo)/\(id)/\(imagenSize)?\(facade.parametrosKey())")

        imagen.hnk_setImage(from: url!)
    }
    
    func buscarFeatures(features: [ProductFeatures], hijo: Int) {
        Alamofire.request("\(self.facade.WEB_PAGE)/product_feature_values/\(features[hijo].id_feature_value)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let feature: ProductFeatures = ProductFeatures()
                    feature.id = self.facade.buscarFeatures(res: JSON)
                    self.buscarFeaturesMedidas(features: features, hijo: hijo, feature: feature);
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print("ERROR \(error)")        // Poner en comentario
            }
        }
    }
    
    func buscarFeaturesMedidas(features: [ProductFeatures], hijo: Int, feature: ProductFeatures) {
        Alamofire.request("\(self.facade.WEB_PAGE)/product_features/\(features[hijo].id)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    feature.id_feature_value = self.facade.buscarFeaturesMedidas(res: JSON)
                    self.seguirBuscandoFeature(features: features, hijo: hijo, feature: feature)
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func seguirBuscandoFeature(features: [ProductFeatures], hijo: Int, feature: ProductFeatures) {
        insertFeature(feature: feature)
        
        let hijoAux = hijo + 1
        if (hijoAux < features.count) {
            buscarFeatures(features: features, hijo: hijoAux);
        }
    }
    
    func insertFeature(feature: ProductFeatures) {
        feature_lista.append(feature)
        contenedorFeatures.reloadData()
    }
    
    
    func buscarStock(stock: String) {
        Alamofire.request("\(self.facade.WEB_PAGE)/stock_availables/\(stock)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    var cantidad: String = self.facade.buscarStock(res: JSON)

                    let cantidadBool: Bool = cantidad == "No está disponible"
                    if (!cantidadBool) {
                        self.STOCK = Int(cantidad)!
                        self.stepper.maximumValue = Double(self.STOCK)
                        cantidad = (cantidad == "1") ? "1 artículo" : "\(cantidad) artículos";
                    } else {
                        self.agregarCarrito.isHidden = true
                        self.stepper.minimumValue = 1.0
                        self.stepper.isEnabled = false
                    }
                    self.existenca.text = cantidad
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    // Carrito
    func buscarUltimoCarrito() {
        print("\(self.facade.WEB_PAGE)/carts?filter[id_customer]=\(ID_USUARIO)&\(facade.parametrosBasicos())")
        Alamofire.request("\(self.facade.WEB_PAGE)/carts?filter[id_customer]=\(ID_USUARIO)&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let existe: String = self.facade.existeCarrito(res: JSON);
                    if (existe == "no") {
                        self.buscarEnvios()     // Usuario nuevo
                    } else {
                        self.validarQueCarritoNoSeaUnaOrden(id: existe)
                    }
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func validarQueCarritoNoSeaUnaOrden(id: String) {
        print("\(self.facade.WEB_PAGE)/orders?filter[id_cart]=\(id)&\(facade.parametrosBasicos())")
        Alamofire.request("\(self.facade.WEB_PAGE)/orders?filter[id_cart]=\(id)&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let validar: String = self.facade.validarQueCarritoNoSeaUnaOrden(res: JSON)
                    if (validar == "no") { // El carrito actual no es una orden
                        self.buscarCarrito(id: id)
                    } else {
                        self.buscarEnvios()
                    }
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarEnvios() {
        print("\(self.facade.WEB_PAGE)/carriers?filter[deleted]=0&filter[active]=1&filter[is_free]=0&\(facade.parametrosBasicos())")
        Alamofire.request("\(self.facade.WEB_PAGE)/carriers?filter[deleted]=0&filter[active]=1&filter[is_free]=0&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let envio_id: [String] = self.facade.buscarEnvios(res: JSON)
                    self.crearCarrito(idEnvio: envio_id[0])
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func crearCarrito(idEnvio: String) {
        
        let cantidad: Int = Int(self.stepper.value)
        let idProducto: String = productoPass.id
        let params: Parameters = Parameters()
        
        print("\(self.facade.WEB_API_AUX)CCart.php?Create&delivery=\(idEnvio)&customer=\(ID_USUARIO)&product=\(idProducto)&quantity=\(cantidad)")
        Alamofire.request("\(self.facade.WEB_API_AUX)CCart.php?Create&delivery=\(idEnvio)&customer=\(ID_USUARIO)&product=\(idProducto)&quantity=\(cantidad)", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success: break
                
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarCarrito(id: String) {
        print("\(self.facade.WEB_PAGE)/carts/\(id)?\(facade.parametrosBasicos())")
        Alamofire.request("\(self.facade.WEB_PAGE)/carts/\(id)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let carrito: Carrito = self.facade.buscarCarrito(res: JSON)
                    print("Carrito: \(carrito.id)")
                    let idProduct: String = self.productoPass.id
                    var cantidadViaja: Int = 0
                    var i: Int = 0
                    var encontro: Bool = false
                    
                    if (carrito.carritoDetalles.count != 0) {
                        for index in 0..<carrito.carritoDetalles.count {
                            let producto: CarritoDetalle = carrito.carritoDetalles[index]
                            print("Carrito detalle: \(producto.id_product)")
                            if (idProduct == producto.id_product) {
                                cantidadViaja = Int(producto.quantity)!
                                i = index
                                encontro = true
                                break
                            }
                        }
                    }
                    let cantidad: Int = Int(self.stepper.value)
                    print("cantidad: \(cantidad) y encontro \(encontro)")
                    if (encontro) {
                        self.actualizarCantidadProducto(id: id, row: i, cantidad: cantidad, cantidadViaja: cantidadViaja);
                    } else {
                        self.incluirProductoAlCarrito(idCarrito: id, idProducto: idProduct, cantidad: cantidad);
                    }
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func actualizarCantidadProducto(id: String, row: Int, cantidad: Int, cantidadViaja: Int) {
        let cantidadTotal: Int = cantidadViaja + cantidad
        if (cantidadTotal > STOCK) {
            mensaje(mensaje: "No hay esa cantidad de productos en existencia", cerrar: false)
            return
        }
        
        let params: Parameters = Parameters()
        print("\(self.facade.WEB_API_AUX)UCartItemQuantity.php?id=\(id)&row=\(row)&qua=\(cantidadTotal)")
        Alamofire.request("\(self.facade.WEB_API_AUX)UCartItemQuantity.php?id=\(id)&row=\(row)&qua=\(cantidadTotal)", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success: break
                
            //case .failure(let error):
            //    self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
            //    print(error)        // Poner en comentario
            default:
                self.stepper.maximumValue = Double(self.STOCK - cantidadTotal)
            }
        }
    }
    
    func incluirProductoAlCarrito(idCarrito: String, idProducto: String, cantidad: Int) {
        let params: Parameters = Parameters()
        print("\(self.facade.WEB_API_AUX)AddItemToCart.php?idCart=\(idCarrito)&addItem=true&idPro=\(idProducto)&proQua=\(cantidad)")
        Alamofire.request("\(self.facade.WEB_API_AUX)AddItemToCart.php?idCart=\(idCarrito)&addItem=true&idPro=\(idProducto)&proQua=\(cantidad)", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success: break
                
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    @IBAction func picker(_ sender: UIStepper) {
        valorStepper.text = Int(sender.value).description
    }
    
    @IBAction func agregarProductoCarrito(_ sender: UIButton) {
        if (ID_USUARIO.isEmpty) {
            mensaje(mensaje: "Para continuar, por favor iniciar sesión", cerrar: false)
            performSegue(withIdentifier: "ProductoDetalleToLogin", sender: nil)
        } else {
            buscarUltimoCarrito()
            performSegue(withIdentifier:"ProductoDetalleModalController", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductoDetalleModalController" {
            
            let addEventViewController:ProductoDetalleModalController = segue.destination as! ProductoDetalleModalController
            
            addEventViewController.nombre_desc = self.productoPass.name

            addEventViewController.cantidad_desc = "cantidad: \(Int(valorStepper.text!)!)"
            addEventViewController.total_desc = "total: $\(PRECIO_NETO * Double(valorStepper.text!)!)"
            addEventViewController.imagen_desc = "\(self.productoPass.id)/\(self.productoPass.imagenes[0])"
            addEventViewController.ID_USUARIO = self.ID_USUARIO
        }
    }

    @IBAction func btnAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mensaje(mensaje: String, cerrar: Bool) {
        let mostrarMensaje = UIAlertController(title: "Mensaje", message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        if (cerrar) {
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                action in
                self.dismiss(animated: true, completion: nil)
            }
            mostrarMensaje.addAction(okAction)
        } else {
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            mostrarMensaje.addAction(okAction)
        }
        
        self.present(mostrarMensaje, animated: true, completion: nil)
    }

}
