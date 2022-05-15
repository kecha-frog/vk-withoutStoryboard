//
//  NewsPhotosTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

final class NewsPhotosTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    private let imageNewsView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Static Properties
    static var identifier: String = "NewsContentTableViewCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageNewsView.image = nil
    }

    // MARK: - Setting UI
    /// Настройка UI.
    private func setupUI() {
        selectionStyle = .none

        contentView.addSubview(imageNewsView)
        let topConstraint: NSLayoutConstraint = imageNewsView.topAnchor.constraint(equalTo: contentView.topAnchor)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint: NSLayoutConstraint = imageNewsView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            imageNewsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageNewsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageNewsView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }

    // MARK: - Public Methods
    func configure(_ content: [Attachment]) {
        if let photo: Attachment = content.first(where: { $0.type == "photo" }) {
            // MARK: Доделать поддержку множество фото.
            // Временно выводит только одно фото.
            LoaderImage.standart.load(url: photo.photo?.sizes.last?.url ?? "") { image in
                self.imageNewsView.image = image
            }
        }
    }
}
