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
        
        readingListTable.delegate = self
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
            print("IndexPath... \(indexPath.row)")
            
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
