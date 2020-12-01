//
//  ViewController.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 10/19/20.
//

import UIKit
//import RealmSwift

class ViewController: UIViewController {

    @IBOutlet var categoriTableView: UITableView!
    
    var category: [Category] = []
    let apiClient: ApiClient = ApiClientImpl()
    var actView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        actView = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 20, height: 20))
        actView.startAnimating()
        view.addSubview(actView)
        reloadData()
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
    
}

//MARK:- extension

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = categoriTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let categ = category[indexPath.row]
   
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let detailVC = storyboard.instantiateViewController(identifier: "SubCategoryViewController") as! SubCategoryViewController
        detailVC.subCategory = categ.subcategories!
        detailVC.titleCategory = categ.name
            navigationController?.pushViewController(detailVC, animated: true)
    }
}
