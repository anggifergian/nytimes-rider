//
//  TopNewsTableViewCell.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 02/05/23.
//

import UIKit

protocol TopNewsTableViewCellDelegate: AnyObject {
    func topNewsTableViewCellPageControlValueChanged(_ cell: TopNewsTableViewCell)
}

class TopNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate: TopNewsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pageControlValueChanged(_ sender: Any) {
        delegate?.topNewsTableViewCellPageControlValueChanged(self)
    }
}
