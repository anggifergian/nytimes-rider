//
//  HomeViewController.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 02/05/23.
//

import UIKit
import SDWebImage
import SafariServices

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTable: UITableView!
    
    weak var refreshControl: UIRefreshControl!
    
    var newsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTable.dataSource = self
        homeTable.delegate = self
        
        let refreshControl = UIRefreshControl()
        homeTable.refreshControl = refreshControl
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.beginRefreshing()
        
        fetchData()
    }
    
    @objc func handleRefresh() {
        fetchData()
    }
    
    // MARK: - Helpers
    func fetchData() {
        NewsService.shared.fetchLatestNews { result in
            self.refreshControl.endRefreshing()
            
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
        let cell = homeTable.dequeueReusableCell(withIdentifier: "custom_news_cell", for: indexPath) as! NewsTableViewCell
        
        let news = newsList[indexPath.row]
        cell.titleLabel.text = news.title
        cell.dateLabel.text = "\(news.section) • \(news.publishDate)"
        
        if let url = news.media.first?.metaData.last?.url {
            /**
             [1] Alamofire
             NewsService.shared.downloadImage(url: url) { result in
                 switch result {
                 case .success(let image):
                     cell.thumbImageView.image = image
                 case .failure(let err):
                     print(err.localizedDescription)
                 }
             }
             */
            
            // [2] SDWebImage
            cell.thumbImageView.sd_setImage(with: URL(string: url))
        } else {
            cell.thumbImageView.image = nil
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        homeTable.deselectRow(at: indexPath, animated: true)
    }
}
