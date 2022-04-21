//
//  likeView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.02.2022.
//

import UIKit

// TODO: Переделать LikeControl и дописать доку.
class LikeControl: UIControl {
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
        text.font = .systemFont(ofSize: 12, weight: .bold)
        text.textColor = .gray
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private(set) var youLike: Bool = false
    
    private var likeCount: Int = 0{
        didSet{
            self.label.text = kilo(self.likeCount)
        }
    }
    
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
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -4),
        ])
    }
    
    private func addGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAction))
        addGestureRecognizer(tap)
    }
    
    func configure(_ likeCount: Int, youLike:Int){
        self.youLike = youLike == 1
        self.likeCount = likeCount
        imageView.tintColor = youLike == 1 ? .red : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    private func kilo(_ number:Int) -> String {
        if number >= 1000 && number < 10000 {
            return String(format: "%.1fK", Double(number/100)/10).replacingOccurrences(of: ".0", with: "")
        }
        
        if number >= 10000 && number < 1000000 {
            return "\(number/1000)k"
        }
        
        if number >= 1000000 && number < 10000000 {
            return String(format: "%.1fM", Double(number/100000)/10).replacingOccurrences(of: ".0", with: "")
        }
        
        if number >= 10000000 {
            return "\(number/1000000)M"
        }
        
        return String(number)
    }
    
    @objc private func likeAction(_ sender: UITapGestureRecognizer){
        self.youLike.toggle()
        self.likeCount = youLike ? likeCount + 1 : likeCount - 1
        animationLike()
        self.sendActions(for: .valueChanged)
    }
    
    private func animationLike(){
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.2
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.3
        scaleAnimation.autoreverses = true
        self.imageView.layer.add(scaleAnimation, forKey: nil)
        self.label.layer.add(scaleAnimation, forKey: nil)
        
        UIView.transition(with: label, duration: 0.5, options: [.transitionFlipFromBottom, .curveEaseInOut] ){
            self.imageView.tintColor = self.youLike ? .red : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
}
