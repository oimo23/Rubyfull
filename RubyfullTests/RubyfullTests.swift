//
//  RubyfullTests.swift
//  RubyfullTests
//
//  Created by 伏貫祐樹 on 2019/12/26.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import XCTest
import Mockingjay

@testable import Rubyfull

class RubyfullTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - APIClientが正常に動いているか（成功パターン）
    /***************************************************************/
    func testAPIClientWhenSuccess() {
        // スタブ化したレスポンスを作る
        let body = [ "converted": "かんじが まざっている ぶんしょう", "output_type": "hiragana","request_id": "record003" ]
        self.stub(uri("https://www.must-be-success.com/"), json(body))
        
        let apiClient = APIClient()
        let expect = expectation(description: "SendMyRequest")
        
        // apiClientを使用してリクエストを行う（結果は必ず上記で設定したダミーが入ってくる）
        apiClient.getHiraganaData(
            inputtedText: "漢字が混ざっている文章",
            requestURI: "https://www.must-be-success.com/" ) { result in
                switch result {
                case .success(let data):
                    var textData = TextDataModel()
                    textData = data
                
                    XCTAssertEqual(textData.converted, "かんじが まざっている ぶんしょう")
                    
                    expect.fulfill()
                case .failure(_):
                    XCTFail("失敗するはずのないリクエスト")
                }
        }
        
        // 非同期処理を5秒待つ
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                // 5秒以上の待機でもエラー発生とみなす（タイムアウトなど）
                print(error)
                XCTFail("ExpectaionTimeOut")
            }
        }
    }
    
    // MARK: - APIClientが正常に動いているか（失敗パターン）
    /***************************************************************/
    func testAPIClientWhenFailure() {
        // スタブ化したレスポンスを作る
        // サーバー側が落ちてる感じを想定
        self.stub(uri("https://www.must-be-failed.com/"), http(503))
        
        let apiClient = APIClient()
        let expect = expectation(description: "SendMyRequest")
        
        // apiClientを使用してリクエストを行う（結果は必ず上記で設定したダミーが入ってくる）
        apiClient.getHiraganaData(
            inputtedText: "漢字が混ざっている文章",
            requestURI: "https://www.must-be-failed.com/" ) { result in
                switch result {
                case .success(_):
                    XCTFail("成功するはずのないリクエスト")
                case .failure(_):
                    expect.fulfill()
                }
        }
        
        // 非同期処理を5秒待つ
        waitForExpectations(timeout: 5)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
