//
//  SchoolNamesTests.swift
//  SchoolNamesTests
//
//  Created by Weng Seong Cheang on 2/15/24.
//

import XCTest
import Combine
@testable import SchoolNames

final class SchoolNamesTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

        // This is just a simple test case to give you a starting point
        func testFetchData() {
            let fetcher = MyModelFetcher()
            let expectation = XCTestExpectation(description: "Fetch data expectation")

            fetcher.fetchData()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        // Successful completion
                        expectation.fulfill()
                    case .failure(let error):
                        XCTFail("Failed to fetch data with error: \(error.localizedDescription)")
                    }
                }, receiveValue: { dictionaries in
                    for dictionary in dictionaries {
                        guard let schoolName = dictionary["school_name"],
                              let overviewParagraph = dictionary["overview_paragraph"] else {
                            XCTFail("Missing 'school_name' or 'overview_paragraph' in dictionary: \(dictionary)")
                            return
                        }
                        print("School name: \(schoolName), Overview paragraph: \(overviewParagraph)")
                    }
                    // We're not testing the received value in this simple example
                })
                .store(in: &cancellables)

            wait(for: [expectation], timeout: 10.0)
        }
}
