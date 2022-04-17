//
//  SearchBarHeaderView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 04.02.2022.
//

import UIKit

extension SearchBarHeaderView {
    enum Work{
        case on
        case off
        
        /// Переключатель
        mutating func toggle(){
            self = self == .on ? .off : .on
        }
    }
}

/// Static  header  searchBar.
///
/// Два вида установки:
/// - скрытая строка поиска с функцией анимации появления и исчезанию.
/// - постоянная.
class SearchBarHeaderView: UIView{
    private let searchBar:UISearchBar = {
        let searchbar: UISearchBar = UISearchBar()
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    
    /// Значение которое сейчас введено в поисковой строке.
    var text: String? {
        searchBar.text
    }
    
    /// Переключатель режима.
    lazy var isOpen: Work = .off
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Настройка UI.
    private func setupUI() {
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Введите название группы"
        searchBar.searchTextField.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        searchBar.searchTextField.leftView = nil
        
        self.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    /// Delegate поисковой строки.
    /// - Parameter controller: контроллер на котором  searchBar.
    func setDelegate(_ controller: UIViewController){
        searchBar.delegate = controller as? UISearchBarDelegate
    }
    
    /// Задать начальную высоту.
    /// - Parameter height: Высота поисковой строки.
    func setHeightConstraint(_ height: CGFloat) {
        heightConstraint = NSLayoutConstraint(item: self,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: height)
        addConstraint(heightConstraint!)
        
        // Если начальная высота 0, значит он будет скрытый.
        if height == 0 {
            searchBar.alpha = 0
        }
    }
    
    /// Появление/Исчезание  поисковой строки.
    func switchSearchBar(){
        switch isOpen {
        case .off:
            // изменяется высота и пересчитываются сonstraint
            self.heightConstraint?.constant = 40
            self.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn)  {
                // появление
                self.searchBar.alpha = 1
            }
        case .on:
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn)  {
                // исчезание
                self.searchBar.alpha = 0
            } completion: { result in
                // изменяется высота и пересчитываются сonstraint
                self.heightConstraint?.constant = 0
                self.layoutIfNeeded()
            }
        }
        
        self.isOpen.toggle()
    }
}
