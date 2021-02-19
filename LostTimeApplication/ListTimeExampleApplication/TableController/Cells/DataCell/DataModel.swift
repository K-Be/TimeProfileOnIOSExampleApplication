//
//  DataModel.swift
//  LostTimeApplication
//
//  Created by Andrew Romanov on 31.12.2020.
//

import Foundation

class DataModel {
    let text: String
    var value: Int
    let numberOfItems: UInt

    init(text: String, value: Int, numberOfItems: UInt) {
        self.text = text
        self.value = value
        self.numberOfItems = numberOfItems
    }
}
