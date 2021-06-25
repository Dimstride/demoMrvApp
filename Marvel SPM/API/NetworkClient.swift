import Foundation
import Alamofire

class NetworkClient {
    
    private let publicKey = secPublicKey
    private let privateKey = secPrivateKey
    private let baseUrl = "https://gateway.marvel.com"
    private let charactersPath = "/v1/public/characters"
    
    private lazy var timestamp: Int = {
        return Int(Date().timeIntervalSince1970)
    }()
    
    // Hash API Marvel
    // (e.g. md5(ts+privateKey+publicKey)
    
    private lazy var hash: String = {
        return md5Hash("\(timestamp)\(privateKey)\(publicKey)")
    }()
    
    //func getCharacters(completion: @escaping (CharacterResponse) -> Void){ // For scaping results (old)
    func getCharacters(offset: Int, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void){
        print(offset)
        AF.request(
            "\(baseUrl)\(charactersPath)",
            method: .get,
            parameters: [
                "apikey": publicKey,
                "hash": hash,
                "ts": timestamp,
                "limit": 10,
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
                let json = try JSONDecoder().decode(CharacterResponse.self, from: secureData)
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

enum NetworkError: Error, LocalizedError {
    case serverError(String)
    case dataError(String)
    case serializationError(String)
    
    public var errorDescription: String? {
        switch self {
        case .serverError(let description):
            return description
        case .dataError(let description):
            return description
        case .serializationError(let description):
            return description
        }
    }
}

struct CharacterResponse: Codable {
    var code: Int?
    var status: String?
    var copyright: String?
    var attributionText: String?
    var attributionHTML: String?
    var data: CharacterData?
    var etag: String?
}

struct CharacterData: Codable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [CharacterResult]?
}

struct CharacterResult: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var modified: String?
    var resourceURI: String?
    var urls: [CharacterUrl]?
    var thumbnail: Thumbnail?
    var comics: Comics?
    var stories: Stories?
    var events: Events?
    var series: Series?
}

struct CharacterUrl: Codable {
    var type: String?
    var url: String?
}

struct Thumbnail: Codable {
    var path: String?
    var thumbExtension: String?
    
    private enum CodingKeys: String, CodingKey {
        case path
        case thumbExtension = "extension"
    }
}

struct Comics: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [ComicItem]?
}

struct ComicItem: Codable {
    var resourceURI: String?
    var name: String?
}

struct Stories: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [StorieItem]?
}

struct StorieItem: Codable {
    var resourceURI: String?
    var name: String?
    var type: String?
}

struct Events: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [EventItem]?
}

struct EventItem: Codable {
    var resourceURI: String?
    var name: String?
}

struct Series: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [SerieItem]?
}

struct SerieItem: Codable {
    var resourceURI: String?
    var name: String?
}
