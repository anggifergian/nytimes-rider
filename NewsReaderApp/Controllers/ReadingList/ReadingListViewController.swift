//
//  ReadingListViewController.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 02/05/23.
//

import UIKit
import SafariServices

class ReadingListViewController: UIViewController {

    @IBOutlet weak var readingListTable: UITableView!
    
    var readingList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readingListTable.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "custom_news_cell")
        readingListTable.delegate = self
        readingListTable.dataSource = self
        
        loadReadingList()
    }
    
    func loadReadingList() {
        readingList = CoreDataStorage.shared.getReadingList()
    }
}

// MARK: - UITableViewDelegate
extension ReadingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = readingList[indexPath.row]
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        readingListTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            
            let news = self.readingList.remove(at: indexPath.row)
            self.readingListTable.deleteRows(at: [indexPath], with: .automatic)
            
            CoreDataStorage.shared.deleteReadingList(newsId: news.id)
            
            completion(true)
        }
        
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        }
        
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ReadingListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = readingListTable.dequeueReusableCell(withIdentifier: "custom_news_cell", for: indexPath) as! NewsTableViewCell
        let news = readingList[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.dateLabel.text = "\(news.section) • \(news.publishDate)"
        cell.boomarkButton.isHidden = true
        
        if let url = news.media.first?.metaData.last?.url {
            cell.thumbImageView.sd_setImage(with: URL(string: url))
        } else {
            cell.thumbImageView.image = nil
        }
        
        return cell
    }
    
    
}
