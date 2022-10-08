//
//  SecondViewController.swift
//  BidderBidder
//
//  Created by 김한빈 on 2022/09/22.
//

import UIKit

class SecondViewController: UIViewController {
    @IBAction func showChatViewController(_: Any) {
        performSegue(withIdentifier: "ChatViewControllerSegue", sender: nil)
    }
}
