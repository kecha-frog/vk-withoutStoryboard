//
//  AvatarView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.02.2022.
//

import UIKit

class AvatarView: UIView {
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(imageView)
        imageView.clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let radius = frame.size.width / 2
        layer.cornerRadius = radius
        imageView.layer.cornerRadius = radius
        imageView.frame = bounds
    }
    
    func setImage(_ imageName: String){
        imageView.image = UIImage(named: imageName)
    }
}
