//
//  DateFormaterHelper.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 22.05.2022.
//

import Foundation

class DateFormaterHelper {
    // MARK: - Private Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    private var dateTextCache: [Double: String] = [:]

    // MARK: - Static Properties
    static var shared = DateFormaterHelper()

    private init() {}

    // MARK: - Public Methods
    func convert(_ date: Double) -> String {
        if let dateResult = dateTextCache[date] {
            return dateResult
        } else {
            let dateTime = Date(timeIntervalSince1970: date)
            let stringDate = dateFormatter.string(from: dateTime)
            dateTextCache[date] = stringDate
            return stringDate
        }
    }
}
