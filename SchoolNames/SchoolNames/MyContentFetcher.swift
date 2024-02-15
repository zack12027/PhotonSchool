//
//  MyContentFetcher.swift
//  SchoolNames
//
//  Created by Weng Seong Cheang on 2/15/24.
//

import Foundation
import Combine

class MyModelFetcher:ObservableObject {
    
    private let decoder = JSONDecoder()
    
    func fetchData() -> AnyPublisher<[[String: String]], Error> {
        let url = URL(string: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [[String: String]].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
