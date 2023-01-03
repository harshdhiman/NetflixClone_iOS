//
//  HeroHeaderUIView.swift
//  NetlifyClone
//
//  
//

import UIKit

class HeaderButton : UIButton{
    init(title:String, image:UIImage? = nil,color:UIColor = .white, frame:CGRect = .zero) {
        super.init(frame: frame)
        
        layer.borderColor = color.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 5
        setTitle(title, for: .normal)
        
        tintColor = color
        
        if (image != nil){
            setImage(image, for: .normal)
        }
        
        var config = Configuration.bordered()
        config.imagePadding = 5
        
        configuration = config
        
    }
    
   
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class HeroHeaderUIView: UIView {
    
    let playButton: HeaderButton = {
        let b = HeaderButton(title: "Play",image: {
            var i = UIImage(systemName: "play.circle")
            return i
        }(),color: .white)
        b.frame = CGRect(x: 0, y: 0, width: 100, height: 45 )
        return b
    }()
    
    let downloadButton : HeaderButton = {
       let b = HeaderButton(title: "Download",image: UIImage(systemName: "arrow.down.to.line"))
        b.frame = CGRect(x: 0, y: 0, width: 100, height: 45 )
        
        return b
    }()
    
    let buttonsStack:UIStackView = {
        let hs = UIStackView()
    
        hs.alignment = .fill
        hs.distribution = .fillEqually
        hs.spacing  = 20;

        return hs
    }()
    
    let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ryujin")
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv;
    }()
    
    
    private func addGradient(){
        let gradient = CAGradientLayer()
        
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
        gradient.frame = bounds
        
        layer.addSublayer(gradient)
    }

    
    public func configure(title:TitleViewModel){
        guard let url = URL(string: "\(Constants.imagesBaseURL)\(title.posterURL)") else {return}
        
        heroImageView.sd_setImage(with: url)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
        addGradient()


        
        let w:CGFloat = 140 * 2
        let h = playButton.frame.height
        let offsetY :CGFloat = 90
        buttonsStack.frame = CGRect(x: frame.midX - (w/2), y: frame.height - offsetY, width: w, height: h)

        buttonsStack.addArrangedSubview(playButton)
        buttonsStack.addArrangedSubview(downloadButton)
    
        addSubview(buttonsStack)
        
        
        
        
        heroImageView.frame = bounds;
    }
    
 
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
  
}
