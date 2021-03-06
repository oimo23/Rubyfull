//
//  MainViewController.swift
//  Rubyfull
//
//  Created by 伏貫祐樹 on 2019/12/26.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import PKHUD
import UIKit

class MainViewController: UIViewController, UITextViewDelegate {

    // MARK: - IBOutletsの設定
    /***************************************************************/
    @IBOutlet private weak var inputtedText: UITextView!

    // MARK: - 必要なモデルのインスタンス化
    /***************************************************************/
    private var textData = TextDataModel()
    private var responseData = ResponseDataModel()
    private let apiClient = APIClient()

    // MARK: - Viewが読みこまれた時
    /***************************************************************/
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputtedText.delegate = self
    }

    // MARK: - APIとの通信
    /***************************************************************/
    func getHiraganaDataFromAPI(_ unwrappedInputtedText: String) {

        self.apiClient.getHiraganaData(
            inputtedText: unwrappedInputtedText,
            requestURI: Constants.shared.HIRAGANA_API_URL ) { [weak self] result in
                switch result {
                case .success(let responseData):
                    // responseDataの中身を受け取ったものに更新する
                    self?.responseData = responseData

                    // OptionalのUnwrapを行う
                    guard let converted = self?.responseData.converted else { return }
                    guard let unwrappedInputtedText = self?.inputtedText.text else { return }

                    // textDataを取得して来たものに更新
                    self?.textData.converted = converted
                    self?.textData.unConverted = unwrappedInputtedText

                    // 固まらないようメインスレッドでUIの更新をする
                    DispatchQueue.main.async {
                        self?.inputtedText.text = ""
                        HUD.hide()
                    }

                    self?.performSegue(withIdentifier: "toResult", sender: nil)
                case .failure(let error):
                    DispatchQueue.main.async {
                        HUD.hide()
                    }

                    // エラーの種類によってメッセージを分岐
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

    // MARK: - OKのボタンがクリックされたとき
    /***************************************************************/
    @IBAction private func okButtonTapped(_ sender: Any) {
        // キーボードを引っ込める
        self.inputtedText.resignFirstResponder()

        guard let unwrappedInputtedText = self.inputtedText.text else { return }

        // 入力が空ならエラーを通知
        if unwrappedInputtedText.isEmpty {
            showErrorAlert(errorMessage: "入力が空です")
            return
        }

        // ロード中である旨を示すUIを表示
        HUD.show(.progress)

        // APIを叩くための関数を発動
        getHiraganaDataFromAPI(unwrappedInputtedText)
    }
}


// MARK: - UI系
/***************************************************************/
extension MainViewController {

    // MARK: - エラーアラートを出す
    /***************************************************************/
    func showErrorAlert(errorMessage: String) {

        let Alert = UIAlertController(title: "エラーが発生しました", message: errorMessage, preferredStyle: .alert)

        let CloseAction = UIAlertAction(title: "閉じる", style: .default)
        Alert.addAction(CloseAction)

        self.present(Alert, animated: true, completion: nil)
    }

    // MARK: - UITextView外をタッチした時キーボードを引っ込める
    /***************************************************************/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.inputtedText.isFirstResponder {
            self.inputtedText.resignFirstResponder()
        }
    }

    // MARK: - 画面遷移前に挟む処理
    /***************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toResult" {
            let nextView = segue.destination as? ResultViewController

            nextView?.unConvertedString = self.textData.unConverted
            nextView?.convertedString = self.textData.converted
        }
    }
}
