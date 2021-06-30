import UIKit
import Kingfisher

class EventsCell: UICollectionViewCell {
    
    @IBOutlet weak var eventThumb: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEvents(data: EventsResult) {
        setImage(comicImage: self.eventThumb, data: data)
    }
    
    private func setImage(comicImage: UIImageView, data: EventsResult) {
        self.eventThumb.layer.cornerRadius = 5
        self.eventThumb.kf.setImage(with: URL(string: goodURL(url: data.thumbnail?.path, format: data.thumbnail?.thumbnailExtension)))
        //print(URL(string: goodURL(url: data.thumbnail?.path, format: data.thumbnail?.thumbnailExtension)) ?? "")
    }
}
