- удалить storyboard
- удалить из Main Interface "Main"
- удалить из Info.plist storyBoard

- прописать в scene (файл SceneDelegate)
```
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    window?.rootViewController = LoginViewController()
    window?.makeKeyAndVisible()
```

коментария, правильные названия, явная типизация
