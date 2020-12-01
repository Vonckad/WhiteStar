//
//  SubCategoryViewController.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 11/2/20.
//

import UIKit

class SubCategoryViewController: UIViewController {

    @IBOutlet var subCategoryTableView: UITableView!
    
    @IBOutlet var titileSubCategory: UINavigationItem!
    var subCategory: [CategoryArray] = []
    var titleCategory: String = "Подкатегории"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.prefersLargeTitles = true
//        titileSubCategory.title = "Подкатегории"
//        print("sub === ", subCategory)
        titileSubCategory.title = titleCategory
    }
}

extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellSubCategory = tableView.dequeueReusableCell(withIdentifier: "CellSubCategory", for: indexPath)
//        print("titleCategory === ", titleCategory)
       
        cellSubCategory.textLabel?.text = subCategory[indexPath.row].name
        return cellSubCategory
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        ProductViewController
        
        let id = subCategory[indexPath.row]
   
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let productVC = storyboard.instantiateViewController(identifier: "ProductViewController") as! ProductViewController
        productVC.idString = id.id.getStringValue()
        productVC.titileName = id.name
            navigationController?.pushViewController(productVC, animated: true)
    }
}
