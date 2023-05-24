//
//  SwapViewController.swift
//  ZKFace
//
//  Created by Danna Lee on 2023/05/25.
//

import UIKit

class SwapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onClickNext(_ sender: Any) {
        let vc = ConfirmViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
