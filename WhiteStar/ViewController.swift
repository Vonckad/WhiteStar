//
//  ViewController.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 10/19/20.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet var categoriTableView: UITableView!
    
    var category = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
    
        categoriTableView.register(CellCategory.nib(), forCellReuseIdentifier: "CellCategory")
    }

    func load() {
        AlamofireLoader().loadCategory { modelCategory in
            let data = modelCategory.main
            self.category.append(data)
            self.categoriTableView.reloadData()
//            print("data === ", data)
//            print("count === ", self.category[0].subcategories.count)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.first?.subcategories.count ?? category.count
        //!!!
        //знаю что это криво, потом исправлю
        //при добавлении Realm это исправиться само собой
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCategory = categoriTableView.dequeueReusableCell(withIdentifier: "CellCategory", for: indexPath) as! CellCategory
        
        cellCategory.configurate(with: /*self.category.first?.subcategories[indexPath.row] ??*/ self.category[0].subcategories[indexPath.row])

        return cellCategory
    }
}
