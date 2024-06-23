//
//  ViewController.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 22/06/24.
//

import UIKit

class MainViewController: ParentViewController {
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var movieCV: UICollectionView!
    
    fileprivate var workItem: DispatchWorkItem?
    fileprivate let viewModel = MovieViewModel()
    
    fileprivate var emptyView: UIView!
    fileprivate var emptyLabel: UILabel!
    
    fileprivate var searchString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.setupEmptyView()
    }
    
    /// To call api based on the search parameter
    /// - Parameter shouldResetPage: Page needs to be reset for a new search string
    fileprivate func performSearch(shouldResetPage: Bool) {
        if self.searchString.count >= 3 {
            self.emptyView.isHidden = true
            let loader = self.showLoader()
            self.viewModel.callSearchMovieApi(searchQuery: self.searchString, shouldResetPage: shouldResetPage) { [weak self] apiError in
                guard let strongSelf = self else { return }
                strongSelf.stopLoader(loader: loader)
                guard let err = apiError else {
                    if strongSelf.viewModel.movieList.isEmpty {
                        strongSelf.emptyLabel.text = "Sorry, We could not\n find the result you\n are searching for"
                        strongSelf.emptyView.isHidden = false
                    }
                    else {
                        strongSelf.movieCV.reloadData()
                    }
                    return
                }
                print(err.localizedDescription)
            }
        } else {
            self.emptyLabel.text = "You can search\nfor movies here"
            self.emptyView.isHidden = false
        }
    }
    
    
    fileprivate func setupEmptyView() {
        self.emptyView = UIView()
        self.emptyView.translatesAutoresizingMaskIntoConstraints = false
        self.emptyView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(emptyView)
        
        self.emptyLabel = UILabel()
        self.emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emptyLabel.numberOfLines = 0
        self.emptyLabel.text = "You can search\nfor movies here"
        self.emptyLabel.font = .systemFont(ofSize: 32, weight: .bold)
        self.emptyLabel.textAlignment = .center
        self.emptyLabel.textColor = .gray
        self.emptyView.addSubview(self.emptyLabel)
        
        NSLayoutConstraint.activate([
            self.emptyView.leadingAnchor.constraint(equalTo: self.movieCV.leadingAnchor),
            self.emptyView.trailingAnchor.constraint(equalTo: self.movieCV.trailingAnchor),
            self.emptyView.topAnchor.constraint(equalTo: self.movieCV.topAnchor),
            self.emptyView.bottomAnchor.constraint(equalTo: self.movieCV.bottomAnchor),
            
            self.emptyLabel.centerXAnchor.constraint(equalTo: self.emptyView.centerXAnchor),
            self.emptyLabel.centerYAnchor.constraint(equalTo: self.emptyView.centerYAnchor)
        ])
        self.emptyView.isHidden = false
    }
}

extension MainViewController: SearchBarProtocol {
    /// Action to perform when characters are changed in search field
    /// - Parameter query: Text present currently in the field
    func searchItem(query: String) {
        self.workItem?.cancel()
        let dispatchWorkItem = DispatchWorkItem { [weak self] in
        guard let strongSelf = self else { return }
            strongSelf.searchString = query
            strongSelf.performSearch(shouldResetPage: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: dispatchWorkItem)
        self.workItem = dispatchWorkItem
    }
    
    func searchTapped() {
        print("functionality to be perform on textfield tap")
    }
    
    func didEndEditing(text: String) {
        print("functionality to be performed on textfield exit")
    }
}

// MARK :- UICollectionView functions
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCVC.cellReuseIdentifier, for: indexPath) as? MovieCVC
        else  { return UICollectionViewCell() }
        let movieDetail = self.viewModel.movieList[indexPath.row]
        cell.setupCell(imageUrl: movieDetail.poster, title: movieDetail.title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetail = self.viewModel.movieList[indexPath.row]
        let movieVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            identifier: "MovieViewController",
            creator: { coder in
                return MovieViewController(
                    coder: coder,
                    movieID: movieDetail.imdbID,
                    viewModel: self.viewModel
                )
            }
        )
        self.navigationController?.pushViewController(movieVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageLength = collectionView.frame.width/2 - 10
        return CGSize(width: imageLength, height: imageLength + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // to perform Pagination
        if indexPath.row + 1 == self.viewModel.movieList.count && !self.viewModel.endReached {
            self.performSearch(shouldResetPage: false)
        }
    }
}
