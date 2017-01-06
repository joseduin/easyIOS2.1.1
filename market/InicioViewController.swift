//
//  ViewController.swift
//  market
//
//  Created by Jose Duin on 11/18/16.
//  Copyright © 2016 Jose Duin. All rights reserved.
//

import UIKit
import Alamofire

class InicioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var correoNavigation: UILabel!
    @IBOutlet weak var menuContenedor: UITableView!
    
    let facade: Facade = Facade()
    
    var items : [NavigationModel]!
    var CATEGORIA_PADRE: Categoria = Categoria()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Easy Market"
        
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // no se para que estos e.e
        //tabBarController?.tabBar.barTintColor = UIColor.brown
        //tabBarController?.tabBar.tintColor = UIColor.yellow
        
        shadowView.isHidden = true
        menuView.isHidden = true
        estiloSliderMenu()
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(InicioViewController.swipeRightSlider(_:)))
        //swipeRight.direction = .right
        swipeRight.edges = .left
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(InicioViewController.swipeLeftSlider(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // Menu Contenedor
        menuContenedor.delegate = self
        menuContenedor.dataSource = self
        menuContenedor.separatorStyle = .none
        menuContenedor.backgroundColor = UIColor.clear
        
        let item1 = NavigationModel(title: "Categorias", icon: "ic_local_activity")
        let item2 = NavigationModel(title: "Mis Ordenes", icon: "ic_assignment")
        let item3 = NavigationModel(title: "Carrito", icon: "ic_shopping_cart_48pt")
        let itemEmpty = NavigationModel(title: "", icon: "")
        let item4 = NavigationModel(title: "Mi Perfil", icon: "ic_person_48pt")
        let item5 = NavigationModel(title: "Mis Direcciones", icon: "ic_receipt")
        let item6 = NavigationModel(title: "Cerrar Sesión", icon: "ic_lock_48pt")
        
        // Prueba
        let item7 = NavigationModel(title: "Como comprar", icon: "ic_lock_48pt")
        let item8 = NavigationModel(title: "Contactenos", icon: "ic_lock_48pt")

        
        items = [item1, item2, item3, itemEmpty, item4, item5, item6, item7, item8]
        
        isLogin()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuViewCell") as! MenuViewCell
        
        let item = items[indexPath.row]
        
        cell.descripcion.text = item.title
        cell.imagenIcon.image = UIImage(named: item.icon)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        
        let index = indexPath[1]
        switch index {
        case 0:
            buscarCategorias()
            break
        case 1:
            self.performSegue(withIdentifier: "direccionesView", sender: self)
            break
        case 2:
            print(items[index].title)
            break
        case 4:
            self.performSegue(withIdentifier: "datosView", sender: self)
            break
        case 5:
            self.performSegue(withIdentifier: "direccionesRealView", sender: self)
            break
        case 6:
            btnLogOut()
            break
            
            
            // Prueba
        case 7:
            self.performSegue(withIdentifier: "ComoComprarViewController", sender: self)
            break;
        case 8:
            self.performSegue(withIdentifier: "ContactoViewController", sender: self)
        default:
            print(items[index].title)
        }
    }
    
    func buscarCategorias() {
        Alamofire.request("\(self.facade.WEB_PAGE)/categories/22?\(facade.parametrosBasicos())").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.CATEGORIA_PADRE = self.facade.buscarCategoria(res: JSON)
                    self.performSegue(withIdentifier: "CategoriasXMLViewController", sender: self)
                }
            case .failure(let error):
                self.mensaje(mensaje: self.facade.ERROR_LOADING, cerrar: false)
                print(error)        // Poner en comentario
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoriasXMLViewController" {
            
            let nav = segue.destination as! UINavigationController
            let addEventViewController = nav.topViewController as! CategoriasXMLViewController
            
            addEventViewController.CATEGORIA_PADRE = self.CATEGORIA_PADRE
            addEventViewController.TITULO = 0
            addEventViewController.PADRE = ""
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    func swipeRightSlider(_ gesture: UIGestureRecognizer) {
        if (menuView.isHidden) {
            sliderBarOpen(option: true)
        }
    }
    
    func swipeLeftSlider(_ gesture: UIGestureRecognizer) {
        if (!menuView.isHidden) {
            sliderBarOpen(option: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Vista despues de cargarse
    override func viewDidAppear(_ animated: Bool) {        
        correoNavigation.text = UserDefaults.standard.string(forKey: "email")
        
    }
    
    func isLogin() {
        let isLogin: Bool = UserDefaults.standard.bool(forKey: "isLogin")
        if (!isLogin) {
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
    
    func estiloSliderMenu() {
        menuView.layer.shadowOpacity = 0.6
        menuView.layer.shadowOffset = CGSize(width: 3.0, height: 0.0)
        menuView.layer.shadowRadius = 4.0
        menuView.layer.shadowColor = UIColor.black.withAlphaComponent(0.0).cgColor
        
        shadowView.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.9).cgColor
    }
    
    func sliderBarOpen(option: Bool) {
        let screenSize = UIScreen.main.bounds
        let height = screenSize.height
        let width = menuView.bounds.width
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        // let navigationHeight = navigationController?.navigationBar.bounds.height
        
        let centerX = width / 2
        let centerY = (height / 2) - (statusBarHeight * 2) //+ navigationHeight!
        
        if (option) {
            
            // botonMenu.image = UIImage(named: "lupa")
            shadowView.isHidden = false
            menuView.isHidden = false
            shadowView.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.0).cgColor
            menuView.center = CGPoint(x: -centerX, y: centerY)
            
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
                
                self.menuView.center = CGPoint(x: centerX, y: centerY)
                self.shadowView.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.9).cgColor
            }, completion: nil)
        } else {
            
            // botonMenu.image = UIImage(named: "menu")
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
                
                self.menuView.center = CGPoint(x: -centerX, y: centerY)
                self.shadowView.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.0).cgColor
            }, completion: {
                (value: Bool) in
                self.shadowView.isHidden = true
                self.menuView.isHidden = true
            })
        }
        
    }
    
    func btnLogOut() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
    // Botones
    @IBAction func irBusqueda(_ sender: Any) {
        self.performSegue(withIdentifier: "BusquedaViewController", sender: self)
    }
    
    @IBAction func btnNavigation(_ sender: Any) {
        if (menuView.isHidden) {
            sliderBarOpen(option: true)
        } else {
            sliderBarOpen(option: false)
        }
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

class NavigationModel {
    
    var title : String!
    var icon : String!
    
    init(title: String, icon : String){
        self.title = title
        self.icon = icon
    }
    
}
