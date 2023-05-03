//
//  Media.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 30/04/23.
//

import Foundation

struct Media: Decodable {
    let type: String
    let caption: String
    let metaData: [MediaMetaData]
    
    enum CodingKeys: String, CodingKey {
        case type
        case caption
        case metadata = "media-metadata"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        caption = try container.decodeIfPresent(String.self, forKey: .caption) ?? ""
        metaData = try container.decodeIfPresent([MediaMetaData].self, forKey: .metadata) ?? []
    }
    
    init(type: String, caption: String, metaData: [MediaMetaData]) {
        self.type = type
        self.caption = caption
        self.metaData = metaData
    }
}
