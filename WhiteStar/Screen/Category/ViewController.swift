//
//  ViewController.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 10/19/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var categoriTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!

    var category: [Category] = []
    var subCategory: [CategoryArray] = []
    let apiClient: ApiClient = ApiClientImpl()
    var actView = UIActivityIndicatorView()
    var isChooseCategory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        actView = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 20, height: 20))
        actView.startAnimating()
        view.addSubview(actView)
        reloadData()
        backButton.isEnabled = false
    }

    func reloadData() {
        apiClient.getCategory(onResult: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let category):
                    self.category = category
                    self.categoriTableView.reloadData()
                    self.actView.stopAnimating()
                    self.actView.isHidden = true
                case .failure:
                    self.actView.startAnimating()
                    self.actView.isHidden = false
                    self.category = []
                    self.categoriTableView.reloadData()
                }
            }
        })
    }
    
    func reloadTable() {
        isChooseCategory = false
        backButton.isEnabled = false
        navigationItem.title = "Категории"
        categoriTableView.reloadData()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        reloadTable()
    }
}

//MARK:- extension

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isChooseCategory ? subCategory.count : category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = categoriTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        cell.cellTitleLabel.text = isChooseCategory ? subCategory[indexPath.row].name : category[indexPath.row].name
        
        if isChooseCategory {
            cell.cellImage.loadImageUsingUrlStrting(urlString: subCategory[indexPath.row].iconImage == "" ? "https://blackstarwear.ru/image/catalog/style/modile/icons-man-3.png"/*icon всех мужских категорий*/ : "https://blackstarwear.ru/\(subCategory[indexPath.row].iconImage)")
        } else {
            cell.cellImage.loadImageUsingUrlStrting(urlString: category[indexPath.row].iconImage == "" ? "https://blackstarwear.ru/image/170829newmob.png" : "https://blackstarwear.ru/\(category[indexPath.row].iconImage)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let productVC = storyboard.instantiateViewController(identifier: "ProductViewController") as! ProductViewController
        
        if isChooseCategory {
            productVC.idString = (subCategory[indexPath.row].id?.getStringValue())!
            productVC.titileName = subCategory[indexPath.row].name
            navigationController?.pushViewController(productVC, animated: true)
            
        } else {
            isChooseCategory = true
            backButton.isEnabled = true
            subCategory = category[indexPath.row].subcategories!
            navigationItem.title = category[indexPath.row].name
            
            if subCategory.count == 0 {
                reloadTable()
                productVC.idString = category[indexPath.row].idCategory!
                productVC.titileName = category[indexPath.row].name
                navigationController?.pushViewController(productVC, animated: true)
            }
            tableView.reloadData()
        }
    }
    //Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = CATransform3DTranslate(CATransform3DIdentity, 20, 0, 0)
        cell.layer.transform = animation
        cell.alpha = 0.33
        UIView.animate(withDuration: 0.33) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
