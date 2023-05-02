//
//  HomeViewController.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 02/05/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTable: UITableView!
    
    var newsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTable.dataSource = self
        homeTable.delegate = self
        
        fetchData()
    }
    
    // MARK: - Helpers
    func fetchData() {
        NewsService.shared.fetchLatestNews { result in
            switch result {
            case .success(let data):
                self.newsList = data
                self.homeTable.reloadData()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTable.dequeueReusableCell(withIdentifier: "home_cell", for: indexPath)
        
        let news = newsList[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row) - \(news.title)"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        
        let alert = UIAlertController(title: news.title, message: news.section, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true) {
            
        }
    }
}