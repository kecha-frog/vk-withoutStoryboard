//
//  FriendsHeaderSectionTableView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 03.02.2022.
//

import UIKit

/// Header section.
final class FriendsHeaderSectionTableView: UITableViewHeaderFooterView {
    // MARK: - Private Properties
    private let letterLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.alpha = 0.7
        text.textColor = .vkColor
        return text
    }()

    // MARK: - Static Properties
    static let identifier: String = "FriendsHeaderSectionTableView"

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        letterLabel.text = nil
    }

    // MARK: - Setting UI Method
    /// Настройка UI.
    private func setupUI() {
        contentView.addSubview(letterLabel)

        let top: NSLayoutConstraint = letterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2)
        top.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            top,
            letterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            letterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            letterLabel.heightAnchor.constraint(equalToConstant: 20),
            letterLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    // MARK: - Public Methods
    /// Задать текст  Header  секции.
    /// - Parameter text: Текст.
    func configure(_ text: String) {
        letterLabel.text = text
    }

}
