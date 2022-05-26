//
//  NewsStubCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 26.05.2022.
//

import Foundation
import UIKit

class NewsStubTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    private let stubNewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.backgroundColor = .white
        label.lineBreakMode = .byTruncatingMiddle
        label.text = "###  NOT WORK AUDIO/VIDEO/OTHER FILES ###"
        label.textAlignment = .center
        label.backgroundColor = .red
        label.textColor = .white
        return label
    }()

    // MARK: - Static Properties
    static var identifier: String = "NewsStubTableViewCell"
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Method
    /// Настройка  UI.
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(stubNewsLabel)

        let constanta: CGFloat = 8
        NSLayoutConstraint.activate([
            stubNewsLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stubNewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stubNewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constanta),
            stubNewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constanta)
        ])
    }
}
