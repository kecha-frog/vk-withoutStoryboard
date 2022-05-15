//
//  NewsPhotosTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

class NewsPhotosTableViewCell: UITableViewCell {
    private let photoView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    static var identifier: String = "NewsContentTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
    
    /// Настройка UI.
    private func setupUI(){
        selectionStyle = .none
        
        contentView.addSubview(photoView)
        let topConstraint: NSLayoutConstraint = photoView.topAnchor.constraint(equalTo: contentView.topAnchor)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint: NSLayoutConstraint = photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func configure(_ content: [Attachment]){
        if let photo: Attachment = content.first(where: { $0.type == "photo"}){
            // MARK: Доделать поддержку множество фото.
            // Временно выводит только одно фото.
            LoaderImage.standart.load(url: photo.photo?.sizes.last?.url ?? "") { image in
                self.photoView.image = image
            }
        }
    }
    
}
