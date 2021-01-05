import UIKit

final class WelcomeViewController: UIViewController {
    @IBOutlet private weak var iconLogo: UIImageView!
    @IBOutlet private weak var buttonStated: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configWelcomeView()
    }
    
    private func navigationMainView() {
        guard let mainVC = self.storyboard?.instantiateViewController(
                withIdentifier: IdStoryBoardViews.mainVC)
                as? ViewController else { return }
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    private func configWelcomeView() {
        iconLogo.cornerCircle()
        navigationController?.setNavigationBarHidden(true, animated: true)
        buttonStated.layer.cornerRadius = buttonStated.frame.height / 2
    }
    
    @IBAction private func goMainView(_ sender: Any) {
        UserDefaults.standard.set(true,
                                  forKey: KeyUserDefaults.keyCheckNewUser)
        navigationMainView()
    }
}
