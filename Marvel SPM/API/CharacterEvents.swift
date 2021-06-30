import Foundation

// MARK: - EventsResponse
struct EventsResponse: Codable {
    let code: Int?
    let status, copyright, attributionText: String?
    let attributionHTML: String?
    let data: EventsDataClass?
    let etag: String?
}

// MARK: - DataClass
struct EventsDataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [EventsResult]?
}

// MARK: - Result
struct EventsResult: Codable {
    let id: Int?
    let title, resultDescription, resourceURI: String?
    let urls: [EventsURLElement]?
    let modified, start, end: String?
    let thumbnail: EventsThumbnail?
    let comics: EventsComics?
    let stories: EventsStories?
    let series: EventsComics?
    let characters, creators: EventsCharacters?
    let next, previous: Next?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
        case resourceURI, urls, modified, start, end, thumbnail, comics, stories, series, characters, creators, next, previous
    }
}

// MARK: - Characters
struct EventsCharacters: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [EventsCharactersItem]?
}

// MARK: - CharactersItem
struct EventsCharactersItem: Codable {
    let resourceURI, name, role: String?
}

// MARK: - Comics
struct EventsComics: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [Next]?
}

// MARK: - Next
struct Next: Codable {
    let resourceURI, name: String?
}

// MARK: - Stories
struct EventsStories: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [EventsStoriesItem]?
}

// MARK: - StoriesItem
struct EventsStoriesItem: Codable {
    let resourceURI, name, type: String?
}

// MARK: - Thumbnail
struct EventsThumbnail: Codable {
    let path, thumbnailExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct EventsURLElement: Codable {
    let type, url: String?
}
