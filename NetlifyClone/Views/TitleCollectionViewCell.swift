//
//  TitleCollectionViewCell.swift
//  NetlifyClone
//
//  
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private let imageView : UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleToFill
        
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with model:String){
        if (model.isEmpty){
            imageView.image = UIImage(systemName: "questionmark.circle")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .white
            return
        }
        guard let url = URL(string: "\(Constants.imagesBaseURL)\(model)") else {return}
        imageView.sd_setImage(with: url)
    }
}
