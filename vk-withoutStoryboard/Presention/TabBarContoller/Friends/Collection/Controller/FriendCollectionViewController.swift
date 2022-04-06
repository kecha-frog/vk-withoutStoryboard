//
//  FriendCollectionViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit
import RealmSwift

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
    private let viewLoad: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var friend:FriendModel?
    
    /// пришлось вводить такую переменную, так как при первой загрузке данных в бд была ошибка "Invalid update: invalid number of items on UICollectionView"
    private var numberOfItems:Int = 0
    private var realmCacheService = RealmCacheService()
    private var service: FriendsCollectionService?
    private var dataUserImage: Results<PhotoModel>{
        self.realmCacheService.read(PhotoModel.self).filter("owner == %@", friend)
    }
    private var token: NotificationToken?
    private var cache = PhotoCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        createNotificationToken()
        fetchApiAsync()
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
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func update(){
        collectionView.reloadData()
    }
    
    func configure(friendId : Int){
        // получаем друга
        self.realmCacheService.read(FriendModel.self, key: friendId) { result in
            switch result{
            case .success(let friend):
                self.friend = friend
                self.service = FriendsCollectionService(friend: friend)
                self.title = friend.firstName + " " + friend.lastName
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    
    private func fetchApiAsync(){
        viewLoad.animationLoad(.on)
        service?.fetchApiAsync(){ [weak self] in
            self?.viewLoad.animationLoad(.off)
        }
    }
    
    private func createNotificationToken(){
        token = dataUserImage.observe{ [weak self] result in
            guard let self = self  else { return }
            switch result{
            case .initial(_):
                self.numberOfItems = self.dataUserImage.count
                self.collectionView.reloadData()
            case .update(_,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
                let deletionsIndexPath = deletions.map { IndexPath(item: $0, section: 0) }
                let insertionsIndexPath = insertions.map { IndexPath(item: $0, section: 0) }
                let modificationsIndexPath = modifications.map { IndexPath(item: $0, section: 0) }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self  else { return }
                    self.collectionView.performBatchUpdates {
                        self.collectionView.reloadItems(at: modificationsIndexPath)
                        self.numberOfItems -= deletions.count
                        self.collectionView.deleteItems(at: deletionsIndexPath)
                        self.numberOfItems += insertions.count
                        self.collectionView.insertItems(at: insertionsIndexPath)
                    }
                }
            case .error(let error):
                debugPrint(error)
            }
        }
    }
}

extension FriendCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.identifier, for: indexPath) as! FriendCollectionViewCell
        cell.configure(dataUserImage[indexPath.item], index:indexPath.item, cache: cache)
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
