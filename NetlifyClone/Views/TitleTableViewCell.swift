//
//  TitleTableViewCell.swift
//  NetlifyClone
//
//  
//

import UIKit
import SDWebImage


class TitleTableViewCell: UITableViewCell {
    static let identifier = "TitleTableViewCell"
    
    private let poster : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false;
        return iv
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    
    private let button : UIButton = {
        let b = UIButton()
        let im = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        b.setImage(im, for: .normal)
        b.tintColor = .red
        b.translatesAutoresizingMaskIntoConstraints = false;
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(poster)
        contentView.addSubview(titleLabel)
        contentView.addSubview(button)
    
        applyContrainsts()
    }
    
    func applyContrainsts(){
        let posterCosts = [
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            poster.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 2),
            poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -2),
            poster.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleCosts = [
            titleLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor,constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -65)
        ]
        
        let buttonCosts = [
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterCosts)
        NSLayoutConstraint.activate(titleCosts)
        NSLayoutConstraint.activate(buttonCosts)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    public func configure(with titleViewModel:TitleViewModel){
        guard let url = URL(string: "\(Constants.imagesBaseURL)\(titleViewModel.posterURL)") else {return}
        
        self.poster.sd_setImage(with: url)
        self.titleLabel.text = titleViewModel.title
    }
    
    
    

}
