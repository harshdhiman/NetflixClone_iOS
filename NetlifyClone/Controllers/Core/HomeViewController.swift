//
//  HomeViewController.swift
//  NetlifyClone
//
//  
//

import UIKit


enum Sections: Int {
    case TrendingMovies = 0;
    case Popular = 1
    case TrendingTv = 2
    case UpcomingMovies = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = [
        "Trending Movies","Popular", "Trending TV", "Upcoming Movies" , "Top rated"
    ]
    
    private var randomTitle:Title?
    private var headerView: HeroHeaderUIView?

    private let homeFeedTable : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        homeFeedTable.frame = view.bounds
        
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        configureNavbar()
        configureHeaderBar()
    }
        
    private func configureHeaderBar(){
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case .success(let titles):
                let title = titles.randomElement()
                self.randomTitle = title
                let head = title?.title ?? title?.originalTitle ?? "Unknown"
                self.headerView?.configure(title: TitleViewModel(title: head, posterURL: title?.posterPath ?? ""))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func configureNavbar() {
        var logo = UIImage(named: "logo")
        logo = logo?.withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
        
        let bi = UIBarButtonItem(image: logo, style: .plain, target: self, action: nil)
//        navigationItem.leftBarButtonItem = bi
        navigationItem.title = "Netflix"
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        
        navigationController?.navigationBar.tintColor = .white
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        homeFeedTable.frame = view.bounds
    }
    
}



extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return  UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
                
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
                
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
                
            }
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
                
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
                
            }
        default:
            print("default")
        }
       
        
//        let cell = CollectionViewTableViewCell()
//        cell.textLabel?.text = "Hello World " + indexPath.description
//        cell.backgroundColor = .red;
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18,weight: .semibold)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defOffset = scrollView.safeAreaInsets.top
        let conOffset = scrollView.contentOffset.y
        let offset = conOffset + defOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeViewController : CollectionViewTableViewCellDelegate {
    func didTapOnCell(_ cell: CollectionViewTableViewCell, model: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
