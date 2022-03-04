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
    
    private var dataUserImage:[PhotoModelApi] = []
    private var friendId:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        fetchApiAsync { [weak self] in
            self?.update()
        }
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
    
    private func update(){
        collectionView.reloadData()
    }
    
    func configure(friendId : Int, title:String){
        self.title = title
        self.friendId = friendId
    }
    
    private func fetchApiAsync( completion: @escaping () -> Void){
        // лоадинг анимация на момент загрузки
        let viewLoad = LoadingView()
        viewLoad.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        ApiVK.standart.reguest(PhotoModelApi.self, method: .GET, path: .getPhotos, params: [
            "owner_id":String(self.friendId),
            "album_id": "profile",
            "count":"10",
            "extended":"1"
        ]) { [weak self] result in
            switch result {
            case .success(let success):
                self?.dataUserImage = success.items
                viewLoad.removeSelf(transitionTo: self!.collectionView)
                completion()
            case .failure(let error):
                print(error)
            }
            
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
        // позже восстанавлю 
//        dataUserImage[indexPhoto].youLike.toggle()
//        if like {
//            dataUserImage[indexPhoto].like += 1
//        }else if !like {
//            dataUserImage[indexPhoto].like -= 1
//        }
    }
}

