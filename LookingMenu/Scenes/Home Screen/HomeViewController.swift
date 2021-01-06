import UIKit
final class HomeViewController: UIViewController {
    @IBOutlet private weak var logoApp: UIImageView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var randomRecipesCollection: UICollectionView!
    private var listRandomRecipes = [Recipe]()
    private var sizeItemCollection = (width: CGFloat(),
                                      height: CGFloat())
    private let idRandomRecipesCell = "RecipeHomeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHomeView()
    }
    
    private func configHomeView() {
        logoApp.cornerCircle()
        randomRecipesCollection.register(RecipeRandomCell.self,
                                         forCellWithReuseIdentifier: idRandomRecipesCell)
        randomRecipesCollection.collectionViewLayout.invalidateLayout()
        APIRecipe.apiRecipe.getRandomRecipe(offset: 5) { [unowned self] recipes in
            DispatchQueue.main.async {
                self.listRandomRecipes = recipes.recipes
                self.randomRecipesCollection.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sizeItemCollection.height = randomRecipesCollection.frame.height
        sizeItemCollection.width = randomRecipesCollection.frame.width / 1.5
    }
}

extension HomeViewController : UICollectionViewDelegate,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return listRandomRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sizeItemCollection.width,
                      height: sizeItemCollection.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(
                withIdentifier: IdStoryBoardViews.detailRecipe)
                as? DetailRecipeController
        else { return }
        let item = listRandomRecipes[indexPath.row]
        detailVC.recipe = item
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = randomRecipesCollection.dequeueReusableCell(
                withReuseIdentifier: idRandomRecipesCell,
                for: indexPath) as? RecipeRandomCell
        else { return UICollectionViewCell() }
        let item = listRandomRecipes[indexPath.row]
        cell.configItemRecipeRandom(item : item)
        return cell
    }
}

extension HomeViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchVC = storyboard?.instantiateViewController(
                withIdentifier: IdStoryBoardViews.search) as? SearchViewController,
              let textSearch = searchBar.text
        else { return }
        searchVC.keyWord = textSearch
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
