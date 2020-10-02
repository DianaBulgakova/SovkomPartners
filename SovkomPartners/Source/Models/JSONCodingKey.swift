//
//  JSONCodingKey.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 02.10.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}
