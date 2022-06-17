//
//  Attachments.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 19.04.2022.
//

import Foundation
#warning("Расписать комментарии.")
struct Attachment: Decodable {
    let type: String
    let photo: RLMPhoto?
    let audio: Audio?
    let video: Video?

    enum CodingKeys: String, CodingKey {
        case type
        case photo
        case audio
        case video
    }
}

#warning("Исправить на полноценный ответ.")
struct Video: Decodable {
    let type: String

    enum CodingKeys: String, CodingKey {
        case type
    }
}

struct Audio: Codable {
    let artist: String
    let id: Int
    let ownerId: Int
    let title: String
    let duration: Int
    let isExplicit: Bool
    let isFocusTrack: Bool
    let trackCode: String
    let url: String
    let date: Int
    let mainArtists: [MainArtist]?
    let shortVideosAllowed: Bool
    let storiesAllowed: Bool
    let storiesCoverAllowed: Bool

    enum CodingKeys: String, CodingKey {
        case artist
        case id
        case ownerId = "owner_id"
        case title
        case duration
        case isExplicit = "is_explicit"
        case isFocusTrack = "is_focus_track"
        case trackCode = "track_code"
        case url
        case date
        case mainArtists = "main_artists"
        case shortVideosAllowed = "short_videos_allowed"
        case storiesAllowed = "stories_allowed"
        case storiesCoverAllowed = "stories_cover_allowed"
    }
}

struct MainArtist: Codable {
    let name: String
    let domain: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name
        case domain
        case id
    }
}
