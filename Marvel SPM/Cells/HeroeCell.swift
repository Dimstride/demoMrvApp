import UIKit
import Kingfisher

class HeroeCell: UITableViewCell {
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var miscText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        heroImage.image = nil
//    }
    
    func setHeroe(data: CharacterResult) {
        setImage(heroImage: self.heroImage, data: data)
        nameText.text = data.name
        
        if data.description != nil {
            if data.description!.count <= 1 { miscText.text = "Not description provided"
            } else { miscText.text = data.description }
        } else { miscText.text = "Not description provided" }
    }
    
    private func setImage(heroImage: UIImageView, data: CharacterResult) {
        self.heroImage.layer.cornerRadius = 10
        self.heroImage.kf.setImage(with: URL(string: goodURL(url: data.thumbnail?.path, format: data.thumbnail?.thumbExtension)))
        //print(goodURL(url: data.thumbnail?.path, format: data.thumbnail?.thumbExtension))
    }
}
