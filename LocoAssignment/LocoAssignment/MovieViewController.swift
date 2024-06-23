//
//  MovieViewController.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 23/06/24.
//

import UIKit

class MovieViewController: ParentViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    
    let movieId: String
    let viewModel: MovieViewModel
    
    /// Custom init for the view controller so to set only once while initializing the VC
    /// - Parameters:
    ///   - coder: NSCoder to be passed
    ///   - movieID: imdbID of the movie for which data is to be fetched
    ///   - viewModel: to pass the instance of the same viewmodel created in the previous screen
    init?(coder: NSCoder, movieID: String, viewModel: MovieViewModel) {
        self.movieId = movieID
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(coder:movieID:)")
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:movieID:)` to initialize an `MovieViewController` instance.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        
        let loaderShown = self.showLoader()
        self.viewModel.callMovieInfoApi(imdbID: self.movieId) { [weak self] apiError in
            guard let strongSelf = self,
                  let movieInfo = strongSelf.viewModel.movieInfo
            else { return }
            strongSelf.stopLoader(loader: loaderShown)
            guard let err = apiError
            else {
                strongSelf.setupView(movieInfo: movieInfo)
                return
            }
            print(err.localizedDescription)
        }
    }
    
    func setupView(movieInfo: MovieScreenInfo) {
        if let imgUrl = URL(string: movieInfo.poster) {
            NetworkService.shared.loadImage(from: imgUrl) { image in
                self.movieImageView.image = image
            }
            self.plotLabel.text = movieInfo.plot
            self.titleLabel.text = movieInfo.title
            self.releaseDateLabel.text = "Release Date:\n\(movieInfo.released)"
            self.directorLabel.text = "Directed by:\n\(movieInfo.director)"
        }
    }
}
