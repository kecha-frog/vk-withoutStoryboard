//
//  LoadingView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 07.02.2022.
//

import UIKit
extension LoadingView {
    enum Color {
        case blue
        case white
    }
}

/// View анимация загрузки.
///
///  Анимация - Три точки.
final class LoadingView: UIView {
    private let dot1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "●"
        return label
    }()

    private let dot2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "●"
        return label
    }()

    private let dot3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "●"
        return label
    }()

    /// Кастомный init. Выбор фона для анимации.
    /// - Parameter background: цвет фона
    init(_ backgroundColor: Color = .white) {
        super.init(frame: .zero)
        setupUI(backgroundColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Настройка view.
    /// - Parameter color: цвет фона.
    private func setupUI(_ color: Color) {
        self.isHidden = true

        let dotColor: UIColor
        let backgroundColor: UIColor

        switch color {
        case .blue:
            dotColor = .white
            backgroundColor = .vkColor
        case .white:
            dotColor = .vkColor
            backgroundColor = .white
        }

        dot1.textColor = dotColor
        dot2.textColor = dotColor
        dot3.textColor = dotColor
        self.backgroundColor = backgroundColor

        addSubview(dot1)
        addSubview(dot2)
        addSubview(dot3)

        NSLayoutConstraint.activate([
            dot1.centerYAnchor.constraint(equalTo: centerYAnchor),
            dot2.centerYAnchor.constraint(equalTo: centerYAnchor),
            dot3.centerYAnchor.constraint(equalTo: centerYAnchor),

            dot2.centerXAnchor.constraint(equalTo: centerXAnchor),
            dot1.trailingAnchor.constraint(equalTo: dot2.leadingAnchor, constant: -2),
            dot3.leadingAnchor.constraint(equalTo: dot2.trailingAnchor, constant: 2)
        ])
    }

    enum Work {
        case on
        case off
    }

    /// Запуск анимации.
    /// - Parameter work: вкл/выкл.
    func animationLoad(_ work: Work) {
        switch work {
        case .on:
            self.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0, options: [.repeat, .autoreverse]) {
                self.dot1.alpha = 0
            }
            UIView.animate(withDuration: 0.4, delay: 0.2, options: [.repeat, .autoreverse]) {
                self.dot2.alpha = 0
            }
            UIView.animate(withDuration: 0.4, delay: 0.4, options: [.repeat, .autoreverse]) {
                self.dot3.alpha = 0
            }
        case .off:
            self.isHidden = true
            self.dot1.layer.removeAllAnimations()
            self.dot2.layer.removeAllAnimations()
            self.dot3.layer.removeAllAnimations()
            self.dot1.alpha = 1
            self.dot2.alpha = 1
            self.dot3.alpha = 1
        }
    }
}
