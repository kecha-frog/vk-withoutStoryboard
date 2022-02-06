//
//  likeView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.02.2022.
//

import UIKit

class LikeControl: UIControl {
    var youLike: Bool = false
    
    private var likeCount: Int = 0{
        didSet{
            label.text = String(likeCount)
        }
    }
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "like")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var label: UILabel = {
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
    
    private func setupUI(){
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -1),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
    
    private func addGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAction))
        addGestureRecognizer(tap)
    }
    
    func configure(_ likeCount: Int, youLike:Bool){
        self.youLike = youLike
        self.likeCount = likeCount
        imageView.tintColor = youLike ? .red : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    @objc private func likeAction(_ sender: UITapGestureRecognizer){
        self.youLike.toggle()
        self.likeCount = youLike ? likeCount + 1 : likeCount - 1
        animationLike()
        self.sendActions(for: .valueChanged)
    }
    
    //MARK: 3
    private func animationLike(){
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.3
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.5
        scaleAnimation.autoreverses = true
        self.imageView.layer.add(scaleAnimation, forKey: "transform.scale")
        self.label.layer.add(scaleAnimation, forKey: "transform.scale")
        
        UIView.animate(withDuration: 0.3) {
            self.imageView.tintColor = self.youLike ? .red : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        
    }
}
