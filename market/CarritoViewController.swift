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

class CarritoViewController: UIViewController {
    
    let facade: Facade = Facade()
    var envio_id: Array<String> = []
    var primerEnvio: Carrier = Carrier()
    var USUARIO_ID: String = ""
    var MODULE: String = ""
    var PAYMENT: String = ""
    var CARRITO_ACTUAL: Carrito = Carrito()
    var productos: Array<Producto> = Array<Producto>()
    var ids: Array<String> = Array<String>()
    var direcciones: Array<Direccion> = Array<Direccion>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Linea 200
    
    func buscarCarrito(existencia: String) {
        Alamofire.request("\(facade.WEB_PAGE)/carts/\(existencia)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    var carrito: Carrito = self.facade.buscarCarrito(res: JSON);
                    self.validarQueCarritoNoSeaUnaOrden(carrito: carrito);
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
    }
    
    
    func  validarQueCarritoNoSeaUnaOrden(carrito: Carrito) {
        Alamofire.request("\(facade.WEB_PAGE)/orders?filter[id_cart]=\(carrito.id)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    var validar: String = self.facade.validarQueCarritoNoSeaUnaOrden(res: JSON);
                    if (validar == "no") { // El carrito actual no es una orden
                        self.examinarCarrito(carrito: carrito);
                    } else {
                        //contenedorCarrito.setVisibility(View.GONE);
                        //existeCarrito.setVisibility(View.VISIBLE);
                        //existeCarrito.setText("Su carrito está vacío.");
                    }
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
    }
    
    
    func examinarCarrito(carrito: Carrito) {
        if (carrito.carritoDetalles == nil) {
            //contenedorCarrito.setVisibility(View.GONE);
            //existeCarrito.setVisibility(View.VISIBLE);
            //existeCarrito.setText("Su carrito está vacío.");
            return;
        }
        //************************************** ME COMIO *****************
        
        CARRITO_ACTUAL = carrito;
        //contenedorTotalPrecios.setVisibility(View.VISIBLE);
        var prod: Array<String> = Array<String>();
        /*for (_, subJson):(detalle: CarritoDetalle,: carrito.carritoDetalles) in CARRITO_ACTUAL {
         prod.add(detalle.getId_product());
         }
         *******************************************************************/
        
        self.buscarProductos(hijo: 0, prod: prod, carrito: carrito);
    }
    
    
    func buscarProductos(hijo: Int, prod: Array<String>, carrito: Carrito) {
        Alamofire.request("\(facade.WEB_PAGE)/products/\(prod[hijo])?").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    var producto: Producto = self.facade.buscarProducto(res: JSON);
                    //  self.buscarImagene(producto, "\(producto.id)/\(producto.imagenes[0])", prod, hijo, carrito);
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
        
    }
    
    func buscarImagene(producto: Producto, imagen: String, imagenes: Array<String>, hijo: Int, carrito: Carrito) {
        Alamofire.request("\(facade.WEB_PAGE)/images/products/\(imagen)/small_default?").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //  producto.id_default_image(self.facade.BitMapToString(BitmapFactory.decodeByteArray(bytes, 0, bytes.length)));
                    
                    //SET IMAGEN
                    self.productos.append(producto);
                    
                    //buscarSiTieneDescuento(hijo, imagenes, carrito);
                    self.seguirBuscandoProducto(hijo: hijo, productos: imagenes, carrito: carrito, precioNeto: Double(self.productos[hijo].price/*.replace(",", ".")*/)!);          }
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
    
    func seguirBuscandoProducto(hijo: Int, productos: Array<String>, carrito: Carrito, precioNeto: Double) {
        self.imprimirProductos(carrito: carrito, position: hijo, precioNeto: precioNeto);
        var hij: Int = hijo;
        hij += 1
        if (hij < productos.count) {     // ¿Hay mas productos?
            self.buscarProductos(hijo: hij, prod: productos, carrito: carrito);
        } else {
            self.buscarEnvios(hijo: 0, imprimir: false);
        }
    }
    
    
    
    
    //Linea 413
    func calcularTotales() {
        //var subtotal: Double = subtotal();
        //txtSubTotaProducto.setText("$" + subtotal);
        //var envioString: String = txtPrecioEnvio.getText().toString().replace("$", "");
        //var envio: Double = Double(envioString.replace(",", "."));
        //var total: Double = subtotal + envio;
        //txtTOTAL.setText("$" + total);
    }
    
    func imprimirProductos(carrito: Carrito, position: Int, precioNeto: Double) {
        /*  final ViewGroup newView = (ViewGroup) LayoutInflater.from(this).inflate(R.layout.carrito_item, recycleCarrito, false);
         
         TextView nombreProductoCarrito = (TextView) newView.findViewById(R.id.nombreProductoCarrito);
         TextView precioProductoCarrito = (TextView) newView.findViewById(R.id.precioProductoCarrito);
         final TextView precioTotalCarrito = (TextView) newView.findViewById(R.id.precioTotalCarrito);
         
         ImageView imageCarrito = (ImageView) newView.findViewById(R.id.imageCarrito);
         
         final NumberPicker numberPickerCarrito = (NumberPicker) newView.findViewById(R.id.numberPickerCarrito);
         
         Button ButtonMenosCantidadCarrito = (Button) newView.findViewById(R.id.ButtonMenosCantidadCarrito);
         Button buttonMasCantidadCarrito = (Button) newView.findViewById(R.id.buttonMasCantidadCarrito);
         
         ImageButton btnEliminarProductocarrito = (ImageButton) newView.findViewById(R.id.btnEliminarProductocarrito);
         
         LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(imageWigth, imageWigth);
         imageCarrito.setLayoutParams(params);
         
         int width = (int) (imageWigth * 0.8);
         nombreProductoCarrito.setWidth(imageWigth);
         precioProductoCarrito.setWidth(imageWigth);
         precioTotalCarrito.setWidth(imageWigth);
         
         numberPickerCarrito.setLayoutParams(new LinearLayout.LayoutParams(width, width / 2));
         LinearLayout.LayoutParams para = new LinearLayout.LayoutParams(width / 2, width / 2);
         buttonMasCantidadCarrito.setLayoutParams(para);
         ButtonMenosCantidadCarrito.setLayoutParams(para);
         
         nombreProductoCarrito.setText(productos.get(position).getName());
         
         precioProductoCarrito.setText("$" + String.format("%.2f", precioNeto));
         precioTotalCarrito.setText("$" + String.format("%.2f", precioNeto * Integer.valueOf(carrito.getCarritoDetalles().get(position).getQuantity())));
         
         
         imageCarrito.setImageBitmap(conversor.StringToBitMap(productos.get(position).getId_default_image()));
         numberPickerCarrito.setMinValue(1);
         numberPickerCarrito.setWrapSelectorWheel(false);
         buscarStock(productos.get(position).getStock_availables().get(0), Integer.valueOf(carrito.getCarritoDetalles().get(position).getQuantity()), numberPickerCarrito);
         
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
    
    func confirmarEliminarProductoCarrito(nombre: String) {
        /*AlertDialog.Builder builder = new AlertDialog.Builder(this);
         
         builder.setTitle("Confirmación");
         builder.setMessage("¿Seguro de sacar del carrito \"" + nombre + "\" ?");
         
         builder.setPositiveButton("SI", new DialogInterface.OnClickListener() {
         public void onClick(DialogInterface dialog, int which) {
         // Do something
         dialog.dismiss();
         }
         });
         
         builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
         @Override
         public void onClick(DialogInterface dialog, int which) {
         
         dialog.dismiss();
         }
         });
         
         AlertDialog alert = builder.create();
         alert.show();
         */}
    
    
    //***************************PICKERS**************************
    
    
    func actualizarCantidadDeProductosEnCarrito(cantidad: Int, position: Int, carrito: Carrito/*, final TextView precioTotalCarrito,*/, precio: String) {
        
        Alamofire.request("\(facade.WEB_API_AUX)/UCartItemQuantity.php?id=\(carrito.id)&row=\(position)&qua=\(cantidad)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //precioTotalCarrito.setText("$" + String.format("%.2f", (Double.valueOf(precio.replace(",", ".")) * cantidad)));
                    self.calcularTotales();
                }
            case .failure( _):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                //  print(error)        // Poner en comentario
            }
        }
        
    }
    
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
        /*for (int i = 0; i < recycleCarrito.getChildCount(); i++) {
         View hijo = recycleCarrito.getChildAt(i);
         TextView precioTotalCarrito = (TextView) hijo.findViewById(R.id.precioTotalCarrito);
         String precio = precioTotalCarrito.getText().toString().replace("$", "");
         acum += Double.valueOf(precio.trim().replace(",", "."));
         }*/
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
