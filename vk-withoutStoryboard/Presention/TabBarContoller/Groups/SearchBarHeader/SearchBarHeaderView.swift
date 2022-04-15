//
//  SearchBarHeaderTableView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 04.02.2022.
//

import UIKit


class SearchBarHeaderView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    var text: String? {
        searchBar.text
    }
    
    private let searchBar:UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Введите название группы"
        searchBar.searchTextField.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        searchBar.searchTextField.leftView = nil
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    enum Work{
        case on
        case off
    }
    
    func setDelegate(_ controller: UIViewController){
        searchBar.delegate = controller as? UISearchBarDelegate
    }
    
    func animation(_ work: Work){
        UIView.animate(withDuration: 1) {
            // MARK: Сделать анимацию
            self.searchBar.removeFromSuperview()
            self.frame.size.height = 0
            
        } completion: { result in
//            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
//            animation.duration = 0.5
//            animation.fillMode = .forwards
//            animation.fromValue = work == .on ? 0 : 1
//            animation.toValue = work == .on ? 1 : 0
//            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//            layer.add(animation, forKey: nil)
        }
    }
}
