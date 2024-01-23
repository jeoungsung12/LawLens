//
//  UserInfoTableViewCell.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/06.
//

import Foundation
import UIKit
import SnapKit

class UserInfoTableViewCell : UITableViewCell, UITextViewDelegate {
    var UserInfoText = UITextView()
    // 각 셀의 정보를 저장할 배열
    static var userInputs: [String: String] = [:]
    var cellInfo: String?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        let View = UIView()
        View.backgroundColor = .white
        View.layer.cornerRadius = 10
        View.layer.borderColor = CGColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        View.layer.borderWidth = 0.7
        View.layer.masksToBounds = true
        
        UserInfoText.backgroundColor = .white
        UserInfoText.textAlignment = .left
        UserInfoText.font = UIFont.boldSystemFont(ofSize: 15)
        UserInfoText.textColor = .lightGray
        UserInfoText.delegate = self
        View.addSubview(UserInfoText)
        contentView.addSubview(View)
        View.snp.makeConstraints{ (make) in
            make.leading.trailing.top.bottom.equalToSuperview().inset(20)
        }
        UserInfoText.snp.makeConstraints{ (make) in
            make.leading.trailing.top.bottom.equalToSuperview().inset(10)
        }
    }
    // UITextViewDelegate Placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "입력하세요..."
            textView.textColor = UIColor.lightGray
        }else {
            // 새로운 값을 입력받았을 때 해당 값을 userInputs에 저장
            if let text = textView.text {
                UserInfoTableViewCell.userInputs["\(cellInfo ?? "")"] = text
            }
        }
    }
    static func saveUserInfo(completion: @escaping (Bool) -> Void) {
        // 저장
        UserDefaults.standard.set(userInputs, forKey: "UserInfo")
        // UserDefaults에서 딕셔너리를 가져오기
        if let retrievedDict = UserDefaults.standard.dictionary(forKey: "UserInfo"){
            // 불러온 딕셔너리 사용
            print("불러온 UserInfoDict: \(retrievedDict)")
            completion(true)
        } else {
            print("UserDefaults에서 UserInfoDict를 불러오지 못했습니다.")
            completion(false)
        }
    }
}
