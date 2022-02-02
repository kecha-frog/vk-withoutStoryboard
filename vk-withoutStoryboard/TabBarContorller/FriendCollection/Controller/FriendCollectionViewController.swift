//
//  FriendCollectionViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

class FriendCollectionViewController: UIViewController {
    private var dataUserImage:[ImageModel] = []
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10)
        viewLayout.itemSize = CGSize(width: 160, height: 160)
        viewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        collectionView.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: FriendCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupUI(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    func configure(title:String, dataImages : [ImageModel]){
        self.title = title
        dataUserImage = dataImages
    }
}

extension FriendCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataUserImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.identifier, for: indexPath) as! FriendCollectionViewCell
        cell.configure(dataUserImage[indexPath.item], index:indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension FriendCollectionViewController: FriendCollectionViewCellDelegate{
    func actionLikePhoto(_ like: Bool, indexPhoto: Int) {
        dataUserImage[indexPhoto].youLike.toggle()
        if like {
            dataUserImage[indexPhoto].like += 1
        }else if !like {
            dataUserImage[indexPhoto].like -= 1
        }
        collectionView.reloadItems(at: [IndexPath(item: indexPhoto, section: 0)])
    }
}

