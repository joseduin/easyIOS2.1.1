//
//  BusquedaViewController.swift
//  market
//
//  Created by Jose Duin on 1/5/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class BusquedaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // listener al scrol del tableview, cargar de a dos art 
    // Pasar la imagen de sadSearch
    
    @IBOutlet weak var botonesFiltro: UISegmentedControl!
    @IBOutlet weak var sadSearch: UIImageView!
    @IBOutlet weak var existencia: UILabel!
    @IBOutlet weak var contenedorProductos: UITableView!
    @IBOutlet weak var contenedorBusqueda: UIView!
    @IBOutlet weak var contenedorBusquedaFallida: UIView!
    @IBOutlet weak var contenedorFiltros: UIView!
    @IBOutlet weak var txtBusqueda: UITextField!
    
    let cantidadDeProductos: Int = 2     // Cantidad de productos por carga!!
    var contarProductosImpresos: Int = 1
    var loadingproductos: Bool = false
    var hijoProducto: Int = 0
    var productoLista: [Producto] = [Producto]()
    //private Calendar fechaActual = Calendar.getInstance();
    //private static; int widthProductos;
    var productoPass: Producto = Producto()
    
    let facade: Facade = Facade()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        contenedorProductos.delegate = self
        contenedorProductos.dataSource = self
        contenedorProductos.separatorStyle = .none
        contenedorProductos.backgroundColor = UIColor.clear
        contenedorProductos.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        contenedorBusqueda.isHidden = true
        contenedorBusquedaFallida.isHidden = true

    }
    
    func buscar() {
        if (!(txtBusqueda.text == "")) {
            txtBusqueda.isEnabled = false
            buscarProductos()
        } else {
            mensaje(mensaje: "Escriba lo que desee buscar", cerrar: false)
        }
    }
    
    func buscarProductos() {
        let ordenar: String = (self.botonesFiltro.selectedSegmentIndex == 0) ? "" : (self.botonesFiltro.selectedSegmentIndex == 1) ? "&sort=[price_DESC]" : "&sort=[price_ASC]"
        Alamofire.request("\(self.facade.WEB_PAGE)/products/?display=full&filter[name]=[\(txtBusqueda.text!)]%25\(ordenar)&\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    
                    self.productoLista.removeAll()
                    self.contenedorProductos.reloadData()
                    
                    self.productoLista = self.facade.buscarProductoSearch(res: JSON)
                    self.contenedorProductos.reloadData()
                    
                    self.hijoProducto = 0
                    if (self.productoLista.count > 0) {
                        
                        self.existencia.text = "\(self.productoLista.count) \((self.productoLista.count == 1) ? "resultado encontrado." : "resultados encontrados.")";
                        
                        self.seguirBuscandoProducto()
                    } else {
                        self.sad_search()
                        self.txtBusqueda.isEnabled = true
                    }
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    
    }

    func sad_search() {
        if (contenedorBusqueda.isHidden == false) {
            contenedorBusqueda.isHidden = true
        }
        if (contenedorFiltros.isHidden == false) {
            contenedorFiltros.isHidden = true
        }
        contenedorBusquedaFallida.isHidden = false
    }
    
    func buscarImagen(id: String, tipo: String, imagenSize: String, imagen: UIImageView) {
        
        let url = URL(string: "\(self.facade.WEB_PAGE)/images/\(tipo)/\(id)/\(imagenSize)?\(facade.parametrosKey())")
        imagen.hnk_setImage(from: url!)
    }
    
    func seguirBuscandoProducto() {
        //if (loadingProductsSearch.getVisibility() == View.VISIBLE) {
        //    loadingProductsSearch.setVisibility(View.GONE);
        //}
        //buscarHoraEcuador();
        validarImprimirProductos()
    }
    
    func validarImprimirProductos() {
        //insertProducto(producto: productoLista[hijoProducto])
    
        //hijoProducto += 1
        //if (contarProductosImpresos != cantidadDeProductos) {
    
        //    contarProductosImpresos += 1
        //    if (hijoProducto < productoLista.count) {     // ¿Hay mas productos?
        //        buscarImagene();
        //    } else {
                txtBusqueda.isEnabled = true
        //        loadingproductos = true;
        //    }
        //} else {
        //    txtBusqueda.setEnabled(true);
        //    loadingproductos = true;
        //}
        
        if (contenedorBusqueda.isHidden == true) {
            contenedorBusqueda.isHidden = false
            contenedorFiltros.isHidden = true
        }
        if (contenedorBusquedaFallida.isHidden == false) {
            contenedorBusquedaFallida.isHidden = true
        }
    }
    
    //func insertProducto(producto: Producto) {
        //productoLista.append(producto)
        //let indexPath = IndexPath(row: 0, section: 0)
        //contenedorProductos.reloadData()
        //insertRows(at: [indexPath], with: .automatic)
    //}
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return productoLista.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoViewCell") as! ProductoViewCell
            
            let producto = productoLista[indexPath.row]
            cell.estado.text = producto.condition
            self.buscarImagen(id: "\(producto.id)/\(producto.imagenes[0])", tipo: "products", imagenSize: "large_default", imagen: cell.imagen)
            cell.descripcion.text = producto.name
            cell.precio.text = "$\(producto.price)"
            print(producto.name)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.productoPass = productoLista[indexPath.row]
            performSegue(withIdentifier: "ProductoDetalleViewController2", sender: nil)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ProductoDetalleViewController2" {
                
                let nav = segue.destination as! UINavigationController
                let addEventViewController = nav.topViewController as! ProductoDetalleViewController
                
                addEventViewController.productoPass = self.productoPass
            }
        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func btnAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func btnBuscar(_ sender: Any) {
        buscar()
    }
    @IBAction func irAFiltro(_ sender: Any) {
        //if (contenedorFiltros.isHidden) {
            contenedorBusqueda.isHidden = true
            contenedorFiltros.isHidden = false
        //}
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
