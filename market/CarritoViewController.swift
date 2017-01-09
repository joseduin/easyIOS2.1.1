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
    }
    
    // Productos
    @IBOutlet weak var tableProductos: UITableView!
    @IBOutlet weak var totalProducto: UILabel!
    @IBOutlet weak var totalEnvio: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBAction func Siguiente1(_ sender: UIButton) {
    }
    
    // direcciones
    @IBOutlet weak var pickerDir1: UIPickerView!
    @IBOutlet weak var checkDirecciones: checkBox!
    @IBOutlet weak var pickerDir2: UIPickerView!
    
    @IBOutlet weak var direccionesNavBar: UIBarButtonItem!
    var isCheckDirecciones = false
    
    @IBAction func Siguiente2(_ sender: UIButton) {
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
    var isChekectTerminos = false
    
    @IBAction func TerminosServicio(_ sender: UIButton) {
        
    }
    @IBAction func Siguiente3(_ sender: UIButton) {
    }
    
    // Pago
    @IBAction func pagoTransferencia(_ sender: UIButton) {
    }
    @IBAction func pagoEfectivo(_ sender: UIButton) {
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
    
    // Delivery
    var EnvioActivo: Int = 0
    // private int shipping_handling = 2;      // Buscar este valor e.e
    
    var columna: Int = 4
    var imageWigth: Int = 0
    var alias: [String] = [String]()
    
    // Pases
    var carritoId: String = ""
    
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
        contenedorProductosScroll.isHidden = true
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
        
        if (carritoId == "no") {
            contenedorProductosScroll.isHidden = true
            mensaje(mensaje: "Su carrito está vacío.", cerrar: true)
        } else {
            buscarCarrito(existencia: carritoId)
        }

    }
    
    func numberOfComponentsInPickerView(pickerView : UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if pickerView == pickerDir1 {
            //return test[row]
        } else if pickerView == pickerDir2 {
            //return test2[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {

        if pickerView == pickerDir1 {
            DIR_ACT = row
        } else if pickerView == pickerDir2 {
            DIR_FAC = row
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int
        if tableView == tableProductos {
            count = productos.count
        } else if tableView == tableTransporte {
            
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if tableView == tableProductos {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarritoProductoTableViewCell") as! CarritoProductoTableViewCell
            
            let producto = productos[indexPath.row]
            let precioNeto = preciosNetos[indexPath.row]
            cell.descripcion.text = producto.name
            cell.precioUnitario.text = "$ \(String(format: "%.2f", precioNeto))"
            cell.precioTotal.text = "$ \(String(format: "%.2f", precioNeto * Double(CARRITO_ACTUAL.carritoDetalles[indexPath.row].quantity)!))"
            
            buscarImagen(id: "\(producto.id)/\(producto.imagenes[0])", tipo: "products", imagenSize: "small_default", imagen: cell.imagen)
            
            buscarStock(producto.stock_availables[0], Int(CARRITO_ACTUAL.carritoDetalles[indexPath.row].quantity)!), cell.stepper, cell.valor.text)

        } else if tableView == tableTransporte {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableProductos {
            
        } else if tableView == tableTransporte {
            
        }
    }
    
    //Linea 200
    
    func buscarCarrito(existencia: String) {
        Alamofire.request("\(facade.WEB_PAGE)/carts/\(existencia)?\(facade.parametrosKey())").validate().responseJSON { response in
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
        Alamofire.request("\(facade.WEB_PAGE)/orders?filter[id_cart]=\(carrito.id)&\(facade.parametrosKey())").validate().responseJSON { response in
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
        Alamofire.request("\(facade.WEB_PAGE)/products/\(prod[hijo])?\(facade.parametrosKey())").validate().responseJSON { response in
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
        
        let url = URL(string: "\(self.facade.WEB_PAGE)/images/\(tipo)/\(id)/\(imagenSize)?\(facade.parametrosKey())")
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
    
    func imprimirProductos(carrito: Carrito, position: Int, precioNeto: Double) {
        /*
    
         numberPickerCarrito.setOnValueChangedListener(new NumberPicker.OnValueChangeListener() {
         @Override
         public void onValueChange(NumberPicker picker, int oldVal, int newVal) {
         actualizarCantidadDeProductosEnCarrito(newVal, position, carrito, precioTotalCarrito, productos.get(position).getPrice());
         }
         });
         ButtonMenosCantidadCarrito.setOnClickListener(new View.OnClickListener() {
         @Override
         public void onClick(View v) {
         pickerCantidad(false, position, numberPickerCarrito, carrito, precioTotalCarrito, productos.get(position).getPrice());
         }
         });
         buttonMasCantidadCarrito.setOnClickListener(new View.OnClickListener() {
         @Override
         public void onClick(View v) {
         pickerCantidad(true, position, numberPickerCarrito, carrito, precioTotalCarrito, productos.get(position).getPrice());
         }
         });
         btnEliminarProductocarrito.setOnClickListener(new View.OnClickListener() {
         @Override
         public void onClick(View v) {
         confirmarEliminarProductoCarrito(productos.get(position).getName());
         }
         });
         
         recycleCarrito.addView(newView);
         */
    }
    
    
    
    
    //***************************PICKERS**************************
    
    func buscarStock(stock: String, cant: Int/* final NumberPicker numberPickerCarrito*/) {
        Alamofire.request("\(facade.WEB_PAGE)/stock_availables/\(stock)?").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    var cantidad: String = self.facade.buscarStock(res: JSON);
                    if (cantidad != "Este producto ya no está disponible") {
                        //  numberPickerCarrito.setMaxValue(Integer.valueOf(cantidad));
                    } else {
                        // numberPickerCarrito.setEnabled(false);
                    }
                    //numberPickerCarrito.setValue(cant);
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
            let pro: Producto = productos[index]
            let precioNeto = preciosNetos[index]
            
            acum = precioNeto * Double(CARRITO_ACTUAL.carritoDetalles[index].quantity)
        }
        return acum;
    }
    
    func buscarDirecciones() {
        Alamofire.request("\(facade.WEB_PAGE)/addresses?filter[id_customer]=\(USUARIO_ID)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.ids = self.facade.existenDirecciones(res: JSON);
                    self.buscarDireccion(hijo: 0);
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
    }
    
    func buscarDireccion(hijo: Int) {
        Alamofire.request("\(facade.WEB_PAGE)/addresses/\(ids[hijo])").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    var direccion: Direccion = self.facade.buscarDireccion(res: JSON);
                    self.direcciones.append(direccion);
                    self.seguirBuscando(lista: self.ids, hijo: hijo);
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
    }
    
    func seguirBuscando(lista: Array<String>, hijo: Int) {
        var hij: Int = hijo
        hij += 1
        if (hij < lista.count) {     // ¿Hay mas direcciones?
            self.buscarDireccion(hijo: hij);
        } else {
            self.cargarSpiners();
        }
    }
    
    func cargarSpiners() {
        /*for (Direccion dir : direcciones) {
         alias.add(dir.getAlias());
         }
         ArrayAdapter<String> dataAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, alias);
         dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
         
         spinerDirecciones.setAdapter(dataAdapter);
         spinerFacturacion.setAdapter(dataAdapter);
         conversor.ActionProcessButtonValidation(btnSiguienteCarrito2, true);
         */}
    
    func limpiarSpiners() {
        /*   alias.clear();
         spinerDirecciones.setAdapter(null);
         spinerFacturacion.setAdapter(null);
         direcciones.clear();
         buscarDirecciones();
         */}
    
    //Linea 647
    func buscarEnvios(hijo: Int, imprimir: Bool) {
        
        Alamofire.request("\(facade.WEB_PAGE)/carriers?filter[deleted]=0&filter[active]=1&filter[is_free]=0").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.envio_id = self.facade.buscarEnvios(res: JSON);
                    
                    if (self.envio_id.count > 1) {
                        self.buscarEnvio(hijo: hijo, imprimir: imprimir);
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
        Alamofire.request("\(facade.WEB_PAGE)/carriers/\(self.envio_id[hijo])").validate().responseJSON { response in
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
        Alamofire.request("\(facade.WEB_PAGE)/deliveries?filter[id_carrier]=\(envio.id)&filter[id_zone]=6/").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    var id_delivery: Array<String> = self.facade.buscarDeliveries(res: JSON);
                    self.buscarPrecio(s: id_delivery[0], hijo: hijo, envio: envio, imprimir: imprimir);
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //print(error)        // Poner en comentario
            }
        }
    }
    
    
    
    
    func buscarPrecio(s: String, hijo: Int, envio: Carrier, imprimir: Bool) {
        Alamofire.request("\(facade.WEB_PAGE)/deliveries/\(s)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let deliveries: Deliveries = self.facade.buscarDelivery(res: JSON);
                    envio.deliveries = deliveries;
                    
                    if (imprimir) {
                        self.seguirBuscandoEnvio(hijo: hijo, envio: envio);
                    } else {
                        self.primerEnvio = envio;
                        var precio: Double = self.calcularPrecioEnvio(envio: envio);
                        //txtPrecioEnvio.setText("$" + String.format("%.2f", precio));
                        self.calcularTotales();
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
        imprimirEnvios(envio: envio, hijo: hijo);
        let hi = hijo+1
        
        if (hi < envio_id.count) {     // ¿Hay mas envios?
            buscarEnvio(hijo: hi, imprimir: true);
        } else {
            //self.facade.ActionProcessButtonValidation(btnSiguienteCarrito3, true);
        }
    }
    
    func imprimirEnvios(envio: Carrier, hijo: Int) {
        // PONER EN VISTA
        
        /*final ViewGroup newView = (ViewGroup) LayoutInflater.from(this).inflate(R.layout.envio_item, contenedorEnvioItem, false);
         
         final CheckBox checkEnvio = (CheckBox) newView.findViewById(R.id.checkEnvio);
         TextView txtNombreEnvio = (TextView) newView.findViewById(R.id.txtNombreEnvio);
         TextView txtTiempoEnvio = (TextView) newView.findViewById(R.id.txtTiempoEnvio);
         TextView precio_envio = (TextView) newView.findViewById(R.id.txtPrecioEnvio);
         
         txtNombreEnvio.setText(envio.getName());
         txtTiempoEnvio.setText("Tiempo de entrega: " + envio.getDelay());
         if (hijo == EnvioActivo) {
         checkEnvio.setChecked(true);
         } else {
         checkEnvio.setChecked(false);
         }
         */
        
        var precio: Double = calcularPrecioEnvio(envio: envio)
        /*precio_envio.setText("$" + String.format("%.2f", precio) + " (impuestos inc.)");
         
         checkEnvio.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
         @Override
         public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
         if (isChecked) {
         check(envio, hijo);
         }
         }
         });
         newView.setOnClickListener(new View.OnClickListener() {
         @Override
         public void onClick(View v) {
         if (!checkEnvio.isChecked()) {
         checkEnvio.setChecked(true);
         check(envio, hijo);
         }
         }
         });
         
         contenedorEnvioItem.addView(newView);
         */}
    
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
        Alamofire.request("\(facade.WEB_PAGE)/content_management_system/3/").validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.mostrarTerminosDelServicio()
                    //  mostrarTerminosDelServicio(Html.fromHtml(conversor.buscarTerminos(res)));
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
        
    }
    
    func mostrarTerminosDelServicio(){//mensaje: Spanned) {
        /*AlertDialog.Builder builder = new AlertDialog.Builder(this);
         
         builder.setTitle("TÉRMINOS Y CONDICIONES");
         builder.setMessage(mensaje);
         
         builder.setPositiveButton("Acepto Terminos y Condicones", new DialogInterface.OnClickListener() {
         public void onClick(DialogInterface dialog, int which) {
         if (!checkTerminosDelServicio.isChecked()) {
         checkTerminosDelServicio.setChecked(true);
         }
         dialog.dismiss();
         }
         });*/
    }
    
    
    
    
    
    
    
    
    
    //********************* MOSTRAR PAGOS ************************
    
    
    func mostrarPagos() {
        /* var array: String[][] = String[4][4]();
         array[0][0] = "Pago por transferencia bancaria";
         array[0][1] = "el procesamiento del pedido tomará más tiempo";
         array[0][2] = "bankwire";
         array[0][3] = "Transferencia bancaria";
         */
        /*array[1][0] = "Pagar por cheque";
         array[1][1] = "el procesamiento del pedido tomará más tiempo";
         array[1][2] = "cheque";
         array[1][3] = "Cheque";
         */
        /*
         array[1][0] = "Pagar contra reembolso";
         array[1][1] = "Usted paga la mercancía a la entrega";
         array[1][2] = "cashondelivery";
         array[1][3] = "Cash on delivery (COD)";
         */
        /*
         array[2][0] = "Pagar con HiPay";
         array[2][1] = "Asegure los pagos de Visa Mastercard y soluciones europeas";
         array[2][2] = "";
         array[2][3] = "";
         */
        /*for i in 1..2 {
         final ViewGroup newView = (ViewGroup) LayoutInflater.from(this).inflate(R.layout.botones_pago_item, contenedorPagoItem, false);
         
         ImageView imagenBoton = (ImageView) newView.findViewById(R.id.imagenBoton);
         TextView textoBoton = (TextView) newView.findViewById(R.id.textoBoton);
         TextView txtModule = (TextView) newView.findViewById(R.id.txtModule);
         TextView txtPayment = (TextView) newView.findViewById(R.id.txtPayment);
         
         textoBoton.setText(array[i][0]);
         txtModule.setText(array[i][2]);
         txtPayment.setText(array[i][3]);
         switch (i) {
         case 0:
         imagenBoton.setImageResource(R.drawable.bankwire);
         break;
         /*case 1:
         imagenBoton.setImageResource(R.drawable.cheque);
         break;*/
         case 1:
         imagenBoton.setImageResource(R.drawable.cash);
         break;
         /*case 2:
         imagenBoton.setImageResource(R.drawable.gb);
         break;*/
         }
         
         DisplayMetrics displayMetrics = new DisplayMetrics();
         getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
         
         int width = (int) (displayMetrics.widthPixels * 0.4);
         int heigth = (int) (displayMetrics.widthPixels * 0.5);
         
         imagenBoton.getLayoutParams().width = width;
         imagenBoton.getLayoutParams().height = heigth;
         
         final int aux = i;
         newView.setOnClickListener(new View.OnClickListener() {
         @Override
         public void onClick(View v) {
         MODULE = array[aux][2];
         PAYMENT = array[aux][3];
         mostrarResumen(array[aux][0], aux);
         btnSiguiente("Resumen", "Resumen del pedido", contenedorResumen, contenedorPago);
         }
         });
         newView.setOnLongClickListener(new View.OnLongClickListener() {
         @Override
         public boolean onLongClick(View v) {
         conversor.mensajeLargo(array[aux][1]);
         return false;
         }
         });
         
         contenedorPagoItem.addView(newView);
         }
         */
    }
    
    
    func mostrarResumen(tipoPago: String, tipo: Int) {
        /*   txtResumenSub.setText("Ha elegido " + tipoPago.toLowerCase() +". Aquí tiene un resumen de su pedido:");
         txtResumenCond1.setText("* El importe total de su pedido es $" + String.format("%.2f", Double.valueOf((txtTOTAL.getText().toString().replace("$", "")).replace(",", ".")))   + " (impuestos inc.)");
         txtResumenCond2.setText("* Aceptamos las siguientes monedas para las transferencias bancarias: Dollar.");
         
         switch (tipo) {
         case 0:
         txtResumenCond3.setText("* La información para realizar la transferencia bancaria aparecerá en la página siguiente.");
         break;
         case 1:
         txtResumenCond3.setText("* La orden y la dirección del cheque aparecerán en la siguiente página.");
         break;
         case 2:
         txtResumenCond3.setVisibility(View.GONE);
         break;
         case 3:
         txtResumenCond3.setVisibility(View.GONE);
         break;
         }
         txtResumenCond4.setText("* Por favor, confirme su pedido haciendo clic en \"confirmo mi pedido\".");
         */}
    
    
    func confirmarPedido() {
        /*    Log.d("Envio id", envio_id.get(EnvioActivo));
         final int DEFAULT_TIMEOUT = 20 * 1000;
         client.setTimeout(DEFAULT_TIMEOUT);
         
         Log.d("POST CCartOrder", conversor.WEB_API_AUX + "CCartOrder.php?" + parametros.toString());*/
        let id_address_delivery = "" //= txtAddressDelivery.text
        let id_address_invoice = ""//txtAddressInvoice.text
        let id_cart = "" //id_cart
        let id_currency = 1
        let id_lang = 1
        let id_carrier = envio_id //EnvioActivo?
        let module = MODULE
        let payment = PAYMENT
        let total_paid = "" //txtTOTAL.text.toString.replace
        let total_paid_real = 0
        let total_products = String(self.subtotal())
        let total_products_wt = ""//txtSubTotalProducto.text
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
        Alamofire.request("\(facade.WEB_PAGE)/orders?filter[id_customer]=\(USUARIO_ID)&sort=[id_DESC]").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.buscarOrden(id: self.facade.existeOrdenes(res: JSON)[0]);
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
                    let order: Order = self.facade.buscarOrden(res: JSON);
                    if (self.PAYMENT == "Cash on delivery (COD)") {
                        self.irPago(importe: "", propietario: "", datos: "", banco: "", referencia: order.reference);
                    } else {
                        self.buscarConfBankAddress(order: order);
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
                    self.buscarValorConfBankAddress(id: self.facade.configurations(res: JSON), order: order);
                    
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
                    self.buscarConfProp(banco: self.facade.configuration(res: JSON), order: order);
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
                    self.buscarValorConfProp(id: self.facade.configurations(res: JSON), banco: banco, order: order);
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
                    self.buscarConfDatos(propietario: self.facade.configuration(res: JSON), banco: banco, order: order);
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
                    self.buscarValorConfDatos(id: self.facade.configurations(res: JSON), propietario: propietario, banco: banco, order: order);
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
                    self.irPago(importe: ""/*txtTOTAL.getText().toString()*/, propietario: propietario, datos: self.facade.configuration(res: JSON), banco: banco, referencia: order.reference);
                }
                
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
            
        }
        
    }
    
    func irPago(importe: String, propietario: String, datos: String, banco: String, referencia: String) {
        /*
         Intent i = new Intent(this.getApplicationContext(), Pago.class);
         i.putExtra("payment", PAYMENT);
         
         i.putExtra("importe", importe);
         i.putExtra("propietario", propietario);
         i.putExtra("datos", datos);
         i.putExtra("banco", banco);
         i.putExtra("referencia", referencia);
         Log.d("Pago", PAYMENT + importe + propietario + datos + banco + referencia);
         startActivity(i);
         overridePendingTransition(R.anim.slide_in_right,R.anim.slide_out_left);
         finish();*/
    }
    
    //Linea 1183
    @IBAction func btnAtras(_ sender: UIBarButtonItem) {
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
