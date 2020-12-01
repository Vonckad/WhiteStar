//
//  BasketViewController.swift
//
//
//  Created by Vlad Ralovich on 8/18/20.
//

import UIKit
import RealmSwift

    class BasketViewController: UIViewController {
        
        @IBOutlet var tableViewRealm: UITableView!
        @IBOutlet var summPriceLabel: UILabel!
        
        private var realm: Realm!
        
        var size: String?
        var name: String?
        var price: String?
        var colorName: String?
//        var summprice = 0
        var imageData: Data?
        
        @IBOutlet var checkoutButtonLayer: UIView!
        
        var toDoList: Results<PersistanceRealm> {
            get {
                return realm.objects(PersistanceRealm.self)
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableViewRealm.allowsSelection = false
            checkoutButtonLayer.layer.cornerRadius = 10
            realm = try! Realm()
            
            let todoListItem = PersistanceRealm()
            
            if let sizeR = size, let nameR = name, let priceR = price, let colorNameR = colorName, let imageDataR = imageData {
                
                print("Записал в Realm")
                
                todoListItem.size = sizeR
                todoListItem.name = nameR
                todoListItem.price = priceR
                todoListItem.colorName = colorNameR
                todoListItem.imageData = imageDataR
                
                print(" todoListItem.imageData = imageData === ",  todoListItem.imageData)
                
                try! self.realm.write({
                    self.realm.add(todoListItem)

                    self.tableViewRealm.insertRows(at: [IndexPath.init(row: self.toDoList.count-1, section: 0  )], with: .automatic)
            })
        }
    }
            
        @IBAction func checkoutButton(_ sender: Any) {
            
            let allert = UIAlertController.init(title: "Ваш заказ оформлен!", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
            allert.addAction(action)
            present(allert, animated: true, completion: nil)

            print("Ваш заказ оформлен.")
        }
    }

    //MARK: extension BasketViewControlle
extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableDataSourse
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return toDoList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableViewRealm.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
            
            let item = toDoList[indexPath.row]
            cell.sizebleCell.text = "Размер: \(item.size)\nЦвет: \(item.colorName)"
            cell.nameLableCell.text = item.name
            cell.priceLableCell.text = "\(item.price) руб."
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
                let item = self.toDoList[indexPath.row]
               
                if (editingStyle == .delete) {
                    try! self.realm.write({
                        self.realm.delete(item)
                    })
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            allert.addAction(addAction)
            present(allert, animated: true, completion: nil)
    }
}
