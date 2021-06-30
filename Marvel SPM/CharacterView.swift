import UIKit
import Kingfisher

class CharacterView: UIViewController {
    
    @IBOutlet weak var viewTitle: UINavigationItem!
    @IBOutlet weak var charThumb: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var comicsCollection: UICollectionView!
    @IBOutlet weak var seriesCollection: UICollectionView!
    @IBOutlet weak var eventsCollection: UICollectionView!
    @IBOutlet weak var providerLabel: UILabel!
    
    var comicsCell: MCell = MCell(xibName: "ComicsCell", idReuse: "ComicsCell")
    var seriesCell: MCell = MCell(xibName: "SeriesCell", idReuse: "SeriesCell")
    var eventsCell: MCell = MCell(xibName: "EventsCell", idReuse: "EventsCell")
    
    var offset: Int = 0
    
    var provider: String? = nil
    var character: CharacterResult? = nil
    var comics: [ComicsResult] = []
    var series: [SeriesResult] = []
    var events: [EventsResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle.title = character?.name
        providerLabel.text = provider
        
        charThumb.kf.setImage(with: URL(string: goodURL(url: character?.thumbnail?.path, format: character?.thumbnail?.thumbExtension)))
        
        if character?.description != nil {
            if character!.description!.count <= 1 { descriptionLabel.text = "Not description provided"
            } else { descriptionLabel.text = character!.description }
        } else { descriptionLabel.text = "Not description provided" }
        
        self.comicsCollection?.register(UINib(nibName: comicsCell.xibName, bundle: nil), forCellWithReuseIdentifier: comicsCell.idReuse)
        self.comicsCollection.dataSource = self
        self.comicsCollection.delegate = self
        
        self.seriesCollection?.register(UINib(nibName: seriesCell.xibName, bundle: nil), forCellWithReuseIdentifier: seriesCell.idReuse)
        self.seriesCollection.dataSource = self
        self.seriesCollection.delegate = self
        
        
        self.eventsCollection?.register(UINib(nibName: eventsCell.xibName, bundle: nil), forCellWithReuseIdentifier: eventsCell.idReuse)
        self.eventsCollection.dataSource = self
        self.eventsCollection.delegate = self
        
        mainSetup()
    }
    
    private func mainSetup() {
        guard let securedId = character?.id else { return }
        print(securedId)
        CharacterClient().getComics(offset: offset, charId: securedId) { result in
            switch result {
            case .success(let comics):
                guard let securedResults = comics.data?.results else { return }
                self.comics.append(contentsOf: securedResults)
                print("Comics count \(self.comics.count)")
                self.comicsCollection.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        CharacterClient().getSeries(offset: offset, charId: securedId) { result in
            switch result {
            case .success(let series):
                guard let securedResults = series.data?.results else { return }
                self.series.append(contentsOf: securedResults)
                print("Series count \(self.series.count)")
                self.seriesCollection.reloadData()
            case .failure(let error):
                print(error)
            }
        }

        CharacterClient().getEvents(offset: offset, charId: securedId) { result in
            switch result {
            case .success(let events):
                guard let securedResults = events.data?.results else { return }
                self.events.append(contentsOf: securedResults)
                print("Events count \(self.events.count)")
                self.eventsCollection.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UICOLLECTIONVIEWEXT
extension CharacterView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.comicsCollection { return comics.count } else
        if collectionView == self.seriesCollection { return series.count } else
        if collectionView == self.eventsCollection { return events.count }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.comicsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: comicsCell.idReuse, for: indexPath) as! ComicsCell
            cell.setComics(data: comics[indexPath.row])
            return cell
        } else
        if collectionView == self.seriesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: seriesCell.idReuse, for: indexPath) as! SeriesCell
            cell.setSeries(data: series[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventsCell.idReuse, for: indexPath) as! EventsCell
            cell.setEvents(data: events[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultSize = CGSize(width: collectionView.frame.height/1.5, height: collectionView.frame.height)
        if collectionView == self.comicsCollection { return defaultSize } else
        if collectionView == self.seriesCollection { return defaultSize } else
        if collectionView == self.eventsCollection { return defaultSize }
        return defaultSize
    }
}
