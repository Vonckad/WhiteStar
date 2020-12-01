//
//  DetailProductViewController.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 11/16/20.
//

import UIKit

class DetailProductViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var mainScrollView: UIScrollView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var titleNameLabel: UILabel!
    @IBOutlet var aboutTextView: UITextView!
    @IBOutlet var sizeButton: UIButton!
    @IBOutlet var addToBasked: UIButton!
    @IBOutlet var photoScrollView: UIScrollView!
    @IBOutlet var photoPageControl: UIPageControl!
    @IBOutlet var basketBarButton: UIBarButtonItem!
    var frame = CGRect.zero

    let apiClientDetailProduct: ApiClient = ApiClientImpl()
    var detailPdoructImage: [ProductImages] = []
    var offersDetail: [Offers] = []
    
    var titileText: String = ""
    var aboutText: String = ""
    var size: String?
    var price = ""
    var colorN = ""
    var mySetImage = UIImageView()
    var isHide = false
    var imageData = Data()
    let grayView = UIView()
    var offersTableView = UITableView()
    
    override func viewDidLoad() {
      
        sizeButton.layer.cornerRadius = 10
        addToBasked.layer.cornerRadius = 10
        
        titleNameLabel.text = titileText
        aboutTextView.text = aboutText
        priceLabel.text = price
        photoPageControl.numberOfPages = detailPdoructImage.count
        basketBarButton.image = UIImage(named: "basket")
        
        setupScreens()
        
        photoScrollView.delegate = self
    }
    
    func setupScreens() {
        
        for index in 0..<detailPdoructImage.count {
        
        frame.origin.x = photoScrollView.frame.size.width * CGFloat(index)
        frame.size = photoScrollView.frame.size
            
        mySetImage = UIImageView(frame: frame)
            mySetImage.contentMode = .scaleAspectFit
            
            
            
        self.photoScrollView.addSubview(mySetImage)
        apiClientDetailProduct.getImage(link: detailPdoructImage[index].imageURL, imageV: mySetImage)
    }
        photoScrollView.contentSize = CGSize(width: photoScrollView.frame.size.width * CGFloat(detailPdoructImage.count), height: photoScrollView.frame.size.height)
        photoScrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = photoScrollView.contentOffset.x / photoScrollView.frame.size.width
        photoPageControl.currentPage = Int(pageNumber)
    }
   
    @IBAction func sizeButtonAction(_ sender: Any) {
            createDetailOffersVC()
    }
   
    @IBAction func barButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let basketVC = storyboard.instantiateViewController(identifier: "BasketViewController") as! BasketViewController
        navigationController?.pushViewController(basketVC, animated: true)
        
    }
    @IBAction func addToBasketButton(_ sender: Any) {
        
        if size == nil {
            createDetailOffersVC()
        } else if let mySize = size {
            showBasketViewController(size: mySize, name: titileText, price: price, colorName: colorN, imageData: imageData)
        }
    }
    func createDetailOffersVC() {
        
        grayView.frame = view.frame
        grayView.backgroundColor = .gray
        grayView.alpha = 0.5
        view.addSubview(grayView)
        
        offersTableView = UITableView(frame: CGRect(x: view.frame.minX, y: UIScreen.main.bounds.maxY, width: view.frame.width, height: /*CGFloat(offersDetail.count * 30)*/ view.frame.height / 3), style: .plain)
        offersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        offersTableView.delegate = self
        offersTableView.dataSource = self
        offersTableView.isScrollEnabled = false
        offersTableView.autoresizingMask = [.flexibleWidth]//, .flexibleHeight]
    
        view.addSubview(offersTableView)
        
        let tapGesturRecognazer = UITapGestureRecognizer(target: self, action: #selector(hendlerTap))
        grayView.addGestureRecognizer(tapGesturRecognazer)
        
        getAnimation()
    }
    
    //animation
    func getAnimation() {
        offersTableView.layer.removeAllAnimations()
        let newPoint = CGPoint(x: view.layer.position.x, y: UIScreen.main.bounds.maxY / 1.2)
        let showAnimationDetilOffersVC = CABasicAnimation(keyPath: "position")
        showAnimationDetilOffersVC.fromValue = offersTableView.layer.position
        showAnimationDetilOffersVC.toValue = newPoint
        showAnimationDetilOffersVC.duration = 0.15
        offersTableView.layer.add(showAnimationDetilOffersVC, forKey: nil)
        offersTableView.layer.position = newPoint
    }
    
    @objc func hendlerTap() {

        let newPoint = CGPoint(x: view.layer.position.x, y: UIScreen.main.bounds.maxY + offersTableView.frame.height / 2 )
        let showAnimationDetilOffersVC = CABasicAnimation(keyPath: "position")
        showAnimationDetilOffersVC.fromValue = offersTableView.layer.position
        showAnimationDetilOffersVC.toValue = newPoint
        showAnimationDetilOffersVC.duration = 0.15
        
        CATransaction.setCompletionBlock {
            
            for sub in self.view.subviews {
                if sub == self.grayView || sub == self.offersTableView {
                        sub.removeFromSuperview()
                }
            }
        }
        
        offersTableView.layer.position = newPoint
        offersTableView.layer.add(showAnimationDetilOffersVC, forKey: nil)
        CATransaction.commit()
        
     }
}

extension DetailProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offersDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = offersDetail[indexPath.row].size

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            size = offersDetail[indexPath.row].size
            
        if let sizeT = size {
//            showBasketViewController(size: ("\(titileText)\nразмер: \(sizeT)") )
            showBasketViewController(size: sizeT, name: titileText, price: price, colorName: colorN, imageData: imageData)
        }
    }
    
    func showBasketViewController(size: String, name: String, price: String, colorName: String, imageData: Data) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let basketVC = storyboard.instantiateViewController(identifier: "BasketViewController") as! BasketViewController
        basketVC.size = size
        basketVC.name = name
        basketVC.price = price
        basketVC.colorName = colorName
        basketVC.imageData = imageData
        navigationController?.pushViewController(basketVC, animated: true)
        hendlerTap()
    }    
}
