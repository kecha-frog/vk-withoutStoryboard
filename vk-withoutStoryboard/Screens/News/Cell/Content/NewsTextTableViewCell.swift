//
//  NewsTextTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

final class NewsTextTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    private let textNewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Static Properties
    static var identifier: String = "NewsTextTableViewCell"

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
        textNewsLabel.text = nil
    }

    // MARK: - Setting UI Method
    /// Настройка  UI.
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(textNewsLabel)
        let constanta: CGFloat = 8
        NSLayoutConstraint.activate([
            textNewsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constanta),
            textNewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textNewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constanta),
            textNewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constanta)
        ])
    }

    // MARK: - Public Methods
    func configure(_ text: String) {
        textNewsLabel.text = text
    }
}
