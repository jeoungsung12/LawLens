//
//  ProceedingAPIModel.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/07.
//

import Foundation

struct ProceedingAPIModel: Decodable {
    let bill_name : String //법률안명
    let proposer_cd : String //제안자구분
    let proposer : String //제안자
    let committee : String //소관위원회
    let bill_no : String //의안번호
    let noti : String //게시종료일
}
