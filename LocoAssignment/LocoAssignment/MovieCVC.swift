//
//  MovieCVC.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 23/06/24.
//

import UIKit

class MovieCVC: UICollectionViewCell {
    static let cellReuseIdentifier = "MovieCVC"
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        self.movieImageView.layer.cornerRadius = 16
    }
    
    func setupCell(imageUrl: String, title: String) {
        if let url = URL(string: imageUrl) {
            NetworkService.shared.loadImage(from: url) { movieImage in
                self.movieImageView.image = movieImage
            }
            self.titleLabel.text = title
        }
    }
}
