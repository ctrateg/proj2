import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(alert))
        
        let urlString: String = urlName()
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There a was problem loading the feed: pls check u'r connection and try again", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func alert(){
        let urlString: String = urlName()
        
        let ac = UIAlertController(title: "Info", message: "\(urlString)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title:"Ok", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    func urlName() -> String {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        return urlString
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return petitions.count
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        cell.selectedBackgroundView?.backgroundColor = .brown
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

