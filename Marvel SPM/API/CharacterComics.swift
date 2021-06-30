import Foundation
import Alamofire

class CharacterClient {
    
    private let publicKey = secPublicKey
    private let privateKey = secPrivateKey
    private let baseUrl = "https://gateway.marvel.com"
    //private let charactersPath = "/v1/public/characters"
    
    private lazy var timestamp: Int = {
        return Int(Date().timeIntervalSince1970)
    }()
    
    // Hash API Marvel
    // (e.g. md5(ts+privateKey+publicKey)
    
    private lazy var hash: String = {
        return md5Hash("\(timestamp)\(privateKey)\(publicKey)")
    }()
    
    //func getCharacters(completion: @escaping (CharacterResponse) -> Void){ // For scaping results (old)
    func getComics(offset: Int, charId: Int, completion: @escaping (Result<ComicsResponse, NetworkError>) -> Void){
        let charactersPath = "/v1/public/characters/\(charId)/comics"
        //print(charactersPath)
        AF.request(
            "\(baseUrl)\(charactersPath)",
            method: .get,
            parameters: [
                "apikey": publicKey,
                "hash": hash,
                "ts": timestamp,
                "limit": 20,
                "offset": offset
            ]
        ).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
            guard AFdata.error == nil else {
                //print("Error: \(AFdata.error?.localizedDescription ?? "")")
                completion(.failure(.serverError("Error: \(AFdata.error?.localizedDescription ?? "")")))
                return
            }
            guard let secureData = AFdata.data else {
                //print("Error in guarding data")
                completion(.failure(.dataError("Error in guarding data")))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(ComicsResponse.self, from: secureData)
                //print(json.data?.results?[0])
                //completion(json) // Scaping results
                completion(.success(json))
            } catch {
                //print("Error: \(error)")
                completion(.failure(.serializationError("Error: \(error)")))
                return
            }
        }
    }
    
    func getSeries(offset: Int, charId: Int, completion: @escaping (Result<SeriesResponse, NetworkError>) -> Void){
        let charactersPath = "/v1/public/characters/\(charId)/series"
        //print(charactersPath)
        AF.request(
            "\(baseUrl)\(charactersPath)",
            method: .get,
            parameters: [
                "apikey": publicKey,
                "hash": hash,
                "ts": timestamp,
                "limit": 20,
                "offset": offset
            ]
        ).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
            guard AFdata.error == nil else {
                //print("Error: \(AFdata.error?.localizedDescription ?? "")")
                completion(.failure(.serverError("Error: \(AFdata.error?.localizedDescription ?? "")")))
                return
            }
            guard let secureData = AFdata.data else {
                //print("Error in guarding data")
                completion(.failure(.dataError("Error in guarding data")))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(SeriesResponse.self, from: secureData)
                //print(json.data?.results?[0])
                //completion(json) // Scaping results
                completion(.success(json))
            } catch {
                //print("Error: \(error)")
                completion(.failure(.serializationError("Error: \(error)")))
                return
            }
        }
    }
    
    func getEvents(offset: Int, charId: Int, completion: @escaping (Result<EventsResponse, NetworkError>) -> Void){
        let charactersPath = "/v1/public/characters/\(charId)/events"
        //print(charactersPath)
        AF.request(
            "\(baseUrl)\(charactersPath)",
            method: .get,
            parameters: [
                "apikey": publicKey,
                "hash": hash,
                "ts": timestamp,
                "limit": 20,
                "offset": offset
            ]
        ).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
            guard AFdata.error == nil else {
                //print("Error: \(AFdata.error?.localizedDescription ?? "")")
                completion(.failure(.serverError("Error: \(AFdata.error?.localizedDescription ?? "")")))
                return
            }
            guard let secureData = AFdata.data else {
                //print("Error in guarding data")
                completion(.failure(.dataError("Error in guarding data")))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(EventsResponse.self, from: secureData)
                //print(json.data?.results?[0])
                //completion(json) // Scaping results
                completion(.success(json))
            } catch {
                //print("Error: \(error)")
                completion(.failure(.serializationError("Error: \(error)")))
                return
            }
        }
    }
}

// MARK: - ComicsResponse
struct ComicsResponse: Codable {
    let code: Int?
    let status, copyright, attributionText: String?
    let attributionHTML: String?
    let data: comiscData?
    let etag: String?
}

// MARK: - DataClass
struct comiscData: Codable {
    let offset, limit, total, count: Int?
    let results: [ComicsResult]?
}

// MARK: - Result
struct ComicsResult: Codable {
    let id, digitalID: Int?
    let title: String?
    let issueNumber: Double?
    let variantDescription, resultDescription, modified, isbn: String?
    let upc, diamondCode, ean, issn: String?
    let format: String?
    let pageCount: Int?
    let textObjects: [TextObject]?
    let resourceURI: String?
    let urls: [URLElement]?
    let series: ComicsSeries?
    let variants, collections, collectedIssues: [Series]?
    let dates: [DateElement]?
    let prices: [Price]?
    let thumbnail: ComicsThumbnail?
    let images: [Thumbnail]?
    let creators, characters: Characters?
    let stories: ComicsStories?
    let events: ComicsEvents?
    
    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, issueNumber, variantDescription
        case resultDescription = "description"
        case modified, isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects, resourceURI, urls, series, variants, collections, collectedIssues, dates, prices, thumbnail, images, creators, characters, stories, events
    }
}

// MARK: - Characters
struct Characters: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [CharactersItem]?
}

// MARK: - CharactersItem
struct CharactersItem: Codable {
    let resourceURI, name, role: String?
}

// MARK: - Series
struct ComicsSeries: Codable {
    let resourceURI, name: String?
}

// MARK: - DateElement
struct DateElement: Codable {
    let type, date: String?
}

// MARK: - Events
struct ComicsEvents: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [Series]?
}

// MARK: - Thumbnail
struct ComicsThumbnail: Codable {
    let path, thumbnailExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - Price
struct Price: Codable {
    let type: String?
    let price: Float?
}

// MARK: - Stories
struct ComicsStories: Codable {
    let available, returned: Int?
    let collectionURI: String?
    let items: [StoriesItem]?
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI, name, type: String?
}

// MARK: - TextObject
struct TextObject: Codable {
    let type, language, text: String?
}

// MARK: - URLElement
struct URLElement: Codable {
    let type, url: String?
}
