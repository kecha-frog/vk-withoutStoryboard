//
//  FriendCollectionViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import RealmSwift
import UIKit

/// Экран коллекции фото пользователя.
final class FriendCollectionViewController: UIViewController {
    // MARK: - Private Properties
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let width: CGFloat = (UIScreen.main.bounds.width - 9) / 2
        let spancing: CGFloat = 3
        viewLayout.sectionInset = UIEdgeInsets(top: 5, left: spancing, bottom: 5, right: spancing)
        viewLayout.itemSize = CGSize(width: width, height: width)
        viewLayout.minimumInteritemSpacing = spancing
        viewLayout.minimumLineSpacing = spancing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var provider: FriendPhotosScreenProvider?

    private var token: NotificationToken?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPhotos()
        createNotificationToken()
        collectionView.register(
            FriendCollectionViewCell.self,
            forCellWithReuseIdentifier: FriendCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - Setting UI Method
    /// Настройка UI.
    private func setupUI() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Public Methods
    /// Конфигурация сервисного слоя по  id.
    /// - Parameter friendId: Id друга.
    func configure(friendId: Int) {
        provider = FriendPhotosScreenProvider(friendId: friendId)
        title = provider?.fullNameFriend
    }

    // MARK: - Private Methods
    /// Запрос фото друга из api с анимацией загрузки.
    private func fetchPhotos() {
        guard let provider: FriendPhotosScreenProvider = self.provider else { return }

        provider.fetchData(loadingView)
    }

    /// Регистрирует блок, который будет вызываться при каждом изменении данных фото друга в бд.
    private func createNotificationToken() {
        guard let service: FriendPhotosScreenProvider = self.provider else { return }

        token = service.data.observe { [weak self] result in
            guard let self: FriendCollectionViewController = self  else { return }
            // второй способ обнавления
            switch result {
            case .initial:
                break
            case .error(let error):
                print(error)
            case .update(_, deletions: _, insertions: _, modifications: _):
                self.collectionView.reloadSections(.init(integer: 0))
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FriendCollectionViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource
extension FriendCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let service: FriendPhotosScreenProvider = self.provider else { return 0 }

        return service.data.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let service: FriendPhotosScreenProvider = self.provider else { return UICollectionViewCell() }

        guard let cell: FriendCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FriendCollectionViewCell.identifier,
            for: indexPath
        ) as? FriendCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(service.data[indexPath.item])
        cell.delegate = self
        return cell
    }
}

// MARK: - FriendCollectionViewCellDelegate
extension FriendCollectionViewController: FriendCollectionViewCellDelegate {
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
