//
//  ResultViewController.swift
//  Rubyfull
//
//  Created by 伏貫祐樹 on 2019/12/30.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet private weak var converted: UITextView!
    @IBOutlet private weak var unConverted: UITextView!

    var unConvertedString: String = ""
    var convertedString: String = ""

    // MARK: - Viewが読みこまれた時
    /***************************************************************/
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.converted.text = self.convertedString
        self.unConverted.text = self.unConvertedString
    }

}
