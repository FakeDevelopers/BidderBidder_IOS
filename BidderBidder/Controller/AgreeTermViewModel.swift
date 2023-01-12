//
//  AgreeTermViewModel.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa

class AgreeTermViewModel {
    
    let updateTermsContents = PublishRelay<Void>()
    let satisfyTermsPermission = PublishRelay<Bool>()
    let acceptAllTerms = PublishRelay<Bool>()
    
    var dataSource = [Term]()
    let bag = DisposeBag()
    
    func viewWillAppear() {
        dataSource = Term.loadSampleData()
    }
    
    func acceptAllTerms(_ isCheckedBtnAllAccept: Bool?) {
        
        guard let isCheckedBtnAllAccept = isCheckedBtnAllAccept else {
            return
        }
        
        for section in 0 ..< dataSource.count {
            dataSource[section].isAccept = isCheckedBtnAllAccept
        }
        
        updateTermsContents.accept(())
        satisfyTermsPermission.accept(isCheckedBtnAllAccept)
    }
    
    func didSelectTermsCell(indexPath: IndexPath) {
        dataSource[indexPath.row].isAccept.toggle()
        updateTermsContents.accept(())
        checkSatisfyTerms()
        checkAcceptAllTerms()
    }
    
    private func checkSatisfyTerms() {
        for termList in dataSource {
            if termList.isRequired && !termList.isAccept {
                satisfyTermsPermission.accept(false)
                return
            }
        }
        satisfyTermsPermission.accept(true)
    }
    
    private func checkAcceptAllTerms() {
        for termList in dataSource {
            if !termList.isAccept {
                acceptAllTerms.accept(false)
                return
            }
        }
        acceptAllTerms.accept(true)
    }
    
}
