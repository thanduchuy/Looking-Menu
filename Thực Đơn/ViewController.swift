    //
    //  ViewController.swift
    //  Thực Đơn
    //
    //  Created by Huy Than Duc on 25/12/2020.
    //
    
    import UIKit
    
    class ViewController: UIViewController {
        
        @IBOutlet weak var homeView: UIView!
        @IBOutlet weak var FavoriteView: UIView!
        @IBOutlet weak var DietView: UIView!
        @IBOutlet weak var Ingredient: UIView!
        @IBOutlet weak var TabBarCollection: UICollectionView!
        override func viewDidLoad() {
            super.viewDidLoad()
            configureTabBar()
            defaultView()
        }
        func defaultView() {
            [FavoriteView,DietView,Ingredient].forEach { $0?.isHidden = true }
        }
        func configureTabBar() {
            TabBarCollection.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            TabBarCollection.register(TabBarCell.self, forCellWithReuseIdentifier: Instance.idTabBarCell)
            TabBarCollection.collectionViewLayout.invalidateLayout()
        }
    }
    
    extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return Instance.tabBars.count
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (self.view.frame.width-24)/4, height: 100)
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let item = Instance.tabBars[indexPath.row]
            let cell = TabBarCollection.dequeueReusableCell(withReuseIdentifier: Instance.idTabBarCell, for: indexPath) as! TabBarCell
            if let image = UIImage(named: item.icon) {
                cell.icon.image = image.withRenderingMode(.alwaysTemplate)
                cell.label.text = item.label
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let arr = [homeView,FavoriteView,DietView,Ingredient]
            for index in 0..<arr.count {
                arr[index]?.isHidden = !(index == indexPath.item)
            }
        }
        
    }
