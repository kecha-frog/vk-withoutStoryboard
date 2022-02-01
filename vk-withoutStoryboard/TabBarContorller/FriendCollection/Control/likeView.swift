//
//  likeView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.02.2022.
//

import UIKit

class LikePhoto: UIControl {
    //var youLike: Bool? {
    //        didSet {
    //            self.sendActions(for: .valueChanged)
    //        }
    //    }
    
    var youLike: Bool?
    var likeCount: Int = 0{
        didSet{
            label.text = String(likeCount)
        }
    }
   
    var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "like")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var label: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        text.textColor = .white
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -1),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    func addGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAction))
        addGestureRecognizer(tap)
    }
    
    
    func configure(_ likeCount: Int, youLike:Bool){
        self.likeCount = likeCount
        self.youLike = youLike
        imageView.tintColor = youLike ? .red : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    @objc func likeAction(_ sender: UITapGestureRecognizer){
        self.youLike = !youLike!
        if !youLike! {
            imageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            likeCount -= 1
        }else if youLike!{
            imageView.tintColor = .red
            likeCount += 1
        }
    }
}
