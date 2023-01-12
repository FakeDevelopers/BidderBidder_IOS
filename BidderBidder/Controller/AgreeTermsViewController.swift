//
//  AgreeTermsViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa

class AgreeTermsViewController: UIViewController {

    @IBOutlet weak var tblTerms: UITableView!
    @IBOutlet weak var allAcceptButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var viewModel = AgreeTermViewModel()
    let bag = DisposeBag()
    var isCheckedBtnAllAccept: Bool = false {
        didSet {
            let checkImageName = isCheckedBtnAllAccept ? Constant.checkmarkCircleFill : Constant.checkmarkCircle
            allAcceptButton.setImage(UIImage(systemName: checkImageName), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupOutputBinding()
        setupInputBinding()
    }

    private func setupView() {
        tblTerms.delegate = self
        tblTerms.dataSource = self
        let nibName = String(describing: TermsCell.self)
        tblTerms.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)

        confirmButton.setBackgroundColor(.blue, for: .normal)
        confirmButton.setBackgroundColor(.lightGray, for: .disabled)
    }

    private func setupInputBinding() {
        rx.viewWillAppear.take(1).asDriver(onErrorRecover: { _ in return .never()})
            .drive(onNext: { [weak self] _ in
                self?.viewModel.viewWillAppear()
            }).disposed(by: bag)

        allAcceptButton.rx.tap.asDriver(onErrorRecover: {_ in return .never()})
            .drive(onNext: { [weak self] in
                self?.isCheckedBtnAllAccept.toggle()
                self?.viewModel.acceptAllTerms(self?.isCheckedBtnAllAccept)
            }).disposed(by: bag)
    }

    private func setupOutputBinding() {
        viewModel.updateTermsContents.asDriver(onErrorRecover: {_ in return .never()})
            .drive(onNext: { [weak self] in
                self?.tblTerms.reloadData()
            }).disposed(by: bag)

        viewModel.satisfyTermsPermission.asDriver(onErrorRecover: {_ in return .never()})
            .drive(onNext: { [weak self] isSatisfy in
                self?.confirmButton.isEnabled = isSatisfy
            }).disposed(by: bag)

        viewModel.acceptAllTerms.asDriver(onErrorRecover: {_ in return .never()})
            .drive(onNext: { [weak self] isAcceptAllTerms in
                self?.isCheckedBtnAllAccept = isAcceptAllTerms
            }).disposed(by: bag)
    }
}

extension AgreeTermsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TermsCell.self)) as! TermsCell
        cell.selectionStyle = .none
        cell.bind(viewModel.dataSource[indexPath.section])
        cell.checkButton.rx.tap.asDriver(onErrorRecover: { _ in return .never()})
            .drive(onNext: { [weak self] in
                self?.viewModel.didSelectTermsCell(indexPath: indexPath)
            }).disposed(by: cell.bag)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectTermsCell(indexPath: indexPath)
    }
}
