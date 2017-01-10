//
//  CarritoViewController.swift
//  market
//
//  Created by Kevin Garcia on 1/5/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Haneke

class CarritoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
   
    // al final obtener carrito con las cantidades?
    
    @IBOutlet weak var contenedorResumen: UIView!
    @IBOutlet weak var contenedorProductosScroll: UIScrollView!
    @IBOutlet weak var contenedorDirecciones: UIView!
    @IBOutlet weak var contenedorTransporteScroll: UIScrollView!
    @IBOutlet weak var contenedorPago: UIView!
    
    // Resumen
    @IBOutlet weak var metodoPago: UILabel!
    @IBOutlet weak var importe: UILabel!
    @IBOutlet weak var aceptamosMonedaDolar: UILabel!
    @IBOutlet weak var imformacion: UILabel!
    
    @IBAction func confirmarPedido(_ sender: UIButton) {
        confirmarPedido()
    }
    
    // Productos
    @IBOutlet weak var tableProductos: UITableView!
    @IBOutlet weak var totalProducto: UILabel!
    @IBOutlet weak var totalEnvio: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBAction func Siguiente1(_ sender: UIButton) {
        direcciones.removeAll()
        pickerDir1.reloadAllComponents()
        pickerDir2.reloadAllComponents()
        
        contenedorProductosScroll.isHidden = true
        contenedorDirecciones.isHidden = false
        self.navigationItem.title = "Dirección - Paso 2 / 4"
        direccionesNavBar.isEnabled = false
        direccionesNavBar.tintColor = UIColor.white
    }
    
    // direcciones
    @IBOutlet weak var pickerDir1: UIPickerView!
    @IBOutlet weak var checkDirecciones: checkBox!
    @IBOutlet weak var pickerDir2: UIPickerView!
    
    @IBOutlet weak var direccionesNavBar: UIBarButtonItem!
    var isCheckDirecciones = false
    
    @IBAction func Siguiente2(_ sender: UIButton) {
        listaEnvios.removeAll()
        tableTransporte.reloadData()
        seguirBuscandoEnvio(hijo: 0, envio: primerEnvio)

        contenedorDirecciones.isHidden = true
        contenedorTransporteScroll.isHidden = false
        self.navigationItem.title = "Transporte - Paso 3 / 4"
        direccionesNavBar.isEnabled = true
        direccionesNavBar.tintColor = nil
    }
    @IBAction func checkDirecciones(_ sender: checkBox) {
        isCheckDirecciones = !isCheckDirecciones
        if (isCheckDirecciones) {
            pickerDir2.isHidden = false
        } else {
            pickerDir2.isHidden = true
        }
    }
    
    // transportes
    @IBOutlet weak var tableTransporte: UITableView!
    @IBOutlet weak var checkTerminoServicio: checkBox!
    
    @IBAction func TerminosServicio(_ sender: UIButton) {
        buscarTerminosDeEnvio()
        
    }
    @IBAction func Siguiente3(_ sender: UIButton) {
        if (checkTerminoServicio.isChecked) {
            contenedorTransporteScroll.isHidden = true
            contenedorPago.isHidden = false
            self.navigationItem.title = "Pago - Paso 4 / 4"
        } else {
            mensaje(mensaje: "Debe aceptar los términos del servicio", cerrar: false)
        }
    }
    
    // Pago
    @IBAction func pagoTransferencia(_ sender: UIButton) {
        MODULE = "bankwire"
        PAYMENT = "Transferencia bancaria"
        mostrarResumen(tipoPago: "Pago por transferencia bancaria", tipo: 0)
    }
    @IBAction func pagoEfectivo(_ sender: UIButton) {
        MODULE = "cashondelivery"
        PAYMENT = "Cash on delivery (COD)"
        mostrarResumen(tipoPago: "Pagar contra reembolso", tipo: 1)
    }
    
    
    let facade: Facade = Facade()
    
    var envio_id: [String] = [String]()
    var primerEnvio: Carrier = Carrier()
    var USUARIO_ID: String = ""
    var MODULE: String = ""
    var PAYMENT: String = ""
    var CARRITO_ACTUAL: Carrito = Carrito()
    var productos: [Producto] = [Producto]()
    var ids: [String] = [String]()
    var direcciones: [Direccion] = [Direccion]()
    var DIR_ACT: Int = 0
    var DIR_FAC: Int = 0
    var preciosNetos: [Double] = [Double]()
    var precioTransporte: Double = 0.0
    var preciosCarriers: [Double] = [Double]()
    var listaEnvios: [Carrier] = [Carrier]()
    
    // Delivery
    var EnvioActivo: Int = 0
    // private int shipping_handling = 2;      // Buscar este valor e.e
    
    var columna: Int = 4
    var imageWigth: Int = 0
    var alias: [String] = [String]()
    
    // Pases
    var carritoId: String = ""
    var importePass: String = ""
    var propietarioPass: String = ""
    var datosPass: String = ""
    var bancoPass: String = ""
    var referenciaPass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Carrito - Paso 1 / 4"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tableProductos.delegate = self
        tableProductos.dataSource = self
        tableProductos.separatorStyle = .none
        tableProductos.backgroundColor = UIColor.clear
        
        tableTransporte.delegate = self
        tableTransporte.dataSource = self
        tableTransporte.separatorStyle = .none
        tableTransporte.backgroundColor = UIColor.clear
        
        contenedorResumen.isHidden = true
        contenedorProductosScroll.isHidden = false
        contenedorDirecciones.isHidden = true
        contenedorTransporteScroll.isHidden = true
        contenedorPago.isHidden = true
        
        pickerDir1.dataSource = self
        pickerDir1.delegate = self
        
        pickerDir2.dataSource = self
        pickerDir2.delegate = self
        
        pickerDir1.tag = 1
        pickerDir2.tag = 2
        
        USUARIO_ID = UserDefaults.standard.string(forKey: "email")!
        
        pickerDir1.isHidden = true
        pickerDir2.isHidden = true
        
        direccionesNavBar.isEnabled = true
        direccionesNavBar.tintColor = nil
        checkTerminoServicio.isChecked = false
        
        if (carritoId == "no") {
            contenedorProductosScroll.isHidden = true
            mensaje(mensaje: "Su carrito está vacío.", cerrar: true)
        } else {
            buscarCarrito(existencia: carritoId)
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return direcciones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return direcciones[row].alias
    }
    
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        if pickerView == pickerDir1 {
            DIR_ACT = row
        } else if pickerView == pickerDir2 {
            DIR_FAC = row
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if tableView == tableProductos {
            count = productos.count
        } else if tableView == tableTransporte {
            count = listaEnvios.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var celi: UITableViewCell?
        if tableView == tableProductos {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarritoProductoTableViewCell") as! CarritoProductoTableViewCell
            
            let producto = productos[indexPath.row]
            let precioNeto = preciosNetos[indexPath.row]
            cell.descripcion.text = producto.name
            cell.precioUnitario.text = "$ \(String(format: "%.2f", precioNeto))"
            cell.precioTotal.text = "$ \(String(format: "%.2f", precioNeto * Double(CARRITO_ACTUAL.carritoDetalles[indexPath.row].quantity)!))"
            cell.controller = self
            cell.position = indexPath.row
            cell.carrito = CARRITO_ACTUAL
            buscarImagen(id: "\(producto.id)/\(producto.imagenes[0])", tipo: "products", imagenSize: "small_default", imagen: cell.imagen)
            
            buscarStock(stock: producto.stock_availables[0], cant: Int(CARRITO_ACTUAL.carritoDetalles[indexPath.row].quantity)!, stepper: cell.stepper, valor: cell.valor)

            celi = cell
        } else if tableView == tableTransporte {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarritoTransporteTableViewCell") as! CarritoTransporteTableViewCell
            
            let envio = listaEnvios[indexPath.row]
            let precio: Double = calcularPrecioEnvio(envio: envio)
            cell.tiempo.text = ("$ \(String(format: "%.2f", precio)) (impuestos inc.)")
            cell.descripcion.text = envio.name
            cell.duracion.text = "Tiempo de entrega: \(envio.delay)"
            cell.row = indexPath.row
            cell.controller = self
            
            if (indexPath.row == EnvioActivo) {
                cell.check.isChecked = true
            } else {
                cell.check.isChecked = false
            }
            celi = cell
        }
        return celi!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableProductos {
            
        } else if tableView == tableTransporte {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarritoTransporteTableViewCell") as! CarritoTransporteTableViewCell
            
            if (!cell.check.isChecked) {
                cell.check.isChecked = true
                check(envio: listaEnvios[indexPath.row] ,hijo: indexPath.row)
            }
        }
    }
    
    func buscarCarrito(existencia: String) {
        Alamofire.request("\(facade.WEB_PAGE)/carts/\(existencia)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let carrito: Carrito = self.facade.buscarCarrito(res: JSON)
                    self.validarQueCarritoNoSeaUnaOrden(carrito: carrito)
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //print(error)        // Poner en comentario
            }
        }
    }
    
    
    func  validarQueCarritoNoSeaUnaOrden(carrito: Carrito) {
        Alamofire.request("\(facade.WEB_PAGE)/orders?filter[id_cart]=\(carrito.id)&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let validar: String = self.facade.validarQueCarritoNoSeaUnaOrden(res: JSON)
                    if (validar == "no") { // El carrito actual no es una orden
                        self.examinarCarrito(carrito: carrito)
                    } else {
                         self.mensaje(mensaje: "Su carrito está vacío.", cerrar: true)
                    }
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //print(error)        // Poner en comentario
            }
        }
    }
    
    
    func examinarCarrito(carrito: Carrito) {
        if (carrito.carritoDetalles.isEmpty) {
            mensaje(mensaje: "Su carrito está vacío.", cerrar: true)
            return
        }
        
        CARRITO_ACTUAL = carrito
        //contenedorTotalPrecios.setVisibility(View.VISIBLE);
        var prod: [String] = [String]()
        for index in 0..<carrito.carritoDetalles.count {
            let detalle: CarritoDetalle = carrito.carritoDetalles[index]
            prod.append(detalle.id_product)
        }
 
        buscarProductos(hijo: 0, prod: prod, carrito: carrito)
    }
    
    
    func buscarProductos(hijo: Int, prod: [String], carrito: Carrito) {
        Alamofire.request("\(facade.WEB_PAGE)/products/\(prod[hijo])?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let producto: Producto = self.facade.buscarProducto(res: JSON)
                    self.insertProducto(producto: producto, precio: Double(self.productos[hijo].price)!)
                    //buscarSiTieneDescuento(hijo, imagenes, carrito)
                    self.seguirBuscandoProducto(hijo: hijo, carrito: carrito, producto: prod)
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
        
    }
    
    func buscarImagen(id: String, tipo: String, imagenSize: String, imagen: UIImageView) {
        
        let url = URL(string: "\(self.facade.WEB_PAGE)/images/\(tipo)/\(id)/\(imagenSize)?\(facade.parametrosBasicos())")
        imagen.hnk_setImage(from: url!)
    }
    
    func insertProducto(producto: Producto, precio: Double) {
        preciosNetos.append(precio)
        productos.append(producto)
        tableProductos.reloadData()
    }
    
    func seguirBuscandoProducto(hijo: Int, carrito: Carrito, producto: [String]) {
        
        let hij: Int = hijo + 1
        if (hij < productos.count) {     // ¿Hay mas productos?
            self.buscarProductos(hijo: hij, prod: producto, carrito: carrito);
        } else {
            self.buscarEnvios(hijo: 0, imprimir: false);
        }
    }
    
    func calcularTotales() {
        let subtot = subtotal()
        totalProducto.text = "$ \(subtotal())"

        let tot: Double = subtot + precioTransporte
        total.text = "$ \(tot)"
    }
    
    func buscarStock(stock: String, cant: Int, stepper: UIStepper, valor: UILabel) {
        Alamofire.request("\(facade.WEB_PAGE)/stock_availables/\(stock)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let cantidad: String = self.facade.buscarStock(res: JSON);
                    if (cantidad != "Este producto ya no está disponible") {
                        stepper.maximumValue = Double(cantidad)!
                    } else {
                        stepper.isEnabled = false
                    }
                    stepper.value = Double(cant)
                    valor.text = String(cant)
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
    }
    
    //Linea 566
    
    func subtotal() -> Double {
        var acum: Double = 0.0;
        for index in 0..<productos.count {
            let precioNeto = preciosNetos[index]
            
            acum = precioNeto * Double(CARRITO_ACTUAL.carritoDetalles[index].quantity)!
        }
        return acum;
    }
    
    func buscarDirecciones() {
        Alamofire.request("\(facade.WEB_PAGE)/addresses?filter[id_customer]=\(USUARIO_ID)&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.ids = self.facade.existenDirecciones(res: JSON)
                    self.buscarDireccion(hijo: 0)
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarDireccion(hijo: Int) {
        Alamofire.request("\(facade.WEB_PAGE)/addresses/\(ids[hijo])?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let direccion: Direccion = self.facade.buscarDireccion(res: JSON)
                    self.direcciones.append(direccion)
                    self.seguirBuscando(lista: self.ids, hijo: hijo)
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
    }
    
    func seguirBuscando(lista: [String], hijo: Int) {
        let hij: Int = hijo + 1
        if (hij < lista.count) {     // ¿Hay mas direcciones?
            self.buscarDireccion(hijo: hij);
        } else {
            print("cargar spiners")
            self.pickerDir1.reloadAllComponents()
            self.pickerDir2.reloadAllComponents()
        }
    }
    
    func buscarEnvios(hijo: Int, imprimir: Bool) {
        
        Alamofire.request("\(facade.WEB_PAGE)/carriers?filter[deleted]=0&filter[active]=1&filter[is_free]=0&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.envio_id = self.facade.buscarEnvios(res: JSON)
                    
                    if (self.envio_id.count > 1) {
                        self.buscarEnvio(hijo: hijo, imprimir: imprimir)
                    } else {
                        self.mensaje(mensaje: "No hay transportes disponibles", cerrar: false);
                    }
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarEnvio(hijo: Int, imprimir: Bool) {
        Alamofire.request("\(facade.WEB_PAGE)/carriers/\(self.envio_id[hijo])?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.buscarPrecioId(envio: self.facade.buscarEnvio(res: JSON), hijo: hijo, imprimir: imprimir);
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarPrecioId(envio: Carrier, hijo: Int, imprimir: Bool) {
        Alamofire.request("\(facade.WEB_PAGE)/deliveries?filter[id_carrier]=\(envio.id)&filter[id_zone]=6?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    var id_delivery: [String] = self.facade.buscarDeliveries(res: JSON)
                    self.buscarPrecio(s: id_delivery[0], hijo: hijo, envio: envio, imprimir: imprimir)
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //print(error)        // Poner en comentario
            }
        }
    }
    
    
    
    
    func buscarPrecio(s: String, hijo: Int, envio: Carrier, imprimir: Bool) {
        Alamofire.request("\(facade.WEB_PAGE)/deliveries/\(s)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let deliveries: Deliveries = self.facade.buscarDelivery(res: JSON);
                    envio.deliveries = deliveries;
                    
                    if (imprimir) {
                        self.seguirBuscandoEnvio(hijo: hijo, envio: envio);
                    } else {
                        self.primerEnvio = envio
                        let precio: Double = self.calcularPrecioEnvio(envio: envio)
                        self.preciosCarriers.append(precio)
                        self.calcularTotales()
                        //conversor.ActionProcessButtonValidation(btnSiguienteCarrito, true);
                    }
                    
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func seguirBuscandoEnvio(hijo: Int, envio: Carrier) {
        let hi = hijo + 1
        
        if (hi < envio_id.count) {     // ¿Hay mas envios?
            buscarEnvio(hijo: hi, imprimir: true);
        } else {
            //self.facade.ActionProcessButtonValidation(btnSiguienteCarrito3, true);
        }
    }
    
    func insertEnvio(envio: Carrier) {
        listaEnvios.append(envio)
        tableTransporte.reloadData()
    }
    
    func check(envio: Carrier, hijo: Int) {
        EnvioActivo = hijo
        tableTransporte.reloadData()
    
        totalEnvio.text = "$ \(String(format: "%.2f", calcularPrecioEnvio(envio: envio)))"
        calcularTotales()
    }
    
    func calcularPrecioEnvio(envio: Carrier) -> Double {
        var precio: Double = Double(envio.deliveries.price.replacingOccurrences(of: ",", with: "."))!
        
        //   if (envio.getShipping_handling().equals("1")) {
        //      precio += shipping_handling;
        //  }
        
        if (envio.id_tax_rules_group == "1") {
            precio = precio + (precio * 0.12);
        }
        return precio
    }
    
    
    
    
    func buscarTerminosDeEnvio() {
        Alamofire.request("\(facade.WEB_PAGE)/content_management_system/3?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.mostrarTerminosDelServicio(mensaje: self.facade.buscarTerminos(res: JSON))
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
        
    }
    
    func mostrarTerminosDelServicio(mensaje: String) {
        let refreshAlert = UIAlertController(title: "TÉRMINOS Y CONDICIONES", message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Acepto Terminos y Condicones", style: .default, handler: { (action: UIAlertAction!) in
            if (!self.checkTerminoServicio.isChecked) {
                self.checkTerminoServicio.isChecked = true
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
    

    
    
    func mostrarResumen(tipoPago: String, tipo: Int) {
        contenedorPago.isHidden = true
        contenedorResumen.isHidden = false
        self.navigationItem.title = "Resumen del pedido"
        
        metodoPago.text = "Ha elegido \(tipoPago.lowercased()). Aquí tiene un resumen de su pedido:"
        importe.text = "* El importe total de su pedido es $ \( String(format: "%.2f", Double((total.text?.replacingOccurrences(of: "$", with: ""))!)!)) (impuestos inc.)"
        aceptamosMonedaDolar.text = "* Aceptamos las siguientes monedas para las transferencias bancarias: Dolar."
        
        if (tipo == 0) {
            imformacion.text = "* La información para realizar la transferencia bancaria aparecerá en la página siguiente."
        } else {
            imformacion.isHidden = true
        }
    }
    
    func confirmarPedido() {
        /*
         final int DEFAULT_TIMEOUT = 20 * 1000;
         client.setTimeout(DEFAULT_TIMEOUT);*/
        
        let id_address_delivery = DIR_ACT
        let id_address_invoice = (checkDirecciones.isChecked) ? DIR_ACT : DIR_FAC
        let id_cart = CARRITO_ACTUAL.id
        let id_currency = 1
        let id_lang = 1
        let id_carrier = envio_id
        let module = MODULE
        let payment = PAYMENT
        let total_paid = "\(total.text?.replacingOccurrences(of: "$", with: ""))"
        let total_paid_real = 0
        let total_products = String(self.subtotal())
        let total_products_wt = "\(totalProducto.text?.replacingOccurrences(of: "$", with: ""))"
        let conversion_rate = 1
        
        let params: [String: Any] = ["id_address_delivery": id_address_delivery, "id_address_invoice": id_address_invoice, "id_cart": id_cart, "id_currency": id_currency, 	"id_currency": id_currency, "id_lang": id_lang, "id_carrier": id_carrier, "module": module, "payment": payment, "total_paid": total_paid, "total_paid_real": total_paid_real, "total_products": total_products, "total_products_wt": total_products_wt, "conversion_rate": conversion_rate]
        
        Alamofire.request("\(facade.WEB_API_AUX)CCartOrder.php?", method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON {
            response in
            switch response.result {
            case .success:
                self.buscarOrderRealizada();
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)
            }
            
        }
        
    }
    
    
    
    func buscarOrderRealizada() {
        Alamofire.request("\(facade.WEB_PAGE)/orders?filter[id_customer]=\(USUARIO_ID)&sort=[id_DESC]&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.buscarOrden(id: self.facade.existeOrdenes(res: JSON)[0])
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarOrden(id: String) {
        Alamofire.request("\(facade.WEB_PAGE)/orders/\(id)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let order: Order = self.facade.buscarOrden(res: JSON)
                    if (self.PAYMENT == "Cash on delivery (COD)") {
                        self.irPago(importe: "", propietario: "", datos: "", banco: "", referencia: order.reference)
                    } else {
                        self.buscarConfBankAddress(order: order)
                    }
                }
                
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
    }
    
    func buscarConfBankAddress(order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/configurations?filter[name]=BANK_WIRE_ADDRESS?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    // Log.d("Value", res);
                    self.buscarValorConfBankAddress(id: self.facade.configurations(res: JSON), order: order)
                }
                
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
    }
    
    func buscarValorConfBankAddress(id: String, order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/configurations/\(id)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //Log.d("Value", res);
                    self.buscarConfProp(banco: self.facade.configuration(res: JSON), order: order)
                }
                
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
        //        Log.d("URL", conversor.WEB_PAGE + "/configurations/" + id);
    }
    
    func buscarConfProp(banco: String, order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/configurations?filter[name]=BANK_WIRE_OWNER?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //    Log.d("Value", res);
                    self.buscarValorConfProp(id: self.facade.configurations(res: JSON), banco: banco, order: order)
                }
                
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
        //        Log.d("URL", conversor.WEB_PAGE + "/configurations?filter[name]=BANK_WIRE_OWNER");
    }
    
    func buscarValorConfProp(id: String, banco: String, order: Order) {
        
        Alamofire.request("\(facade.WEB_PAGE)/configurations/\(id)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    // Log.d("Value", res);
                    self.buscarConfDatos(propietario: self.facade.configuration(res: JSON), banco: banco, order: order)
                }
                
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
    }
    
    func buscarConfDatos(propietario: String, banco: String, order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/configurations?filter[name]=BANK_WIRE_DETAILS?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //Log.d("Value", res);
                    self.buscarValorConfDatos(id: self.facade.configurations(res: JSON), propietario: propietario, banco: banco, order: order)
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
        
        //Log.d("URL", conversor.WEB_PAGE + "/configurations?filter[name]=BANK_WIRE_DETAILS");
        
    }
    
    func buscarValorConfDatos(id: String, propietario: String, banco: String, order: Order) {
        Alamofire.request("\(facade.WEB_PAGE)/configurations/\(id)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    // Log.d("Value", res);
                    self.irPago(importe: self.total.text!, propietario: propietario, datos: self.facade.configuration(res: JSON), banco: banco, referencia: order.reference)
                }
                
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
        
    }
    
    func irPago(importe: String, propietario: String, datos: String, banco: String, referencia: String) {
        importePass = importe
        propietarioPass = propietario
        datosPass = datos
        bancoPass = banco
        referenciaPass = referencia
        
        self.performSegue(withIdentifier: "PagoViewController", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PagoViewController" {
            
            let nav = segue.destination as! UINavigationController
            let addEventViewController = nav.topViewController as! PagoViewController
            
            addEventViewController.payment = PAYMENT
            addEventViewController.importePass = self.importePass
            addEventViewController.propietarioPass = self.propietarioPass
            addEventViewController.datosPass = self.datosPass
            addEventViewController.bancoPass = self.bancoPass
            addEventViewController.referenciaPass = self.referenciaPass
        }
    }
    
    @IBAction func btnAtras(_ sender: UIBarButtonItem) {
        if (!contenedorResumen.isHidden) {
            contenedorResumen.isHidden = true
            contenedorPago.isHidden = false
            
            self.navigationItem.title = "Pago - Paso 4 / 4"
        } else if (!contenedorPago.isHidden) {
            contenedorPago.isHidden = true
            contenedorTransporteScroll.isHidden = false
            
            self.navigationItem.title = "Transporte - Paso 3 / 4"
        } else if (!contenedorTransporteScroll.isHidden) {
            contenedorTransporteScroll.isHidden = true
            contenedorDirecciones.isHidden = false
            
            self.navigationItem.title = "Dirección - Paso 2 / 4"
            direccionesNavBar.isEnabled = false
            direccionesNavBar.tintColor = UIColor.white
        } else if (!contenedorDirecciones.isHidden) {
            contenedorDirecciones.isHidden = true
            contenedorProductosScroll.isHidden = false
            
            self.navigationItem.title = "Carrito - Paso 1 / 4"
            direccionesNavBar.isEnabled = true
            direccionesNavBar.tintColor = nil
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func btnDirecciones(_ sender: UIBarButtonItem) {
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
