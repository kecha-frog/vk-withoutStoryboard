//
//  FriendCollectionViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

class FriendCollectionViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 9) / 2
        let spancing: CGFloat = 3
        viewLayout.sectionInset = UIEdgeInsets(top: 5, left: spancing, bottom: 5, right: spancing)
        viewLayout.itemSize = CGSize(width: width , height: width)
        viewLayout.minimumInteritemSpacing = spancing
        viewLayout.minimumLineSpacing = spancing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var dataUserImage:[ImageModel] = []
    private var friendId:Int16!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        fetchAPI()
        collectionView.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: FriendCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupUI(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
        ])
    }
    
    func configure(friendId : Int16, title:String){
        self.title = title
        let data = FriendStorageImage(friendId)
        dataUserImage = data.imagesDict
        self.friendId = friendId
    }
    
    // Запрос фото по ид страницы
    private func fetchAPI(){
        let api = fetchApiVK()
        api.reguest(method: .GET, path: .getPhotos, params: [
            "owner_id":String(friendId),
            "album_id": "profile",
            "count":"10",
            "extended":"1"
        ]){ data in
            print(data)
        }
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
    }
}
