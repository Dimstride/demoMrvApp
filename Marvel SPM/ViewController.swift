import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var heroTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var misCells: MCell = MCell(xibName: "HeroeCell", idReuse: "HeroeCell")
    var loadingCell: MCell = MCell(xibName: "LoadingCell", idReuse: "LoadingCell")
    var heroes: [CharacterResult] = []
    var isLoading = false
    var offset = 0
    var clickedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heroTable?.register(UINib(nibName: misCells.xibName, bundle: nil), forCellReuseIdentifier: misCells.idReuse)
        self.heroTable?.register(UINib(nibName: loadingCell.xibName, bundle: nil), forCellReuseIdentifier: loadingCell.idReuse)
        self.heroTable.delegate = self
        self.heroTable.dataSource = self
        activityIndicator.hidesWhenStopped = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CharacterView") {
            let viewController = segue.destination as? CharacterView
            viewController!.character = self.heroes[clickedRow]
        }
    }
}

// MARK: - PRIVATE METHODS
private extension ViewController {
    
    private func networkSetup() {
        //self.activityIndicator.startAnimating()
        NetworkClient().getCharacters(offset: offset) { result in
            switch result {
            case .success(let characters):
                guard let securedResults = characters.data?.results else { return }
                self.offset += securedResults.count
                self.heroes.append(contentsOf: securedResults)
                print(self.heroes.count)
                self.heroTable.reloadData()
                self.isLoading = false
            case .failure(let error):
                self.errorAlert(errorType: error.errorDescription ?? "")
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func errorAlert(errorType: String){
        let myalert = UIAlertController(title: "Something happened", message: errorType, preferredStyle: UIAlertController.Style.alert)
        myalert.addAction(UIAlertAction(title: "Try again", style: .default) { (action:UIAlertAction!) in
            print("Trying again")
            self.networkSetup()
        })
        myalert.addAction(UIAlertAction(title: "Close app", style: .cancel) { (action:UIAlertAction!) in
            print("Terminated")
            exit(0)
        })
        self.present(myalert, animated: true)
    }
    
    private func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            networkSetup()
        }
    }
}

// MARK: - UITABLEVIEWDATASOURCE
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return heroes.count }
        else if section == 1 { return 1 } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: misCells.idReuse, for: indexPath) as! HeroeCell
            cell.setHeroe(data: heroes[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: loadingCell.idReuse, for: indexPath) as! LoadingCell
            cell.loadingView.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return UIScreen.main.bounds.height / 9 }
        else { return UIScreen.main.bounds.height / 12 }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: misCells.idReuse, for: indexPath) as! HeroeCell
        cell.heroImage.kf.cancelDownloadTask()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

//MARK: - UISCROLLVIEWDELEGATE

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) && !isLoading {
            loadMoreData()
        }
    }
}

// MARK: - UITABLEVIEWDELEGATE
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedRow = indexPath.row
        performSegue(withIdentifier: "CharacterView", sender: self)
    }
}
