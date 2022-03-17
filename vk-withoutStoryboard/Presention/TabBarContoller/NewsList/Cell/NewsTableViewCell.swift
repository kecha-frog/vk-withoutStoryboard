//
//  NewsTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 04.02.2022.
//

import UIKit

// TODO: Доделать
protocol NewsTableViewCellDelegate: AnyObject{
    func actionLikePost(_ like:Bool, indexPost: Int)
}

class NewsTableViewCell: UITableViewCell {
    private let avatarPost: AvatarView = {
        let imageView = AvatarView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorPost: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textPost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let imagePost: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likePost: LikeControl = {
        let control = LikeControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let watchPost: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.alpha = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private var indexPost: Int?
    
    weak var delegate: NewsTableViewCellDelegate?
    static var identifier = "NewsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        selectionStyle = .none
        
        let constraint: CGFloat = 12
        contentView.addSubview(avatarPost)
        NSLayoutConstraint.activate([
            avatarPost.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constraint),
            avatarPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            avatarPost.heightAnchor.constraint(equalToConstant: 44),
            avatarPost.widthAnchor.constraint(equalToConstant: 44),
        ])
        
        contentView.addSubview(authorPost)
        NSLayoutConstraint.activate([
            authorPost.centerYAnchor.constraint(equalTo: avatarPost.centerYAnchor, constant: 0),
            authorPost.leadingAnchor.constraint(equalTo: avatarPost.trailingAnchor, constant: constraint),
        ])
        
        contentView.addSubview(textPost)
        NSLayoutConstraint.activate([
            textPost.topAnchor.constraint(equalTo: avatarPost.bottomAnchor, constant: constraint),
            textPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            textPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraint),
        ])
        
        contentView.addSubview(imagePost)
        NSLayoutConstraint.activate([
            imagePost.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            imagePost.topAnchor.constraint(equalTo: textPost.bottomAnchor, constant: constraint),
            imagePost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            imagePost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraint),
        ])
        
        contentView.addSubview(likePost)
        NSLayoutConstraint.activate([
            likePost.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: constraint),
            likePost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -(constraint * 2)),
            likePost.heightAnchor.constraint(equalToConstant: 20),
            likePost.widthAnchor.constraint(equalToConstant: 20),
            likePost.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constraint)
        ])
        
        contentView.addSubview(watchPost)
        NSLayoutConstraint.activate([
            watchPost.centerYAnchor.constraint(equalTo: likePost.centerYAnchor),
            watchPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint)
        ])
    }
    
//    func configure(author:UserModel, post: Any, index:Int){
//        indexPost = index
//        //avatarPost.setImage(author.avatarName!)
//        authorPost.text = "\(author.name!) \(author.surname!)"
//        //textPost.text = post.body
//        //let imageBase = FriendStorageImage(author.id)
//        //let image = imageBase.getRandomImage()
//        //imagePost.image = UIImage(named: image.name)
//        //watchPost.text = String(post.watch)
//        //likePost.configure(post.like, youLike: post.youLike)
//        likePost.addTarget(self, action: #selector(likePostAction), for: .valueChanged)
//    }
    
//    override func prepareForReuse() {
//        <#code#>
//    }
    
    @objc private func likePostAction(){
        delegate?.actionLikePost(likePost.youLike, indexPost: indexPost!)
    }
}

