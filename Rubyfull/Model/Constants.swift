//
//  Constants.swift
//  Rubyfull
//
//  Created by 伏貫祐樹 on 2019/12/26.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Foundation

struct Constants {
    
    static let shared = Constants()

    let HIRAGANA_API_URL: String
    let APP_ID: String

    private init() {

        self.HIRAGANA_API_URL = "https://labs.goo.ne.jp/api/hiragana"
        self.APP_ID = "ce550ffb884060b4c8ab2d76dc5fb47807c571d158f74dadae37d89d873013e7"

    }
    
}
