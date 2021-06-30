import UIKit
import Kingfisher

class ComicsCell: UICollectionViewCell {
    
    @IBOutlet weak var comicThumb: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setComics(data: ComicsResult) {
        setImage(comicImage: self.comicThumb, data: data)
    }
    
    private func setImage(comicImage: UIImageView, data: ComicsResult) {
        self.comicThumb.layer.cornerRadius = 5
        self.comicThumb.kf.setImage(with: URL(string: goodURL(url: data.thumbnail?.path, format: data.thumbnail?.thumbnailExtension)))
        //print(URL(string: goodURL(url: data.thumbnail?.path, format: data.thumbnail?.thumbnailExtension)) ?? "")
    }
}
