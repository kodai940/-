//
//  WordData.swift
//  MyPracticeLayout
//
//  Created by user on 2023/01/05.
//

import Foundation

struct WordData {
    private(set) public var word: String
    private(set) public var level: String
    private(set) public var type: String
    private(set) public var wc: String
    private(set) public var tag: String
    
    init(word: String, level:String, type:String, wc: String, tag: String) {
        self.word = word
        self.level = level
        self.type = type
        self.wc = wc
        self.tag = tag
    }
}
