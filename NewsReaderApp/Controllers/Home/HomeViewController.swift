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
    weak var pageControl: UIPageControl?
    weak var topNewsCollectionView: UICollectionView?
    
    var latestNewsList: [News] = []
    var topNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTable.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "custom_news_cell")
        homeTable.dataSource = self
        homeTable.delegate = self
        
        let refreshControl = UIRefreshControl()
        homeTable.refreshControl = refreshControl
        self.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(readingListDeleted(_:)), name: .deleteReadingList, object: nil)
        
        loadLatestNews()
        loadTopNews()
    }
    
    @objc func readingListDeleted(_ sender: Any) {
        homeTable.reloadData()
    }
    
    @objc func handleRefresh() {
        loadLatestNews()
        loadTopNews()
    }
    
    // MARK: - Helpers
    func loadLatestNews() {
        NewsService.shared.fetchLatestNews { [weak self] result in
            guard let strongSelf = self else { return }
            
            strongSelf.refreshControl.endRefreshing()
            
            switch result {
            case .success(let data):
                strongSelf.latestNewsList = data
                strongSelf.homeTable.reloadData()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func loadTopNews() {
        NewsService.shared.fetchTopNews { [weak self] result in
            guard let strongSelf = self else { return }
            
            strongSelf.refreshControl.endRefreshing()
            switch result {
            case .success(let data):
                strongSelf.topNewsList = data
                strongSelf.homeTable.reloadData()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topNewsList.count > 0 ? 1 : 0
        }
        
        return latestNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = homeTable.dequeueReusableCell(withIdentifier: "top_news_list_cell", for: indexPath) as! TopNewsTableViewCell
            
            cell.headingLabel.text = "News for You"
            cell.subtitleLabel.text = "Top \(topNewsList.count) News of the day"
            cell.pageControl.numberOfPages = topNewsList.count
            self.pageControl = cell.pageControl
            
            self.topNewsCollectionView = cell.collectionView
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            
            cell.delegate = self
            
            return cell
        }
        
        let cell = homeTable.dequeueReusableCell(withIdentifier: "custom_news_cell", for: indexPath) as! NewsTableViewCell
        
        let news = latestNewsList[indexPath.row]
        cell.titleLabel.text = news.title
        cell.dateLabel.text = "\(news.section) • \(news.publishDate)"
        
        if CoreDataStorage.shared.isAddedToReadingList(newsId: news.id) {
            if #available(iOS 13.0, *) {
                cell.boomarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            cell.boomarkButton.isEnabled = false
        } else {
            if #available(iOS 13.0, *) {
                cell.boomarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            cell.boomarkButton.isEnabled = true
        }
        
        cell.delegate = self
        
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
        guard indexPath.section == 1 else { return }
        
        let news = latestNewsList[indexPath.row]
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        homeTable.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NewsTableViewCellDelegate
extension HomeViewController: NewsTableViewCellDelegate {
    func newsTableViewCellBookmarkButtonTapped(_ cell: NewsTableViewCell) {
        if let indexPath = homeTable.indexPath(for: cell) {
            let news = latestNewsList[indexPath.row]
            CoreDataStorage.shared.addReadingList(news: news)
            
            if #available(iOS 13.0, *) {
                cell.boomarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            cell.boomarkButton.isEnabled = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_collection_cell", for: indexPath) as! TopNewsCollectionViewCell
        
        let news = topNewsList[indexPath.row]
        
        if let urlString = news.media.first?.metaData.last?.url {
            cell.thumbImageView.sd_setImage(with: URL(string: urlString))
        } else {
            cell.thumbImageView.image = nil
        }
        
        cell.titleLabel.text = news.title
        cell.subtitleLabel.text = "\(news.section) • \(news.publishDate)"
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 256)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.homeTable {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl?.currentPage = page
        }
    }
}

// MARK: - TopNewsTableViewCellDelegate
extension HomeViewController: TopNewsTableViewCellDelegate {
    func topNewsTableViewCellPageControlValueChanged(_ cell: TopNewsTableViewCell) {
        let page = cell.pageControl.currentPage
        topNewsCollectionView?.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
    }
}
