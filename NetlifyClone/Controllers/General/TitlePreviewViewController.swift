//
//  TitlePreviewViewController.swift
//  NetlifyClone
//
//  
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    
    private let webView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Unknown"
        lb.font = .systemFont(ofSize: 22,weight: .bold)
        lb.numberOfLines = 0
        return lb
    }()
    
    private let overviewLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "NA"
        lb.font = .systemFont(ofSize: 18,weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .red
        button.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        button.setTitle("Download", for: .normal)
            
        button.layer.cornerRadius = 8
        
        var config = UIButton.Configuration.filled()
        config.imagePadding = 5
        
        button.configuration = config
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        configureConstraints();
    }
    
    
    public func configure(with model:TitlePreviewViewModel){
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        // webivew
        guard let url = URL(string: "https://youtube.com/embed/\(model.videoElement.id.videoId)") else {return}
        webView.load(URLRequest(url:url))
    }
    
    func configureConstraints(){
        let conts = [
            // webview
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            //title
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor,constant: 40),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant:10),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: 10),
            
            // overviewlabel
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10),
            overviewLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            overviewLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: 10),
            
            // button
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor,constant: 30),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(conts)
    }

}
