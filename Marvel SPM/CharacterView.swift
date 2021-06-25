import UIKit
import Kingfisher

class CharacterView: UIViewController {
    
    @IBOutlet weak var viewTitle: UINavigationItem!
    @IBOutlet weak var charThumb: UIImageView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var descTextHC: NSLayoutConstraint!
    
    var character: CharacterResult? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle.title = character?.name
        charThumb.kf.setImage(with: URL(string: goodURL(url: character?.thumbnail?.path, format: character?.thumbnail?.thumbExtension)))
        descText.text = character?.description
        descTextHC.constant = self.descText.contentSize.height + 20
    }
}
