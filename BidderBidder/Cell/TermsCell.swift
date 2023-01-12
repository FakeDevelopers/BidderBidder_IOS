//
//  TermsCell.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/11/18.
//

import UIKit
import RxSwift

class TermsCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bind(_ data: Term) {
        lblTitle.text = data.termName.precomposedStringWithCanonicalMapping // NFD -> NFC
        
        let mandatoryName = data.isRequired ? Constant.requiredText : Constant.choiceText
        lblOption.isHidden = false
        lblOption.text = mandatoryName
        let checkImageName = data.isAccept ? Constant.checkmarkCircleFill : Constant.checkmarkCircle
        checkButton.setImage(UIImage(systemName: checkImageName), for: .normal)
    }
}
