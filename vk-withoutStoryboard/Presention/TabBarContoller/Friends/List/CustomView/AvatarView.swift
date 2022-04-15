//
//  AvatarView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.02.2022.
//

import UIKit

/// View аватар друга.
class AvatarView: UIView {
    private var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Настройка UI.
    private func setupUI(){
        addSubview(imageView)
        
        // Обрезание изображения за пределами слоя
        imageView.clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        // Кастомизация аватарки
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
    }
    
    /// Размер слоя для обрезания изображения.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = frame.size.width / 2
        layer.cornerRadius = radius
        imageView.layer.cornerRadius = radius
        imageView.frame = bounds
    }
    
    /// Сброс текста при Reuse.
    func prepareForReuse(){
        imageView.image = nil
    }
    
    /// Получение изображения по url.
    /// - Parameter url: Адрес изображения.
    ///
    /// Включено повтороное получение изображение из кэша пока приложение не перезапустилось.
    func loadData(_ url: String){
        LoaderImage.standart.load(url: url, cache:.on) { [weak self ] image in
            self?.imageView.image = image
        }
    }
    
    /// Добавление действия на тап по аватару.
    private func addGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAnimation))
        imageView.addGestureRecognizer(tap)
    }
    
    /// Анимация аватара.
    @objc private func clickAnimation(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0.7, options: [.autoreverse,], animations: {
            self.transform = CGAffineTransform(translationX: 1, y: 0)
        }){_ in
            self.transform = .identity
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0.7, options: [.autoreverse,], animations: {
                self.transform = CGAffineTransform(translationX: -1, y: 0)
            }){_ in
                self.transform = .identity
            }
        }
        
    }
}
