//
//  NewsTextTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

// MARK: - Delegate
protocol NewsTextTableViewCellDelegate: AnyObject {
    func moreButtonTapped(_ cell: NewsTextTableViewCell)
}

final class NewsTextTableViewCell: UITableViewCell {
    // MARK: - Public Properties
    weak var delegate: NewsTextTableViewCellDelegate?

    // MARK: - Private Properties
    private let textNewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.backgroundColor = .white
        return label
    }()

    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(UIColor.vkColor, for: .normal)
        button.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        return button
    }()

    private var isSeeLess = true {
        didSet {
            textNewsLabel.numberOfLines = isSeeLess ? 0 : 4
            moreButton.setTitle(self.isSeeLess ? "Скрыть" : "Показать полностью...", for: .normal)
        }
    }

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
        moreButton.isHidden = false
    }

    // MARK: - Setting UI Method
    /// Настройка  UI.
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(textNewsLabel)

        let constanta: CGFloat = 8
        NSLayoutConstraint.activate([
            textNewsLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textNewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constanta),
            textNewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constanta)
        ])

        contentView.addSubview(moreButton)
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: textNewsLabel.bottomAnchor),
            moreButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constanta),
            moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Action
    @objc private func moreButtonAction() {
        isSeeLess.toggle()
        delegate?.moreButtonTapped(self)
    }

    // MARK: - Public Methods
    func configure(_ text: String, isExpended: Bool) {
        moreButtonHidden(text)
        textNewsLabel.text = text
        self.isSeeLess = isExpended
    }

    // MARK: - Private Methods
    private func moreButtonHidden(_ text: String) {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = text as NSString
        let textHeight = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: textNewsLabel.font as Any],
            context: nil).height
        let lineHeight = textNewsLabel.font.lineHeight

        if ceil(textHeight / lineHeight) < 4 {
            moreButton.isHidden = true
        }
    }
}
