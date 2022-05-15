//
//  FriendCollectionViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

/// Delegate Protocol  like photo.
protocol FriendCollectionViewCellDelegate: AnyObject{
    /// Action like photo.
    /// - Parameters:
    ///   - like: Булевое значение.
    ///   - indexPhoto: Индекс фотографии.
    func actionLikePhoto(_ like:Bool, indexPhoto: Int)
}

class FriendCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeView: LikeControl = {
        let view: LikeControl = LikeControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let identifier: String = "FriendCollectionViewCell"
    
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
    
    weak var delegate: FriendCollectionViewCellDelegate?
    
    /// Настройка UI.
    private func setupUI(){
        addSubview(imageView)
        let topConstraint: NSLayoutConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint: NSLayoutConstraint = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        
        let width: CGFloat = (UIScreen.main.bounds.width - 9) / 2
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
    
    /// Конфигурация  ячейки.
    /// - Parameters:
    ///   - image: Данные изображения.
    ///   - cache: Кэш где хранятся фото.
    ///
    ///   Возможность взять изображение из кэша если он там сохранено.
    func configure(_ image:PhotoModel, cache: PhotoNSCache){
        guard let url: String = image.sizes.last?.url else { return }
        guard let urlImage: URL = URL(string: url) else { return }
        // Проверяем есть ли фото в кэше
        if let imageChache: UIImage = cache.getImage(for: urlImage){
            // если есть отдаем фото из кэша
            imageView.image = imageChache
        }else {
            // Если нет, то загружаем изображение из интернета и сохраняем его в кэш.
            LoaderImage.standart.load(url: url) { [weak self ] image in
                cache.saveImage(image, for: urlImage)
                self?.imageView.image = image
            }
        }
        // Доделать
        //likeView.configure(image.like, youLike: image.youLike)
        likeView.addTarget(self, action: #selector(likePhotoAction), for: .valueChanged)
    }
    
    /// Таргет для контрола likeView.
    @objc private func likePhotoAction(){
        //delegate?.actionLikePhoto(likeView.youLike, indexPhoto: indexImage!)
    }
}

