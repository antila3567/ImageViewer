//
//  Post.swift
//  ImageViewer
//
//  Created by Иван Легенький on 26.12.2023.
//

import SwiftUI

struct Post: Identifiable {
    let id: UUID = .init()
    var userName: String
    var content: String
    var pics: [PicItem]
    var scrollPosition: UUID?
}


var samplePosts: [Post] = [
    .init(userName: "Peter", content: "Some pics", pics: pics),
    .init(userName: "Janifer", content: "New photos", pics: pics1),
]

private var pics: [PicItem] = (1...5).compactMap { index -> PicItem? in
    return .init(image: "Pic \(index)")
}

private var pics1: [PicItem] = (1...5).reversed().compactMap { index -> PicItem? in
    return .init(image: "Pic \(index)")
}

