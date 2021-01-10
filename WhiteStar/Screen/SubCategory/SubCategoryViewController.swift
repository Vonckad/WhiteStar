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
    let apiClient: ApiClient = ApiClientImpl()
    private let saveImage = SaveSubCategoryImageController()
    
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
        
        saveImage.load(link: subCategory[indexPath.row].iconImage)
        
        cell.cellTitleLabel.text = subCategory[indexPath.row].name
        cell.cellImage.image = UIImage(data: saveImage.imageDataRealm[indexPath.row].imageData)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = subCategory[indexPath.row]
   
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let productVC = storyboard.instantiateViewController(identifier: "ProductViewController") as! ProductViewController
        productVC.idString = id.id.getStringValue()
        productVC.titileName = id.name
            navigationController?.pushViewController(productVC, animated: true)
    }
}
