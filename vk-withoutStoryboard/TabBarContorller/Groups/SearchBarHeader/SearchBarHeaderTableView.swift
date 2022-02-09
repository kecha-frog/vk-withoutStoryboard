//
//  SearchBarHeaderTableView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 04.02.2022.
//

import UIKit


class SearchBarHeaderTableView: UISearchBar{
    override init(frame: CGRect) {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        backgroundImage = UIImage()
        placeholder = "Введите название группы"
        searchTextField.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        searchTextField.leftView = nil
    }
    
    func animation(_ on: Bool){
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.duration = 0.5
        animation.fillMode = .forwards
        animation.fromValue = on ? 0 : 1
        animation.toValue = on ? 1 : 0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: nil)
    }
}
