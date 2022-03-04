//
//  FriendCollectionViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeView: LikeControl = {
        let view = LikeControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var indexImage:Int?
    static let identifier = "FriendCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    var delegate: FriendCollectionViewCellDelegate?
    
    private func setupUI(){
        addSubview(imageView)
        let topConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        
        let width = (UIScreen.main.bounds.width - 9) / 2 
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalToConstant: width),
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
    
    func configure(_ image:PhotoModelApi, index: Int){
        indexImage = index
        imageView.load(urlString: image.sizes.last!.url)
        //likeView.configure(image.like, youLike: image.youLike)
        likeView.addTarget(self, action: #selector(likePhotoAction), for: .valueChanged)
    }

    @objc private func likePhotoAction(){
        delegate?.actionLikePhoto(likeView.youLike, indexPhoto: indexImage!)
    }
}

protocol FriendCollectionViewCellDelegate: AnyObject{
    func actionLikePhoto(_ like:Bool, indexPhoto: Int)
}
