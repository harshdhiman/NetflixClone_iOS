//
//  DownloadsViewController.swift
//  NetlifyClone
//
//  
//

import UIKit

class DownloadsViewController: UIViewController{
    
    private var titles:[TitleItem] = [TitleItem]()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        getDownloads()
        
        tableView.frame = view.bounds
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("download"), object: nil, queue: nil) { _ in
            self.getDownloads()
        }
    }
    
    private func getDownloads() {
        DataPersistentManager.shared.loadSavedMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.titles = movies
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}



extension DownloadsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            DataPersistentManager.shared.deleteMovie(with: titles[indexPath.row]) { result in
                switch result {
                case .success():
                    self.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error)
                }
            }
            
        default:
            break
        }
    }
    
    
}
