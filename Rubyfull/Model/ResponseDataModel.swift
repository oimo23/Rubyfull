//
//  ResponseDataModel.swift
//  Rubyfull
//
//  Created by 伏貫祐樹 on 2019/12/31.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Foundation

struct ResponseDataModel: Decodable {

    private(set) var converted: String = ""
    private(set) var output_type: String = ""
    private(set) var request_id: String = ""
}
