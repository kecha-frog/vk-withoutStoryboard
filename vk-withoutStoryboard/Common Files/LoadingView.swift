//
//  LoadingView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 07.02.2022.
//

import UIKit

/// вью загрузки
class LoadingView: UIView{
    private let dot1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "●"
        label.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        return label
    }()
    
    private let dot2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "●"
        label.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        return label
    }()
    
    private let dot3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "●"
        label.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        animation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// изменение вью на цвет лаунч скрина
    func changeToStartPageColor(){
        let dotColor: UIColor = .white
        dot1.textColor = dotColor
        dot2.textColor = dotColor
        dot3.textColor = dotColor
        backgroundColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
    }
    
    /// настройка вью
    private func setupUI(){
        backgroundColor = .white
        addSubview(dot1)
        addSubview(dot2)
        addSubview(dot3)
        NSLayoutConstraint.activate([
            dot1.centerYAnchor.constraint(equalTo: centerYAnchor),
            dot2.centerYAnchor.constraint(equalTo: centerYAnchor),
            dot3.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dot2.centerXAnchor.constraint(equalTo: centerXAnchor),
            dot1.trailingAnchor.constraint(equalTo: dot2.leadingAnchor, constant: -2),
            dot3.leadingAnchor.constraint(equalTo: dot2.trailingAnchor, constant: 2),
        ])
    }
    
    /// запуска анимации
    private func animation(){
        UIView.animate(withDuration: 0.4, delay: 0, options: [.repeat,.autoreverse]) {
            self.dot1.alpha = 0
        }
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.repeat,.autoreverse]) {
            self.dot2.alpha = 0
        }
        UIView.animate(withDuration: 0.4, delay: 0.4, options: [.repeat,.autoreverse]) {
            self.dot3.alpha = 0
        }
    }
    
    /// удаление вью у супер вью и смена к выбранному вью
    /// - Parameter transitionTo: вью на который сменится
    func removeSelfAnimation(transitionTo: UIView){
        UIView.transition(from: self, to: transitionTo, duration: 0.33, options: .transitionCrossDissolve) { _ in
            self.removeFromSuperview()
        }
    }
}
