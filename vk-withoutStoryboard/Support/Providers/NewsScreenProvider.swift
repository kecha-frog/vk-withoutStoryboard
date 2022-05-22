//
//  NewsScreenProvider.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import Foundation

// MARK: - Enum
/// Возможные варианты данных новости.
enum PostType {
    case profile(NewsProfileModel, Date)
    case group(NewsGroupModel, Date)
    case photo([Attachment])
    case audio([Attachment])
    case video([Attachment])
    case other([Attachment])
    case text(String)
    case likeAndView(Likes, Views?, Comments)
}

/// Провайдер для NewsTableViewController.
final class NewsScreenProvider: ApiLayer {
    // MARK: - Public Properties
    /// Список новостей.
    var data: [[PostType]] = []

    // MARK: - Public Methods
    /// Получение данных.
    /// - Parameter completion: Замыкание.
    func fetchData(_ completion: @escaping () -> Void) {
        Task(priority: .background) {
            guard let response = await self.requestAsync() else { return }
            data = await self.getValidData(response)
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    // MARK: - Private Methods
    /// Запрос из api.
    private func requestAsync() async -> ResponseList<NewsPostModel>? {
        let result = await self.sendRequestList(endpoint: .getNews, responseModel: NewsPostModel.self)

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
        _ response: ResponseList<NewsPostModel>) async -> [[PostType]] {
            // Многопоточный парсинг данных.
            let profilesTask = Task<[Int: NewsProfileModel], Error> {
                return response.headerPost?.profiles?.reduce([Int: NewsProfileModel]()) { partialResult, profile in
                    var value = partialResult
                    value[profile.id] = profile
                    return value
                } ?? [:]
            }

            let groupsTask = Task<[Int: NewsGroupModel], Error> {
                return response.headerPost?.groups?.reduce([Int: NewsGroupModel]()) { partialResult, groups in
                    var value = partialResult
                    value[groups.id] = groups
                    return value
                } ?? [:]
            }

            do {
                let profiles: [Int: NewsProfileModel] = try await profilesTask.value
                let groups: [Int: NewsGroupModel] = try await groupsTask.value

                // Массив секций с новостями
                var validData: [[PostType]] = []

                response.items.forEach { news in
                    // Секция с новостью
                    var validNews: [PostType] = []

                    // Получаем профиль группы или юзера для хедера.
                    // Отправляем в секцию
                    if news.sourceId > 0,
                       let profile = profiles[news.sourceId] {
                        validNews.append(.profile(profile, news.date))
                    } else if
                        let group = groups[abs(news.sourceId)] {
                        validNews.append(.group(group, news.date))
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
                        validNews.append(.photo(photos))
                    }
                    if !audio.isEmpty {
                        validNews.append(.audio(audio))
                    }
                    if !video.isEmpty {
                        validNews.append(.video(video))
                    }
                    if !other.isEmpty {
                        validNews.append(.other(other))
                    }

                    // Добавляем текст новости в секцию
                    if news.text.isEmpty {
                        validNews.append(.text(news.text))
                    }

                    // Добавляем футер секции
                    validNews.append(.likeAndView(news.likes, news.views, news.comments))

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
