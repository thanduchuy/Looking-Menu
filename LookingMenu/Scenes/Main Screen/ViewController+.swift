import Foundation
import UIKit

extension ViewController : UICollectionViewDelegate,
                           UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBars.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: widthOfTabBarCollection,
            height : heightOfTabBarCollection)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tabBars[indexPath.row]
        let cell = tabBarCollection.dequeueReusableCell(
            withReuseIdentifier: idTabBarCell,
            for: indexPath) as? TabBarCell
        guard let myCell = cell else { return UICollectionViewCell() }
        myCell.configCell(item: item)
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let arr = [ containerHomeView,
                    containerFavoriteView,
                    containerDietView,
                    containerIngredientView]
        for index in 0..<arr.count {
            arr[index]?.isHidden = !(index == indexPath.item)
        }
    }
}

