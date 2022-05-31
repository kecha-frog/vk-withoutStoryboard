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
    func fetchDataAsync() async throws {
        isLoading = true
        let response = try await self.requestAsync(start: .none)

        nextFrom = response.helper?.nextFrom

        data = try await self.getValidDataAsync(response)
        self.isLoading = false
    }

    /// Получение данных по времени
    /// - Parameter time: Получение старых или новых новосте.
    func fetchTimeDataAsync(time: Start) async throws -> IndexSet {
        isLoading = true
        let response: ResponseList<NewsPostModel>

        switch time {
        case .time:
            response = try await self.requestAsync(start: .time(String(lastNewsDate + 1)))
        case .from:
            response = try await self.requestAsync(start: .from(nextFrom ?? ""))
        }
        nextFrom = response.helper?.nextFrom
        let validNews = try await self.getValidDataAsync(response)

        let indexSet: IndexSet

        switch time {
        case .time:
            // прикрепляем их в начало отображаемого массива
            self.data = validNews + self.data
            indexSet = IndexSet(integersIn: 0..<response.items.count)
        case .from:
            indexSet = IndexSet(integersIn: self.data.count..<self.data.count + response.items.count)
            self.data += validNews
        }

        self.isLoading = false
        return indexSet
    }
    
    // MARK: - Private Methods
    /// Запрос из api.
    /// - Parameter start: От какого места надо получить список новостей
    private func requestAsync(start: StartNewsRequest) async throws -> ResponseList<NewsPostModel> {
        let result = await self.sendRequestList(
            endpoint: .getNews(start),
            responseModel: NewsPostModel.self)

        switch result {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }
    
    /// Преобразование данных для работы с таблицей.
    /// - Parameter response: Ответ сервера с вспомогательными данными.
    ///
    ///  Собирает данные для секции новости.
    private func getValidDataAsync(
        _ response: ResponseList<NewsPostModel>
    ) async throws -> [PostCell] {
        // Многопоточный парсинг данных.
        let profilesTask = Task<[Int: NewsProfileModel], Error>(priority: .background) {
            return response.helper?.profiles?.reduce([Int: NewsProfileModel]()) { partialResult, profile in
                var value = partialResult
                value[profile.id] = profile
                return value
            } ?? [:]
        }

        let groupsTask = Task<[Int: NewsGroupModel], Error>(priority: .background) {
            return response.helper?.groups?.reduce([Int: NewsGroupModel]()) { partialResult, groups in
                var value = partialResult
                value[groups.id] = groups
                return value
            } ?? [:]
        }

        let profiles: [Int: NewsProfileModel] = try await profilesTask.value
        let groups: [Int: NewsGroupModel] = try await groupsTask.value

        var array: [PostCell] = []

        try await withThrowingTaskGroup(of: PostCell.self) { group in
            response.items.forEach { news in
                group.addTask {
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
                    return validNews
                }
            }

            for try await postCell in group {
                array.append(postCell)
            }
        }

        return array
    }
}
