//
//  FriendCollectionViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit
import RealmSwift

// MARK: Controller
/// Экран коллекции фото пользователя.
class FriendCollectionViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let viewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width: CGFloat = (UIScreen.main.bounds.width - 9) / 2
        let spancing: CGFloat = 3
        viewLayout.sectionInset = UIEdgeInsets(top: 5, left: spancing, bottom: 5, right: spancing)
        viewLayout.itemSize = CGSize(width: width , height: width)
        viewLayout.minimumInteritemSpacing = spancing
        viewLayout.minimumLineSpacing = spancing
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let viewLoad: LoadingView = {
        let view: LoadingView = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var service: FriendPhotosService?
    
    private var token: NotificationToken?
    
    /// Кэш для изображением
    ///
    ///  Кеш обнуляется при уходе с контроллера.
    private var cache: PhotoNSCache = PhotoNSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createNotificationToken()
        fetchApiAsync()
        collectionView.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: FriendCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    /// Настройка UI.
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
    
    /// Конфигурация сервисного слоя по  id.
    /// - Parameter friendId: Id друга.
    func configure(friendId : Int){
        service = FriendPhotosService(friendId: friendId)
        // получаем друга
        guard let service:FriendPhotosService = self.service, let friend = service.friend else { return }
        title = friend.firstName + " " + friend.lastName
    }
    
    /// Обновление данных коллекции.
    private func updateCollectionView(){
        collectionView.reloadData()
    }
    
    /// Запрос фото друга из api с анимацией загрузки.
    private func fetchApiAsync(){
        guard let service:FriendPhotosService = self.service else { return }
        
        viewLoad.animationLoad(.on)
        service.fetchApiAsync(){ [weak self] in
            guard let self: FriendCollectionViewController = self else { return }
            
            self.viewLoad.animationLoad(.off)
        }
    }
    
    /// Регистрирует блок, который будет вызываться при каждом изменении данных фото друга в бд.
    private func createNotificationToken(){
        guard let service:FriendPhotosService = self.service else { return }
        
        token = service.data.observe{ [weak self] result in
            guard let self: FriendCollectionViewController  = self  else { return }
            // второй способ обнавления
            switch result{
            case .initial:
                self.collectionView.reloadData()
            case .error(let error):
                print(error)
            default:
                self.collectionView.reloadSections(.init(integer: 0))
            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension FriendCollectionViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDataSource
extension FriendCollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let service:FriendPhotosService = self.service else { return 0 }
        
        return service.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let service:FriendPhotosService = self.service else { return UICollectionViewCell() }
        
        let cell: FriendCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.identifier, for: indexPath) as! FriendCollectionViewCell
        cell.configure(service.data[indexPath.item], cache: cache)
        cell.delegate = self
        return cell
    }
}

// MARK: Delegate
extension FriendCollectionViewController: FriendCollectionViewCellDelegate{
    // позже восстанавлю делегат
    func actionLikePhoto(_ like: Bool, indexPhoto: Int) {
        //        dataUserImage[indexPhoto].youLike.toggle()
        //        if like {
        //            dataUserImage[indexPhoto].like += 1
        //        }else if !like {
        //            dataUserImage[indexPhoto].like -= 1
        //        }
    }
}
