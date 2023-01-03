//
//  SearchViewController.swift
//  NetlifyClone
//
//  
//

import UIKit

class SearchViewController: UIViewController {
    
    private let discoverTable : UITableView = {
       let tv = UITableView()
        tv.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tv
    }()
    
    var titles : [Title] = [Title]()
    
    private let searchController : UISearchController = {
        let sc = UISearchController(searchResultsController: SearchResultViewController())
        sc.searchBar.placeholder = "Search for Movies or TV Shows"
//        sc.searchBar.searchBarStyle = .minimal
        return sc
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        
        navigationItem.searchController?.searchResultsUpdater = self
        
        
        view.addSubview(discoverTable)
        
        discoverTable.frame = view.bounds
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        fetchDiscoverMovies()
    }
    
    
    func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { result in
            switch result{
            case .success(let movies):
                self.titles = movies
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}


extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,for: indexPath) as? TitleTableViewCell
        else {
            return UITableViewCell()
        }
        
        let movie = titles[indexPath.row]
        let text =  movie.title ?? movie.originalTitle ?? "Unknown"
        
        cell.configure(with: TitleViewModel(title: text, posterURL: movie.posterPath!))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = titles[indexPath.row]
        guard let title = movie.originalTitle ?? movie.title else {return}
        
        APICaller.shared.getYoutubeMovie(query: title + " trailer") { [weak self] result in
            switch result {
            case .success(let video):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: title, overview: movie.overview ?? "", videoElement:
                                                            video
                                                            ))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}


extension SearchViewController : UISearchResultsUpdating, SearchResultViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let bar = searchController.searchBar;
        
        guard let query = bar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController
        else {
            return
        }
        
        resultController.delegate = self
        
        resultController.searchMovie(query: query)
    }
    
    func didTapOnCell(_ model: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
