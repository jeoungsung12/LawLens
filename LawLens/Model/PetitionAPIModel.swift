//
//  PetitionAPIModel.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/06.
//

import Foundation

struct PetitionAPIModel: Decodable {
    let bill_name : String //청원명
    let approver : String //소개의원
    let proposer : String //청원인
    let committee : String //소관위원회
    let bill_no : String //청원번호
    let propose_dt : String //청원일시
}
