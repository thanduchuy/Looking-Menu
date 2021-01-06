import UIKit

private enum ConstantSearchView {
    static let radiusView: CGFloat = 20
    static let constantAnchor: CGFloat = 4
}

final class SearchViewController: UIViewController {
    @IBOutlet private weak var labelKeyWordSearch: UILabel!
    @IBOutlet private weak var slideView: UIView!
    @IBOutlet private weak var viewRecipeNotFound: UIStackView!
    @IBOutlet private weak var labelTotalResult: UILabel!
    @IBOutlet private weak var resultSearchCollection: UICollectionView!
    @IBOutlet private weak var constrantBottomSlideView: NSLayoutConstraint!
    let idResultSearchCell = "ResultSearchCell"
    var keyWord : String = ""
    var listResultSearch = [Recipe]()
    var sizeSeachCellCollection = (width: CGFloat(),
                                   height: CGFloat())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSearchView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sizeSeachCellCollection.height = view.frame.height / 3
        sizeSeachCellCollection.width = view.frame.width / 2.5
    }
    
    private func configSearchView() {
        APIRecipe.apiRecipe.searchRecipeByName(query: keyWord) { [unowned self] result in
            DispatchQueue.main.async {
                self.listResultSearch = result.results
                self.labelTotalResult.text = "Found \(result.totalResults) results"
                self.viewRecipeNotFound.isHidden = result.totalResults != 0
                self.resultSearchCollection.isHidden = result.totalResults == 0
                self.resultSearchCollection.reloadData()
                self.finishSearchingRecipe()
            }
        }
        setUpCollectionViewItemLayout()
        labelKeyWordSearch.text = keyWord
        slideView.layer.cornerRadius = ConstantSearchView.radiusView
    }
    
    private func setUpCollectionViewItemLayout() {
        let customLayout = CustomSearchCollectionViewLayout()
        customLayout.delegate = self
        resultSearchCollection.register(ResultSearchCell.self,
                                        forCellWithReuseIdentifier: idResultSearchCell)
        resultSearchCollection.collectionViewLayout = customLayout
    }
    
    func finishSearchingRecipe() {
        constrantBottomSlideView.constant = ConstantSearchView.constantAnchor
        UIView.animate(withDuration: 1.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction private func goBackHomeView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController : UICollectionViewDelegate,
                                 UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return listResultSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = resultSearchCollection.dequeueReusableCell(withReuseIdentifier: idResultSearchCell, for: indexPath)
                as? ResultSearchCell else { return UICollectionViewCell() }
        cell.configSearchCell(item: listResultSearch[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: IdStoryBoardViews.detailRecipe)
                as? DetailRecipeController else { return }
        detailVC.recipe = listResultSearch[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: CustomSearchDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        sizeRecipeItem indexPath: IndexPath) -> CGSize {
        return CGSize(width: sizeSeachCellCollection.width,
                      height: sizeSeachCellCollection.height)
    }
}

