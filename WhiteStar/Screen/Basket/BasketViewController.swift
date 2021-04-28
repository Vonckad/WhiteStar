//
//  BasketViewController.swift
//
//
//  Created by Vlad Ralovich on 8/18/20.
//

import UIKit
//import RealmSwift //<------- вынес в отдельный класс

    class BasketViewController: UIViewController {
        
        @IBOutlet var tableViewRealm: UITableView!
        @IBOutlet var summPriceLabel: UILabel!
        
//        private var realm: Realm!
        var myRealm: MyRealmProtocol = MyRealm()
        
        var size: String?
        var name: String?
        var price: String?
        var colorName: String?
        var count: Int?
        var summprice = 0
        var imageData: Data?
        
        @IBOutlet var checkoutButtonLayer: UIView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableViewRealm.allowsSelection = false
            checkoutButtonLayer.layer.cornerRadius = 10
    
            myRealm.load()
            
// это по-моему сверх неправильное (некоректное) решение поиска совпавших товаров в карзине// но пока только оно работает
            if let sizeR = size, let nameR = name, let priceR = price, let colorNameR = colorName, let
                imageDataR = imageData, let countR = count {
                
                let todoListItem = PersistanceRealm()
                
                func createItem() {
                    todoListItem.size = sizeR
                    todoListItem.name = nameR
                    todoListItem.price = priceR
                    todoListItem.count = countR
                    todoListItem.colorName = colorNameR
                    todoListItem.imageData = imageDataR
                }
                
                if myRealm.toDoListR.count == 0 {
                    createItem()
                } else {
                    
                for i in myRealm.toDoListR {
                    if i.name == nameR && i.size == sizeR {
                        createItem()
                        todoListItem.count = i.count + 1
                        todoListItem.price = String( Int(priceR)! * todoListItem.count)
                        myRealm.addInRealm(item: i, bool: false)
                        } else {
                            createItem()
                        }
                    }
                }
                myRealm.addInRealm(item: todoListItem, bool: true)
                
                self.tableViewRealm.insertRows(at: [IndexPath.init(row: self.myRealm.toDoListR.count-1, section: 0)], with: .automatic)
        }
            getTotalPrice()
    }
        func getTotalPrice() {
            summprice = 0
            for it in myRealm.toDoListR {
                if let price = Int(it.price) {
                    summprice += price
                    summPriceLabel.text = "\(String(summprice)) руб."
                }
            }
        }
        
        @IBAction func checkoutButton(_ sender: Any) {
            
            let allert = UIAlertController.init(title: "Ваш заказ оформлен!", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
            allert.addAction(action)
            present(allert, animated: true, completion: nil)
        }
    }

    //MARK: extension BasketViewControlle

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableDataSourse
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return myRealm.toDoListR.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableViewRealm.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
            
            let item = myRealm.toDoListR[indexPath.row]
            cell.sizebleCell.text = "Размер: \(item.size)\nЦвет: \(item.colorName)"
            cell.nameLableCell.text = item.name
            cell.priceLableCell.text = "\(item.price) руб."
            cell.countLabel.text = "Количество: \(item.count)"
            cell.imageCell.image = UIImage(data: item.imageData)
            return cell
        }
        
        //MARK: UITableDelegate
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            let allert = UIAlertController.init(title: "Вы действительно хотите удалить товар?", message: "", preferredStyle: .alert)
            let canceAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
            allert.addAction(canceAction)
            
            let addAction = UIAlertAction(title: "Да", style: .destructive) { [self] (UIAlertAction) -> Void in
                let item = self.myRealm.toDoListR[indexPath.row]
               
                if (editingStyle == .delete) {
                    myRealm.addInRealm(item: item, bool: false)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    getTotalPrice()
                }
            }
            allert.addAction(addAction)
            present(allert, animated: true, completion: nil)
    }
}
