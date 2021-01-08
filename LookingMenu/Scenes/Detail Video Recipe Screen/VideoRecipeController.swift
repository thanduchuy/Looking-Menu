import UIKit
import WebKit
final class VideoRecipeController: UIViewController {
    @IBOutlet private weak var nameRecipeLabel: UILabel!
    @IBOutlet private weak var videoEmbedYoutubeWebView: WKWebView!
    @IBOutlet private weak var titleVideoLabel: UILabel!
    @IBOutlet private weak var ratingVideoLabel: UILabel!
    @IBOutlet private weak var viewVideoLabel: UILabel!
    @IBOutlet private weak var lengthVideoLabel: UILabel!
    var recipeFromDetail : Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVideoDetailView()
    }
    
    func setDataDescriptionVideo(video: Video) {
        labelTitleVideo.text = video.shortTitle
        labelRatingVideo.text = "\(video.rating)"
        labelViewVideo.text = "\(video.views)"
        labelLengthVideo.text = "\(convertSecondToMinute(totalVideoDuration: video.length))"
    }
    
    private func convertSecondToMinute(totalVideoDuration: Int) -> String {
        return String(format:"%02d:%02d",
                      totalVideoDuration / 60,
                      totalVideoDuration % 60);
    }
    
    private func configVideoDetailView() {
        guard let recipe = recipeFromDetail else { return }
        let query = recipe.title.components(separatedBy: " ")
        labelNameRecipe.text = recipe.title
        APIRecipe.apiRecipe.searchVideoByName(query: query[0]) { [unowned self] result in
            guard let video = result.videos.first else { return }
            DispatchQueue.main.async {
                self.loadVideoEmbedYoutube(id: video.youTubeId)
                self.setDataDescriptionVideo(video: video)
            }
        }
    }
    
    func loadVideoEmbedYoutube(id: String) {
        guard let myUrl = URL(string:
                                String(format: UrlAPIRecipe.urlEmbebYoutube, id))
        else { return }
        let request = URLRequest(url: myUrl)
        videoEmbedYoutube.load(request)
    }
    
    @IBAction private func goBackDetailRecipe(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
