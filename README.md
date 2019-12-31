<h1 align="center">Rubyfull -ルビふる-</h1>
<p align="center">
<img src="https://img.shields.io/badge/Xcode-11.3-066da5.svg?style=flat-square" alt="Xcode 11.3">
<img src="https://img.shields.io/badge/Target-iOS13.0-brightgreen.svg?style=flat-square" alt="iOS 13.0">
<img src="https://img.shields.io/badge/Swift-5-orange.svg?style=flat-square" alt="Swift5">
</p>
<p align="center">
<img src="https://user-images.githubusercontent.com/18276888/71623310-eb819300-2c1e-11ea-9fc0-03eaf07fa31e.GIF" alt="スクリーンショット">
</p>


## :star: 概要
日本語（漢字・かな混じり）のテキストを入力すると、ルビ（ひらがな）に直して出力してくれる。

## :closed_book: 動かし方
1. このリポジトリをcloneする
2. Cocoa Podsがある環境で以下のコマンドを実行する
```
pod install
```
3. 「Rubyfull.xcworkspace」を開く

## :ghost: アピールポイント
### 責務の分離をした（つもり）
MVC設計を用いてなるべくファイルを分割して、ViewControllerが巨大にならないように自分なりにした。

### エラーの表示の仕方
エラーが起きた事が明示的に分かるようにした。  
また、エラーの中でも

・入力が空白だった場合  
・リクエストエラーが起きた場合  
・レスポンスエラーが起きた場合  
    
が識別出来るようにした。

### 非同期処理中である事が分かるようにしている
通常は一瞬でリクエストが返ってくるが、サーバーが重い時などを考慮して、ロード中であることを明示するため「PKHUD」を導入している

### READMEがきちんと書いてある
・スクリーンショット  
・アピールポイント  
・詰まったところ  
・課題  
    
などが書いてあり、レビュー者に概要が分かりやすいようにしている  
shields.io、絵文字、gifアニメを用いて見やすいデザインになるよう気を配っている。  

### 外部に依存しないユニットテストが書いてある
外部に依存しない形でAPIクラスのテストが書いてある。

### 大量の文字が入って来てもレイアウトが崩れない
入力が大量の文字の場合でも、横や縦に伸びないようにしている

### 定数クラスを使って、ハードコーディングをしないようにしている
APP_IDやAPIのURLなどを直接書かないようにしている

### SwiftLintを使って、コードの秩序が保たれるようにしている
SwiftLintを導入して、ルールに従ったコードになるようにしている

## :sob: 詰まったこと
### 実機テストしようとしたら「iPhone is busy: Preparing debugger support for iPhone」が永遠に終わらない
前回の実機テストの時とiOSもしくはXcodeのバージョンが変わっていたからかこのエラーが出た  
    
ググると「時間が掛かっているだけなので待つと良い」という意見が多かったが、1時間半くらい待っても改善しなかった  
    
最終的にMacの再起動とiPhoneの再起動で治った

### 「this class is not key value coding-compliant for the key」というエラー

IBoutletsの変数名を変えたせいで、古い変数名との接続が残ったままになったのが原因だった

その後もう一度同じエラーが出たが、その時はViewControllerの名前を変更したせいで接続情報がおかしくなったのが原因だった

### Alamofireからのresponseをprintで確認しようとしたけど出来なかった
debugprint()という関数を使えば良いと初めて知った  
[参考にしたリンク](https://stackoverflow.com/questions/56770309/how-to-print-result-from-alamofire-response-using-codable)

### The bundle “RubyfullUITests” couldn’t be loaded because it is damaged or missing necessary resources.
何も書いてないUITestが失敗する現象が起きて困った  
[昔も同じ事があった](https://qiita.com/oimo23/items/92cc217639c50266a1e9)が今回はどのライブラリのせいなのか分からなかった

PodfileのUITest部分にも3rdパーティライブラリを記述して「pod install」する事で改善した

### API通信部分をモックに差し替えながらテストするにはどうすれば良いかの調査、あるいはその実践に時間がかかった
テストで直接APIを叩くと、たまたまサーバーが落ちていたりするとテストが失敗したり外部に依存する事になる。  
      
なのでモックなどを使用するという事は分かっていたが、採用する事にした「MockingJay」というライブラリの情報がそんなに出てこないので苦戦した。  
    
最終的にちゃんと使えたが、結構な時間を浪費した。

### MockingJayの依存関係でインストールされた URITemplates がSwift5に対応していなくて困った
上記と若干被るが、「URITemplates」がエラーが出て動かなかった。
GitHubのIssuesを見たら、beta版だと対応していることが分かって解決した。  
[参考リンク](https://github.com/kylef/Mockingjay/issues/110)

### SwiftLintからの警告への対応
UITextViewのForce UnwrappingもSwiftLintから警告された。  
この辺りは、UITextViewやUITextFieldは初期状態でもnilではないという情報が出てきたが念の為、guardでUnwrapにした。  
    
その他、結構ダメ出しが多く対応が結構面倒だった。

### UITest
UITestを今まで使った事が無かったので、まともに動かすまで少し苦戦した。
レコーディングが便利だと思った。

## :exclamation: 課題
### 入力に改行があった時、出力も同じ場所で改行されるようにしたかった
同じ場所に改行がないのが少し気持ち悪いと思ったが、実装方法が時間内に思いつかずそのままになってしまった。

### IQKeyboardとAutoLayoutの競合と思われる警告が消せなかった
特に挙動に問題は無いが、コンソールに「Unable to simultaneously satisfy constraints.」の警告が出ている。  
    
IQKeyboardが原因と思われるが時間内に改善出来なかった。
