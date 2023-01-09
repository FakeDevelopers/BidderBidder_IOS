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

        // main cell을 선택한 경우 - sub cell모두 main cell과 동일한 상태로 업데이트
            dataSource[indexPath.section].isAccept.toggle()
            dataSource[indexPath.section].isAccept = dataSource[indexPath.section].isAccept
        
        if indexPath.row != 0 { // sub cell을 선택한 경우 - sub cell에 따라 main cell 업데이트
            dataSource[indexPath.section].isAccept.toggle()

            if !dataSource[indexPath.section].isAccept {
                dataSource[indexPath.section].isAccept = false
            }
            dataSource[indexPath.section].isAccept = true
        }

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
