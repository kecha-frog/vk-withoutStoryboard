//
//  FriendCollectionViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

// MARK: - Protocol Delegate
/// Delegate Protocol  like photo.
protocol FriendCollectionViewCellDelegate: AnyObject {
    /// Action like photo.
    /// - Parameters:
    ///   - like: Булевое значение.
    ///   - indexPhoto: Индекс фотографии.
    func actionLikePhoto(_ like: Bool, indexPhoto: Int)
}

final class FriendCollectionViewCell: UICollectionViewCell {
    // MARK: - Public Properties
    weak var delegate: FriendCollectionViewCellDelegate?

    // MARK: - Private Properties
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

    // MARK: - Static Properties
    static let identifier: String = "FriendCollectionViewCell"

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Setting UI
    /// Настройка UI.
    private func setupUI() {
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
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])

        addSubview(likeView)
        NSLayoutConstraint.activate([
            likeView.widthAnchor.constraint(equalToConstant: 25),
            likeView.heightAnchor.constraint(equalToConstant: 25),
            likeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    // MARK: - Public Methods
    /// Конфигурация  ячейки.
    /// - Parameters:
    ///   - image: Данные изображения.
    ///   - cache: Кэш где хранятся фото.
    ///
    ///   Возможность взять изображение из кэша если он там сохранено.
    func configure(_ image: PhotoModel, cache: PhotoNSCache) {
        guard let url: String = image.sizes.last?.url, let urlImage = URL(string: url) else { return }

        // Проверяем есть ли фото в кэше
        if let imageChache: UIImage = cache.getImage(for: urlImage) {
            // если есть отдаем фото из кэша
            imageView.image = imageChache
        } else {
            // Если нет, то загружаем изображение из интернета и сохраняем его в кэш.
            LoaderImage.standart.load(url: url) { [weak self ] image in
                cache.saveImage(image, for: urlImage)
                self?.imageView.image = image
            }
        }

        // Доделать
        // likeView.configure(image.like, youLike: image.youLike)
        likeView.addTarget(self, action: #selector(likePhotoAction), for: .valueChanged)
    }

    // MARK: - Actions
    /// Таргет для контрола likeView.
    @objc private func likePhotoAction() {
        // delegate?.actionLikePhoto(likeView.youLike, indexPhoto: indexImage!)
    }
}
