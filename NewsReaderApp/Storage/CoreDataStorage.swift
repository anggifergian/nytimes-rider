//
//  CoreDataStorage.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 02/05/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataStorage {
    static let shared: CoreDataStorage = CoreDataStorage()
    
    private init() {
        printCoreDataDBPath()
    }
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.viewContext
    }()
    
    func addReadingList(news: News) {
        var newsData: NewsData
        
        let fetchRequest = NewsData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "newsId = \(news.id)")
        
        if let data = try? context.fetch(fetchRequest).first {
            newsData = data
        } else {
            newsData = NewsData(context: context)
        }
        
        newsData.newsId = Int64(news.id)
        newsData.title = news.title
        newsData.url = news.url
        newsData.section = news.section
        newsData.publishDate = news.publishDate
        newsData.mediaUrl = news.media.first?.metaData.last?.url
        newsData.addedAt = Date()
        
        NotificationCenter.default.post(name: .addReadingList, object: nil)
        
        try? context.save()
    }
    
    func getReadingList() -> [News] {
        let fetchRequest = NewsData.fetchRequest()
        let datas = (try? context.fetch(fetchRequest)) ?? []
        
        let sortedDatas = datas.sorted { news0, news1 in
            if let date0 = news0.addedAt, let date1 = news1.addedAt {
                return date0 < date1
            }
            
            return false
        }
        
        let newsList = sortedDatas.compactMap { newsData in
            return newsData.dto
        }
        return newsList
    }
    
    func deleteReadingList(newsId: Int) {
        let fetchRequest = NewsData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "newsId = \(newsId)")
        if let data = try? context.fetch(fetchRequest).first {
            context.delete(data)
            
            NotificationCenter.default.post(name: .deleteReadingList, object: nil)
            
            try? context.save()
        }
    }
    
    func isAddedToReadingList(newsId: Int) -> Bool {
        let fetchRequest = NewsData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "newsId = \(newsId)")
        
        if (try? context.fetch(fetchRequest).first) != nil {
            return true
        }
        return false
    }
    
    func printCoreDataDBPath() {
        let path = FileManager
                .default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .last?
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding
        
        print("Core Data DB Path :: \(path ?? "Not found")")
    }
}

// MARK: - NewsData
extension NewsData {
    var dto: News {
        let news = News(
            url: self.url ?? "",
            id: Int(self.newsId),
            publishDate: self.publishDate ?? "",
            section: self.section ?? "",
            title: self.title ?? "",
            mediaUrl: self.mediaUrl ?? ""
        )
        
        return news
    }
}
