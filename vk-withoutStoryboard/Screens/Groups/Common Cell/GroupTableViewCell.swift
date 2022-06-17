//
//  GroupTableViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

/// Ячейка группы.
final class GroupTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        return label
    }()

    private let imageViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Static Properties
    static let identifier = "GroupsTableViewCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        imageViewCell.image = nil
    }

    // MARK: - Setting UI Method
    /// Настройка UI.
    private func setupUI() {
        contentView.addSubview(imageViewCell)
        let topConstraint: NSLayoutConstraint = imageViewCell.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 4)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint: NSLayoutConstraint = imageViewCell.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -4)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            imageViewCell.widthAnchor.constraint(equalToConstant: 82),
            imageViewCell.heightAnchor.constraint(equalToConstant: 82),
            topConstraint,
            bottomConstraint,
            imageViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageViewCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: imageViewCell.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: imageViewCell.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Public Methods
    /// Конфигурация ячейки.
    /// - Parameter group: Экземпляр группы.
    func configure(group: GroupModel) {
        nameLabel.text = group.name
        // Загрузка изображения группы.
        loadImage(url: group.photo200)
    }

    func configure(group: CatalogViewModel) {
        nameLabel.text = group.name
        // Загрузка изображения группы.
        loadImage(url: group.photo200)
    }

    // MARK: - Private Methods
    private func loadImage(url: String) {
        Task(priority: .background) {
            do {
                self.imageViewCell.image = try await LoaderImageLayer.shared.loadAsync(url: url, cache: .off)
            } catch {
                print(error)
            }
        }
    }
}
