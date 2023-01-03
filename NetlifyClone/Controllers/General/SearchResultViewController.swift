//
//  SearchResultViewController.swift
//  NetlifyClone
//
//  
//

import UIKit

protocol SearchResultViewControllerDelegate :AnyObject {
    func didTapOnCell(_ model:TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    
    public weak var delegate: SearchResultViewControllerDelegate?
    
    private let searchCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 160)
        layout.minimumInteritemSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return cv
    }()
    
    private var titles:[Title] = [Title]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(searchCollectionView)
        
        searchCollectionView.frame = view.bounds
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    func searchMovie(query:String){
        APICaller.shared.getSearchedMovies(query: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.titles = movies
                DispatchQueue.main.async {
                    self?.searchCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchResultViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as?
                TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = titles[indexPath.row]
        cell.configure(with: movie.posterPath ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = titles[indexPath.row]
        guard let title = movie.originalTitle ?? movie.title else {return}
        
        APICaller.shared.getYoutubeMovie(query: title + " trailer") { [weak self] result in
            switch result {
            case .success(let video):
                self?.delegate?.didTapOnCell(TitlePreviewViewModel(title: title, overview: movie.overview ?? "NA", videoElement: video))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}
