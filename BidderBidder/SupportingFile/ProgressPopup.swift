//
// Created by 김한빈 on 2022/08/27.
//

import UIKit

class ProgressPopup: UIViewController {
    static var instance: ProgressPopup!
    @IBOutlet var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        indicator.startAnimating()
    }
}
