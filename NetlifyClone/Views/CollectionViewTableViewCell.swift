//
//  CollectionViewTableViewCell.swift
//  NetlifyClone
//
//  
//

import UIKit

protocol CollectionViewTableViewCellDelegate:AnyObject {
    func didTapOnCell(_ cell:CollectionViewTableViewCell,model:TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell";
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles:[Title] = [Title]()
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        
        layout.scrollDirection  = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.register(TitleCollectionViewCell.self , forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return cv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .red
        
        contentView.addSubview(collectionView)
        
        
        collectionView.delegate = self
        collectionView.dataSource  = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        collectionView.frame = contentView.bounds

    }
    
    
    public func configure(with titles:[Title]){
        self.titles = titles
        
        DispatchQueue.main.async {
            [weak self] in
            self?.collectionView.reloadData()
        }
    }

    
    func downloadVideo(indexPath:IndexPath){
        let title = titles[indexPath.row]
        DataPersistentManager.shared.saveMovie(with: title) { _ in
            NotificationCenter.default.post(name: NSNotification.Name("download"), object: nil)
        }
    }

}

extension CollectionViewTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = UICollectionViewCell()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath)
                as? TitleCollectionViewCell else {
                    return UICollectionViewCell()
                }
        
        cell.configure(with: titles[indexPath.row].posterPath!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = titles[indexPath.row]
        guard let title = movie.originalTitle ?? movie.title else {return}
        
        APICaller.shared.getYoutubeMovie(query: title + " trailer") { [weak self] result in
            switch result {
            case .success(let video):
                
                guard let strongSelf = self else {return}
                
                self?.delegate?.didTapOnCell(strongSelf, model: TitlePreviewViewModel(title: title, overview: movie.overview ?? "NA", videoElement: video))
                
            case .failure(let error):
                print(error)
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        
        let config : UIContextMenuConfiguration = UIContextMenuConfiguration(actionProvider:  {[weak self] _ in
            let downloadButton = UIAction(title: "Download") { _ in
                self?.downloadVideo(indexPath: indexPath)
            }
            
            return UIMenu(children: [downloadButton])
        })
        
        return config
    }
    
    
}
