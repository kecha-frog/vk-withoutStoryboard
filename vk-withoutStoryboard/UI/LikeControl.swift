//
//  likeView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.02.2022.
//

import UIKit

#warning("Переделать LikeControl и дописать доку")
final class LikeControl: UIControl {
    // MARK: - Private Properties
    private var imageView: UIImageView = {
        let imageName = "like"
        let image = UIImage(named: imageName)
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var countLabel: UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 12, weight: .bold)
        text.textColor = .gray
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    private(set) var userLike = false

    private var count: Int = 0 {
        didSet {
            self.countLabel.text = kilo(self.count)
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Method
    private func setupUI() {
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        self.addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -4)
        ])
    }

    // MARK: - Public Methods
    func configure(_ likeCount: Int, youLike: Int) {
        self.userLike = youLike == 1
        self.count = likeCount
        imageView.tintColor = youLike == 1 ? .red : .darkGray
    }

    // MARK: - Private Methods
    private func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeControlAction))
        addGestureRecognizer(tap)
    }

    private func kilo(_ number: Int) -> String {
        if number >= 1000 && number < 10000 {
            return String(format: "%.1fK", Double(number / 100) / 10).replacingOccurrences(of: ".0", with: "")
        }

        if number >= 10000 && number < 1000000 {
            return "\(number / 1000)k"
        }

        if number >= 1000000 && number < 10000000 {
            return String(format: "%.1fM", Double(number / 100000) / 10).replacingOccurrences(of: ".0", with: "")
        }

        if number >= 10000000 {
            return "\(number / 1000000)M"
        }

        return String(number)
    }

    private func clickAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.2
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.3
        scaleAnimation.autoreverses = true
        self.imageView.layer.add(scaleAnimation, forKey: nil)
        self.countLabel.layer.add(scaleAnimation, forKey: nil)

        UIView.transition(with: countLabel, duration: 0.5, options: [.transitionFlipFromBottom, .curveEaseInOut] ) {
            self.imageView.tintColor = self.userLike ? .red : .darkGray
        }
    }

    // MARK: - Actions
    @objc private func likeControlAction(_ sender: UITapGestureRecognizer) {
        self.userLike.toggle()
        self.count = userLike ? count + 1 : count - 1
        clickAnimation()
        self.sendActions(for: .valueChanged)
    }
}
