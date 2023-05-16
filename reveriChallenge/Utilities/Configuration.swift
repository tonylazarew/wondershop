//
//  Configuration.swift
//  reveriChallenge
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

enum Configuration {

    private enum Keys {
        static let dummyJSONURLKey = "DUMMY_JSON_BASE_URL"
    }

    private static var infoDictionary: [String: Any] {
        Bundle.main.infoDictionary ?? [:]
    }

    static var dummyJSONURL: URL {
        URL(string: infoDictionary[Keys.dummyJSONURLKey] as! String)!
    }

}

