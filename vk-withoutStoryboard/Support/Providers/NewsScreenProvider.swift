//
//  NewsScreenProvider.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import Foundation

extension NewsScreenProvider {
    // MARK: - Enum
    /// Возможные варианты данных новости.
    enum PostConstructor {
        case profile(NewsProfileModel)
        case group(NewsGroupModel)
        case photo([Attachment])
        case audio([Attachment])
        case video([Attachment])
        case other([Attachment])
        case text(String)
        case likeAndView(Likes, Views?, Comments)
    }

    // Точка старта новости
    enum Start {
        case time
        case from
    }

    // Ячейка
    struct PostCell {
        let date: Double
        var constructor: [PostConstructor] = []
        var isExpended = false
    }
}

/// Провайдер для NewsTableViewController.
final class NewsScreenProvider: ApiLayer {
    // MARK: - Public Properties
    /// Список новостей.
    var data: [PostCell] = []

    /// Происходит ли в данный момент загрузка.
    var isLoading = false

    // MARK: - Private Properties
    // Для получения следующей страницы результатов
    private var nextFrom: String?

    // Определяем время самой свежей новости или берем текущее время
    private var lastNewsDate: Double {
        data.first?.date ?? Date().timeIntervalSince1970
    }

    // MARK: - Public Methods
    /// Получение данных.
    /// - Parameter completion: Замыкание.
    func fetchData(_ completion: @escaping () -> Void) {
        isLoading = true
        Task(priority: .background) {
            guard let response = await self.requestAsync(start: .none) else { return }

            nextFrom = response.helper?.nextFrom

            data = await self.getValidData(response)

            DispatchQueue.main.async {
                self.isLoading = false
                completion()
            }
        }
    }

    /// Получение данных по времени
    /// - Parameter time: Получение старых или новых новосте.
    /// - Parameter completion: Замыкание. Передает индексы для обновления таблицы.
    func fetchTimeData(
        time: Start,
        _ completion: @escaping (_ sectionUpdate: IndexSet? ) -> Void
    ) {
        Task(priority: .background) {
            isLoading = true
            let response: ResponseList<NewsPostModel>?

            switch time {
            case .time:
                response = await self.requestAsync(start: .time(String(lastNewsDate + 1)))
            case .from:
                response = await self.requestAsync(start: .from(nextFrom ?? ""))
            }

            let indexSet: IndexSet?

            if let response = response, !response.items.isEmpty {
                nextFrom = response.helper?.nextFrom

                let validNews = await self.getValidData(response)
                switch time {
                case .time:
                    // прикрепляем их в начало отображаемого массива
                    self.data = validNews + self.data
                    indexSet = IndexSet(integersIn: 0..<response.items.count)
                case .from:
                    indexSet = IndexSet(integersIn: self.data.count..<self.data.count + response.items.count)
                    self.data += validNews
                }
            } else {
                indexSet = nil
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
                completion(indexSet)
            }
        }
    }
    
    // MARK: - Private Methods
    /// Запрос из api.
    /// - Parameter start: От какого места надо получить список новостей
    private func requestAsync(start: StartNewsRequest) async -> ResponseList<NewsPostModel>? {
            let result = await self.sendRequestList(
                endpoint: .getNews(start),
                responseModel: NewsPostModel.self)
            
            switch result {
            case .success(let result):
                return result
            case .failure(let error):
                print(error)
                return nil
            }
        }
    
    /// Преобразование данных для работы с таблицей.
    /// - Parameter response: Ответ сервера с вспомогательными данными.
    ///
    ///  Собирает данные для секции новости.
    private func getValidData(
        _ response: ResponseList<NewsPostModel>) async -> [PostCell] {
            // Многопоточный парсинг данных.
            let profilesTask = Task<[Int: NewsProfileModel], Error> {
                return response.helper?.profiles?.reduce([Int: NewsProfileModel]()) { partialResult, profile in
                    var value = partialResult
                    value[profile.id] = profile
                    return value
                } ?? [:]
            }
            
            let groupsTask = Task<[Int: NewsGroupModel], Error> {
                return response.helper?.groups?.reduce([Int: NewsGroupModel]()) { partialResult, groups in
                    var value = partialResult
                    value[groups.id] = groups
                    return value
                } ?? [:]
            }
            
            do {
                let profiles: [Int: NewsProfileModel] = try await profilesTask.value
                let groups: [Int: NewsGroupModel] = try await groupsTask.value
                
                // Массив секций с новостями
                var validData: [PostCell] = []
                
                response.items.forEach { news in
                    // Секция с новостью
                    var validNews = PostCell(date: news.date)
                    
                    // Получаем профиль группы или юзера для хедера.
                    // Отправляем в секцию
                    if news.sourceId > 0,
                       let profile = profiles[news.sourceId] {
                        validNews.constructor.append(.profile(profile))
                    } else if
                        let group = groups[abs(news.sourceId)] {
                        validNews.constructor.append(.group(group))
                    }
                    
                    // Контент новости
                    var photos: [Attachment] = []
                    var audio: [Attachment] = []
                    var video: [Attachment] = []
                    var other: [Attachment] = []
                    // Сортируем контент и добавляем
                    news.attachments?.forEach { content in
                        if content.type == "photo" {
                            photos.append(content)
                        } else if content.type == "audio" {
                            audio.append(content)
                        } else if content.type == "video" {
                            video.append(content)
                        } else {
                            other.append(content)
                        }
                    }
                    
                    // Добавляем контент новости в секцию
                    if !photos.isEmpty {
                        validNews.constructor.append(.photo(photos))
                    }
                    if !audio.isEmpty {
                        validNews.constructor.append(.audio(audio))
                    }
                    if !video.isEmpty {
                        validNews.constructor.append(.video(video))
                    }
                    if !other.isEmpty {
                        validNews.constructor.append(.other(other))
                    }
                    
                    // Добавляем текст новости в секцию
                    if !news.text.isEmpty {
                        validNews.constructor.append(.text(news.text))
                    }
                    
                    // Добавляем футер секции
                    validNews.constructor.append(.likeAndView(news.likes, news.views, news.comments))
                    
                    // Добавляем полученную секцию в список
                    validData.append(validNews)
                }
                return validData
            } catch {
                print(error)
            }
            
            return []
        }
}
