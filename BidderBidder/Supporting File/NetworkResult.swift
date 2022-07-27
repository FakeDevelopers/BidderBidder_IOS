//
//  NetworkResult.swift
//  BidderBidder
//
//  Created by 김예림 on 2022/07/26.
//

//서버 통신 결과 핸들링

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
