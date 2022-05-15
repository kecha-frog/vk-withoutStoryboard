//
//  NewsTextTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

class NewsTextTableViewCell: UITableViewCell {
    private let textNews: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    static var identifier: String = "NewsTextTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textNews.text = nil
    }
    
    /// Настройка  UI.
    private func setupUI(){
        selectionStyle = .none
        contentView.addSubview(textNews)
        let constanta: CGFloat = 8
        NSLayoutConstraint.activate([
            textNews.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constanta),
            textNews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textNews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constanta),
            textNews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constanta),
        ])
    }
    
    func configure(_ text: String){
        textNews.text = text
    }
}
