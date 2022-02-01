//
//  AvatarView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.02.2022.
//

import UIKit

class AvatarView: UIView {
    var imageView: UIImageView = {
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
    
    func setupUI(){
        addSubview(imageView)
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        imageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = bounds
        let radius = frame.size.width / 2
        self.layer.cornerRadius = radius
        imageView.layer.cornerRadius = radius
    }
    
    func setImage(_ imageName: String){
        self.imageView.image = UIImage(named: imageName)
    }
}
