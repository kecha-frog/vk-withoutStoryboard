//
//  PostRepository.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 05.02.2022.
//

import Foundation


class PostStorage {
    let postsArray: [PostModel]
    init(){
        postsArray = [
            .init(
                authorId: 0,
                text: """
                        На трон села, на трон села!
                        Царь во дворца, царь во дворца!
                        Ходи то, делай сюда — царь во дворца!
                        На трон села, на трон села!
                        Царь во дворца, царь во дворца!
                        Ходи то, делай сюда — царь во дворца!
                        На трон села, на трон села!
                        Царь во дворца, царь во дворца!
                        Ходи то, делай сюда — царь во дворца!
                        """,
                imageName: "borat-4",
                like: Int.random(in: 0...50),
                youLike: Bool.random(),
                watch: Int.random(in: 0...100000)
            ),
            .init(
                authorId: 2,
                text: """
                        На трон села, на трон села!
                        Царь во дворца, царь во дворца!
                        Ходи то, делай сюда — царь во дворца!
                        """,
                imageName: "borat-4",
                like: Int.random(in: 0...50),
                youLike: Bool.random(),
                watch: Int.random(in: 0...100000)
            ),
            .init(
                authorId: 3,
                text: """
                        На трон села, на трон села!
                        Царь во дворца, царь во дворца!
                        Ходи то, делай сюда — царь во дворца!
                        На трон села, на трон села!
                        Царь во дворца, царь во дворца!
                        Ходи то, делай сюда — царь во дворца!
                        На трон села, на трон села!
                        Царь во дворца, царь во дворца!
                        Ходи то, делай сюда — царь во дворца!
                        """,
                imageName: "borat-4",
                like: Int.random(in: 0...50),
                youLike: Bool.random(),
                watch: Int.random(in: 0...100000)
            )
        ]
    }
}
