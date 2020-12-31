import UIKit
final class ViewController: UIViewController {
    
    @IBOutlet private weak var containerHomeView: UIView!
    @IBOutlet private weak var containerFavoriteView: UIView!
    @IBOutlet private weak var containerDietView: UIView!
    @IBOutlet private weak var containerIngredientView: UIView!
    
    @IBOutlet private weak var tabBarCollection: UICollectionView!
    
    private let idTabBarCell = "TabBarCell"
    private var widthOfTabBarCollection = CGFloat()
    private let heightOfTabBarCollection : CGFloat = 100.0
    
    private let tabBars : [TabBar] = [
        TabBar(
            iconTabbar: "home",
            nameTabbar: "Home"
        ),
        TabBar(
            iconTabbar: "favorite",
            nameTabbar: "Saved"
        ),
        TabBar(
            iconTabbar: "circular",
            nameTabbar: "Diet"
        ),
        TabBar(
            iconTabbar: "vegetarian",
            nameTabbar: "Items"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setDefaultView()
    }
    
    private func setDefaultView() {
        [ containerFavoriteView,
          containerDietView,
          containerIngredientView].forEach { $0?.isHidden = true }
    }
    
    private func configureTabBar() {
        widthOfTabBarCollection = (view.frame.width - 24) / 4
        tabBarCollection.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally)
        tabBarCollection.register( TabBarCell.self,
                                   forCellWithReuseIdentifier: idTabBarCell )
        tabBarCollection.collectionViewLayout.invalidateLayout()
    }
}

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
