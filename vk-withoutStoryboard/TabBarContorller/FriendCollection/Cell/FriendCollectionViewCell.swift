//
//  FriendCollectionViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let likeView: LikePhoto = {
        let view = LikePhoto()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let identifier = "FriendCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(imageView)
        let topConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            topConstraint,
            bottomConstraint,
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        
        addSubview(likeView)
        NSLayoutConstraint.activate([
            likeView.widthAnchor.constraint(equalToConstant: 25),
            likeView.heightAnchor.constraint(equalToConstant: 25),
            likeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(_ image:ImageModel){
        imageView.image = UIImage(named: image.name)
        likeView.configure(image.like, youLike: image.youLike)
        //likeView.addTarget(self, action: #selector(likePhotoAction(_:)), for: .valueChanged)
    }

//    @objc func likePhotoAction(_ sender:LikePhoto){
//        guard let like = likePhotoView.youLike else {
//            return
//        }
//        print(like)
//    }
}
