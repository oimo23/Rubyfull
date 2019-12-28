//
//  ViewController.swift
//  Rubyfull
//
//  Created by 伏貫祐樹 on 2019/12/26.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutletsの設定
    /***************************************************************/
    @IBOutlet private weak var inputtedText: UITextField!
    @IBOutlet private weak var converted: UILabel!
    
    // MARK: - 必要なモデルのインスタンス化
    /***************************************************************/
    private var textData = TextDataModel()
    private let apiClient = APIClient()

}

