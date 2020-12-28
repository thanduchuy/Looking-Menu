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

