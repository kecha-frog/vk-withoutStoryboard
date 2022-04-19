//
//  NewsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import Foundation

/// Возможные варианты данных новости.
enum postType{
    case profile(NewsProfileModel, Date)
    case group(NewsGroupModel, Date)
    case photo([Attachment])
    case audio([Attachment])
    case video([Attachment])
    case other([Attachment])
    case text(String)
    case likeAndView(Likes, Views?, Comments)
}

/// Сервисный слой для NewsTableViewController.
class NewsService {
    
    /// Список новостей.
    var data: [[postType]] = []
    
    /// Запрос из api новостей.
    /// - Parameter completion: Замыкание.
    func fetchApiAsync(_ completion: @escaping ()-> Void){
        ApiVK.standart.reguest(PostModel.self, method: .POST, path: .getNews, params: ["filters": "post"]) { result in
            switch result {
            case .success(let response):
                // Преобразовываем данные с новостями для работы с таблицей.
                self.getValidDate(response)
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    /// Преобразование данных для работы с таблицей.
    /// - Parameter response: Ответ сервера с вспомогательными данными.
    ///
    ///  Собирает данные для секции новости.
    private func getValidDate(_ response: JSONResponse<PostModel>){
        // Массив секций с новостями
        var validData:[[postType]] = []
        
        response.items.forEach { news in
            // Секция с новостью
            var validNews: [postType] = []
            
            // Получаем профиль группы или юзера для хедера.
            // Отправляем в секцию
            if news.sourceId > 0,
               let profile = response.profiles?.first(where: { $0.id == news.sourceId}) {
                validNews.append(.profile(profile, news.date))
            }else if
                let group = response.groups?.first(where: { $0.id == abs(news.sourceId)}) {
                validNews.append(.group(group, news.date))
            }
            
            // Контент новости
            var photos: [Attachment] = []
            var audio: [Attachment] = []
            var video: [Attachment] = []
            var other: [Attachment] = []
            // Сортируем контент и добавляем
            news.attachments?.forEach{ content in
                if content.type == "photo" {
                    photos.append(content)
                }else if content.type == "audio" {
                    audio.append(content)
                }else if content.type == "video" {
                    video.append(content)
                }else{
                    other.append(content)
                }
            }
            
            // Добавляем контент новости в секцию
            if !photos.isEmpty{
                validNews.append(.photo(photos))
            }
            if !audio.isEmpty{
                validNews.append(.audio(audio))
            }
            if !video.isEmpty{
                validNews.append(.video(video))
            }
            if !other.isEmpty{
                validNews.append(.other(other))
            }
            
            // Добавляем текст новости в секцию
            if news.text != ""{
                validNews.append(.text(news.text))
            }
            
            // Добавляем футер секции
            validNews.append(.likeAndView(news.likes, news.views, news.comments))
            
            // Добавляем полученную секцию в список
            validData.append(validNews)
        }
        
        self.data = validData
    }
}
