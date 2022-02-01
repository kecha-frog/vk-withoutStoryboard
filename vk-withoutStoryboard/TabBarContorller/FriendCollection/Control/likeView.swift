//
//  likeView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.02.2022.
//

import UIKit

class LikePhoto: UIControl {
    var youLike: Bool?
    var likeCount: Int = 0{
        didSet{
            label.text = String(likeCount)
        }
    }
    
    var button: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "like")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var label: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        text.textColor = .white
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.rightAnchor.constraint(equalTo: rightAnchor),
            button.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        button.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    func configure(_ likeCount: Int, youLike:Bool){
        self.likeCount = likeCount
        self.youLike = youLike
        button.tintColor = youLike ? .red : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    @objc func likeAction(){
        self.youLike = !youLike!
        if !youLike! {
            button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            likeCount -= 1
        }else if youLike!{
            button.tintColor = .red
            likeCount += 1
        }
    }
}
