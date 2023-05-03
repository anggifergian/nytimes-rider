//
//  NewsTableViewCell.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 02/05/23.
//

import UIKit

protocol NewsTableViewCellDelegate: AnyObject {
    func newsTableViewCellBookmarkButtonTapped(_ cell: NewsTableViewCell)
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var boomarkButton: UIButton!
    
    weak var delegate: NewsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup() {
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.layer.masksToBounds = true
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        delegate?.newsTableViewCellBookmarkButtonTapped(self)
    }
}
