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

    // MARK: - APIとの通信
    /***************************************************************/
    func getHiraganaDataFromAPI() {
        self.apiClient.getHiraganaData(inputtedText: self.inputtedText.text!) { [weak self] result in
            switch result {
            case .success(let textData):
                // textDataの中身を受け取ったものに更新する
                self?.textData = textData

                // 固まらないようメインスレッドでUIの更新をする
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let error):

                switch error {
                case .requestError:
                    self?.showErrorAlert(errorMessage: "リクエストエラー")
                case .responseError:
                    self?.showErrorAlert(errorMessage: "レスポンスエラー")
                case .unknownError:
                    self?.showErrorAlert(errorMessage: "不明なエラー")
                }
            }
        }
    }

    // MARK: - エラーアラートを出す
    /***************************************************************/
    func showErrorAlert(errorMessage: String) {
        let Alert = UIAlertController(title: "エラーが発生しました", message: errorMessage, preferredStyle: .alert)

        let CloseAction = UIAlertAction(title: "閉じる", style: .default)
        Alert.addAction(CloseAction)

        self.present(Alert, animated: true, completion: nil)
    }

    @IBAction func OKButtonTapped(_ sender: Any) {
        if(self.inputtedText.text!.isEmpty) {
            showErrorAlert(errorMessage: "入力が空です")
            return
        }

        getHiraganaDataFromAPI()
    }

    // MARK: - 画面更新
    /***************************************************************/
    func updateUI() {
        self.converted.text = self.textData.converted
    }

}
