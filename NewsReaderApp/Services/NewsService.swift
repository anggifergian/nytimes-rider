//
//  ApiService.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 01/05/23.
//

import Foundation
import Alamofire

class NewsService {
    
    private let BASE_URL = "https://api.nytimes.com/svc/mostpopular/v2"
    private let API_KEY = "poqAplnIabq4G81jyrGocLrIAYgT8W61"
    
    static let shared: NewsService = NewsService()
    
    private init() {}
    
    func fetchLatestNews(completion: @escaping (Result<[News], Error>) -> Void) {
        let urlString = "\(BASE_URL)/viewed/7.json"
        
        AF.request(urlString, method: HTTPMethod.get, parameters: ["api-key": API_KEY])
            .validate()
            .responseDecodable(of: NewsResponse.self) { response in
                switch response.result {
                case .success(let newsResponse):
                    completion(.success(newsResponse.results))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }
    
    func downloadImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let image = UIImage(data: data)
                    completion(.success(image))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }
    
    func fetchNews(completion: @escaping (Result<[News], Error>) -> Void) {
        let urlString = "\(BASE_URL)/viewed/7.json?api-key=\(API_KEY)"
        guard let url = URL(string: urlString) else { return }

        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            do {
                let result = try JSONDecoder().decode(NewsResponse.self, from: data!)
                completion(.success(result.results))
            } catch let err {
                completion(.failure(err))
            }
        }
        
        task.resume()
    }
}
