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
    
    // MARK: - Setting UI Method
    /// Настройка UI.
    private func setupUI() {
        selectionStyle = .none
        
        let constant: CGFloat = 2
        contentView.addSubview(imageNewsView)
        let topConstraint: NSLayoutConstraint = imageNewsView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: constant)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint: NSLayoutConstraint = imageNewsView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor, constant: -constant)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            imageNewsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constant),
            imageNewsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constant)
        ])
    }
    
    // MARK: - Public Methods
    func configure(_ content: [Attachment]) {
        if let photo: Attachment = content.first(where: { $0.type == "photo" }) {
#warning("Доделать поддержку множество фото")
            // Временно выводит только одно фото.
            loadImage(url: photo.photo?.sizes.last?.url ?? "")
        }
    }
    
    // MARK: - Private Methods
    private func loadImage(url: String) {
        Task(priority: .background) {
            do {
                self.imageNewsView.image = try await LoaderImageLayer.shared.loadAsync(
                    url: url,
                    cache: .off)
            } catch {
                print(error)
            }
        }
    }
}
