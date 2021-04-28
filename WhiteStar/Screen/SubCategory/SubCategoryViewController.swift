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
        titileSubCategory.title = titleCategory
    }
}

extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSubCategory", for: indexPath) as! SubCategoryTableViewCell
        cell.cellTitleLabel.text = subCategory[indexPath.row].name
        
        if titleCategory == "Мужская" {
            cell.cellImage.loadImageUsingUrlStrting(urlString:
                                                        subCategory[indexPath.row].iconImage == "" ? "https://blackstarwear.ru/image/catalog/style/modile/icons-man-3.png"/*icon всех мужских категорий*/ : "https://blackstarwear.ru/\(subCategory[indexPath.row].iconImage)")
        } else if titleCategory == "Женская" {
            cell.cellImage.loadImageUsingUrlStrting(urlString:
                                                        subCategory[indexPath.row].iconImage == "" ? "https://blackstarwear.ru/image/catalog/style/modile/icons-women-3.png"/*icon всех женских категорий*/ : "https://blackstarwear.ru/\(subCategory[indexPath.row].iconImage)")
        } else {
            cell.cellImage.loadImageUsingUrlStrting(urlString:
                                                        subCategory[indexPath.row].iconImage == "" ? "https://blackstarwear.ru/image/catalog/style/modile/acc_cat.png"/*icon предпаказа*/ : "https://blackstarwear.ru/\(subCategory[indexPath.row].iconImage)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = subCategory[indexPath.row]
   
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let productVC = storyboard.instantiateViewController(identifier: "ProductViewController") as! ProductViewController
        guard let iddd = id.id else { return }
        productVC.idString = iddd.getStringValue()
        productVC.titileName = id.name
            navigationController?.pushViewController(productVC, animated: true)
    }
}
