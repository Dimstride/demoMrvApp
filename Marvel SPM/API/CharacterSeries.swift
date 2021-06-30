// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let seriesResponse = try? newJSONDecoder().decode(SeriesResponse.self, from: jsonData)

import Foundation

// MARK: - SeriesResponse
struct SeriesResponse: Codable {
    let code: Int?
    let status, copyright, attributionText: String?
    let attributionHTML: String?
    let data: SeriesDataClass?
    let etag: String?
}

// MARK: - DataClass
struct SeriesDataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [SeriesResult]?
}

// MARK: - Result
struct SeriesResult: Codable {
    let id: Int?
    let title, resultDescription, resourceURI: String?
    let urls: [SeriesURLElement]?
    let startYear, endYear: Int?
    let rating, modified: String?
    let thumbnail: SeriesThumbnail?
    let comics: SeriesComics?
    let stories: SeriesStories?
    let events: SeriesComics?
    let characters, creators: SeriesCharacters?
    let next, previous: SeriesNext?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
        case resourceURI, urls, startYear, endYear, rating, modified, thumbnail, comics, stories, events, characters, creators, next, previous
    }
}

// MARK: - Characters
struct SeriesCharacters: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [SeriesCharactersItem]?
}

// MARK: - CharactersItem
struct SeriesCharactersItem: Codable {
    let resourceURI, name, role: String?
}

// MARK: - Comics
struct SeriesComics: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [SeriesNext]?
}

// MARK: - Next
struct SeriesNext: Codable {
    let resourceURI, name: String?
}

// MARK: - Stories
struct SeriesStories: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [SeriesStoriesItem]?
}

// MARK: - StoriesItem
struct SeriesStoriesItem: Codable {
    let resourceURI, name, type: String?
}

// MARK: - Thumbnail
struct SeriesThumbnail: Codable {
    let path, thumbnailExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct SeriesURLElement: Codable {
    let type, url: String?
}
