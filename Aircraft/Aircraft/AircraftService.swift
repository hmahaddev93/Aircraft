//
//  AircraftService.swift
//  Aircraft
//
//  Created by Khateeb H. on 1/23/22.
//

import Foundation
import Combine

protocol AircraftService_Protocol {
    func getAircrafts(completion: @escaping (Result<[Aircraft], Error>) -> Void)
}

final class AircraftService: AircraftService_Protocol {
    static let shared: AircraftService = AircraftService()
    private var cancellable: AnyCancellable?
    private let jsonDecoder: JSONDecoder
    
    init() {
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
        
    func getAircrafts(completion: @escaping (Result<[Aircraft], Error>) -> Void) {
        let url = URL(string: "https://demo4384701.mockable.io/aircrafts")!
        self.cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: [Aircraft].self, decoder: self.jsonDecoder)
            .sink(receiveCompletion: { complete in
                switch complete {
                    
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            },receiveValue: { aircrafts in
                print ("Received: \(aircrafts.count).")
                completion(.success(aircrafts))
            })
    }
}
