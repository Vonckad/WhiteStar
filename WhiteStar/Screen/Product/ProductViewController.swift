//
//  ProductViewController.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 11/12/20.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var titleCollection: UINavigationItem!
    
    let apiClientProduct: ApiClient = ApiClientImpl()
    
    var product: [Product] = []
    
    var titileName: String = ""
    var idString: String = ""
    var oldPrice: String = ""

    var actView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actView = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 20, height: 20))
        actView.startAnimating()
        view.addSubview(actView)
        reloadData()
        titleCollection.title = titileName
    }
    
    func reloadData() {
        apiClientProduct.getProduct(id: idString, onResult: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    self.product = product
                    self.myCollectionView.reloadData()
                    self.actView.stopAnimating()
                    self.actView.isHidden = true
                case .failure:
                    self.actView.startAnimating()
                    self.actView.isHidden = false
                    self.product = []
                    self.myCollectionView.reloadData()
                }
            }
        })
    }
}

//MARK: - UICollectionViewDataSource

extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! ProductCollectionViewCell
        
        cell.myLabelOldPrice.text = product[indexPath.row].name
        cell.myLabelPrice.text = "\(formatedPrice(index: indexPath)) руб."
        cell.myImageView.loadImageUsingUrlStrting(urlString: "https://blackstarwear.ru/\(product[indexPath.row].mainImage)")        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (UIScreen.main.bounds.size.height - 30) / 3
        let width = (UIScreen.main.bounds.size.width - 10) / 2
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = product[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailProductViewController") as! DetailProductViewController
        
        detailVC.titileText = id.name
        detailVC.aboutText = id.description
        detailVC.price = formatedPrice(index: indexPath)
        detailVC.detailPdoructImage = id.productImages
        detailVC.colorN = id.colorName
        detailVC.idProduct = id.idProduct!
    
        DispatchQueue.global().async {
            detailVC.imageData = self.apiClientProduct.getImageData(link: id.mainImage)
        }

        detailVC.mainImageString = id.mainImage
        
        if let offers = id.offers {
            detailVC.offersDetail = offers
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func formatedPrice(index: IndexPath) -> String {
        var price = ""
        if let myPriceD = Double(product[index.row].price) {
            let myPriceInt = Int(myPriceD)
            price = String(myPriceInt)
        }
        return price
    }
}
