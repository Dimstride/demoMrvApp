import UIKit
import Kingfisher

class SeriesCell: UICollectionViewCell {
    
    @IBOutlet weak var serieThumb: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSeries(data: SeriesResult) {
        setImage(comicImage: self.serieThumb, data: data)
    }
    
    private func setImage(comicImage: UIImageView, data: SeriesResult) {
        self.serieThumb.layer.cornerRadius = 5
        self.serieThumb.kf.setImage(with: URL(string: goodURL(url: data.thumbnail?.path, format: data.thumbnail?.thumbnailExtension)))
    }
}
