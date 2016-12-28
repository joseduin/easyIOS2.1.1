//
//  CategoriasXMLViewController.swift
//  market
//
//  Created by Jose Duin on 12/14/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class CategoriasXMLViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    // Hacer productos land
    // Listener para ambos scroll
    
    @IBOutlet weak var imagenBanner: UIImageView!
    @IBOutlet weak var nombreCategoria: UILabel!
    @IBOutlet weak var subcategoria: UILabel!
    @IBOutlet weak var flecha_izq: UIImageView!
    @IBOutlet weak var flecha_der: UIImageView!
    @IBOutlet weak var existencia: UILabel!
    @IBOutlet weak var contenedorCategorias: UICollectionView!
    @IBOutlet weak var contenedorProductos: UITableView!
    
    let facade: Facade = Facade()
    
    var ID_USUARIO: String = ""
    var TITULO: Int = 0
    var CATEGORIA_PADRE: Categoria = Categoria()
    var PADRE: String = ""
    
    var contarProductosImpresos: Int = 1
    var categoria_lista: [Categoria] = [Categoria]()
    var hijoProducto: Int = 0;
    var producto_lista: [Producto] = [Producto]()
    var productoPass: Producto = Producto()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
       
        contenedorCategorias.delegate = self
        contenedorCategorias.dataSource = self
        
        contenedorProductos.delegate = self
        contenedorProductos.dataSource = self
        contenedorProductos.separatorStyle = .none
        contenedorProductos.backgroundColor = UIColor.clear
        contenedorProductos.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
 
        subcategoria.isHidden = true
        flecha_izq.isHidden = true
        flecha_der.isHidden = true
        existencia.isHidden = true
        buscarImagen(id: CATEGORIA_PADRE.id, tipo: "categories", imagenSize: "category_default", imagen: imagenBanner)
        
        let isLogin: Bool? = UserDefaults.standard.bool(forKey: "isLogin")
        if (isLogin == nil) {
            ID_USUARIO = ""
        } else {
            ID_USUARIO = UserDefaults.standard.string(forKey: "id")!
        }
        
        self.navigationItem.title = PADRE == "" ? "\(CATEGORIA_PADRE.name)" : "\(PADRE) - \(CATEGORIA_PADRE.name)"
        nombreCategoria.text = CATEGORIA_PADRE.name
        
        // Busquedas
        
        if (CATEGORIA_PADRE.subCategorias.count > 0) {
            subcategoria.isHidden = false
            subcategoria.text = TITULO == 0 ? "Categorías" : CATEGORIA_PADRE.subCategorias.count == 1 ? "Subcategoría" : "Subcategorías"
            //removeAllView(contenedor: contenedorCategorias)
            buscarCategorias(hijo: 1, categorias: CATEGORIA_PADRE.subCategorias)
        }
        
        if (CATEGORIA_PADRE.productos.count > 0) {
            existencia.isHidden = false
            existencia.text = CATEGORIA_PADRE.productos.count == 1 ? "Hay 1 producto." : "Hay \(CATEGORIA_PADRE.productos.count) productos"
            //self.removeAllView(contenedor: contenedorProductos)
            contarProductosImpresos = 1
            buscarProductos()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func buscarImagen(id: String, tipo: String, imagenSize: String, imagen: UIImageView) {
        
        let url = URL(string: "\(self.facade.WEB_PAGE)/images/\(tipo)/\(id)/\(imagenSize)?\(facade.parametrosKey())")
        imagen.hnk_setImage(from: url!)
    }
    
    func buscarCategorias(hijo: Int, categorias: [String]) {
        Alamofire.request("\(self.facade.WEB_PAGE)/categories/\(categorias[hijo - 1])?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let categoria: Categoria = self.facade.buscarCategoria(res: JSON)
                    self.seguirBuscandoCategoria(hijo: hijo, categorias: categorias, categoria: categoria)
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func seguirBuscandoCategoria(hijo: Int, categorias: [String], categoria: Categoria) {
        insertCategoria(categoria: categoria)
    
        if (hijo < categorias.count) {     // ¿Hay mas categorias?
            let hijoAux = hijo + 1
            buscarCategorias(hijo: hijoAux, categorias: categorias)
        }
        
        // Ocultar flechitas
        //contWidthCategorias +=  imageWigth;
        //if (pantallaWidth < contWidthCategorias) {
        //    flechita_der.setVisibility(View.VISIBLE);
        //}
    }
    
    func insertCategoria(categoria: Categoria) {
        categoria_lista.append(categoria)
        contenedorCategorias.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoria_lista.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriaViewCell", for: indexPath) as! CategoriaViewCell
        
        let categoria = categoria_lista[indexPath.row]
        self.buscarImagen(id: categoria.id, tipo: "categories", imagenSize: "medium_default", imagen: cell.imagen)
        cell.descripcion.text = categoria.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.orderPass = items[indexPath.row]
        //performSegue(withIdentifier: "direccionView", sender: nil)
        
        print(indexPath.row)
    }
    
    func buscarProductos() {
        Alamofire.request("\(self.facade.WEB_PAGE)/products/\(CATEGORIA_PADRE.productos[hijoProducto])?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let producto: Producto = self.facade.buscarProducto(res: JSON)
                    self.seguirBuscandoProducto(producto: producto)
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func seguirBuscandoProducto(producto: Producto) {
        //if (loadingProducts.getVisibility() == View.VISIBLE) {
        //    loadingProducts.setVisibility(View.GONE);
        //}
        //buscarHoraEcuador(producto);
        validarImprimirProductos(producto: producto);
    }
    
    func validarImprimirProductos(producto: Producto) {
        insertProducto(producto: producto)
    
        hijoProducto = hijoProducto + 1
        //if (contarProductosImpresos != cantidadDeProductos) {
    
            contarProductosImpresos = contarProductosImpresos + 1
            if (hijoProducto < CATEGORIA_PADRE.productos.count) {     // ¿Hay mas productos?
                buscarProductos()
            }
        //} else {
           // loadingproductos = true;
        //}
    }
    
    func insertProducto(producto: Producto) {
        producto_lista.append(producto)
        //let indexPath = IndexPath(row: 0, section: 0)
        contenedorProductos.reloadData()
        //insertRows(at: [indexPath], with: .automatic)
    }
    
    // Producutos
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return producto_lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoViewCell") as! ProductoViewCell
            
        let producto = producto_lista[indexPath.row]
        cell.estado.text = producto.condition
        self.buscarImagen(id: "\(producto.id)/\(producto.imagenes[0])", tipo: "products", imagenSize: "large_default", imagen: cell.imagen)
        cell.descripcion.text = producto.name
        cell.precio.text = "$\(producto.price)"
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.productoPass = producto_lista[indexPath.row]
        performSegue(withIdentifier: "ProductoDetalleViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductoDetalleViewController" {
            
            let nav = segue.destination as! UINavigationController
            let addEventViewController = nav.topViewController as! ProductoDetalleViewController
            
            addEventViewController.productoPass = self.productoPass
        }
    }

    
    func removeAllView(contenedor: UITableView) {
        let views = contenedor.subviews

        for index in 0..<views.count {
            let view = contenedor.viewWithTag(index)!
            contenedor.willRemoveSubview(view)
        }
    }

    func existeCarrito() {
        Alamofire.request("\(self.facade.WEB_PAGE)/carts?filter[id_customer]=\(ID_USUARIO)?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.irCarrito(id: self.facade.existeCarrito(res: JSON))
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    func irCarrito(id: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
