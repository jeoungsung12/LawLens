//
//  UserInfoTableViewController.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/05.
//

import Foundation
import UIKit
import SnapKit

class UserInfoTableViewController : UIViewController {
    //사용자의 정보를 저장할 테이블 뷰
    var UserInfoTableView = UITableView()
    //사용자 정보 저장 모델
    var UserInfo = ["성명", "나이", "성별", "거주 지역", "직업", "취미", "소득 수준", "가족 구성원", "종교", "건강 상태", "장애 여부"]
    var UserList : [String] = []
    var isSavedUserInfo = ""
    private let TitleLabel : UILabel = {
        let label = UILabel()
        label.text = "많은 정보를 저장하면 더 정확한 분석을 할 수 있어요!"
        label.textColor = UIColor(red: CGFloat(74) / 255.0, green: CGFloat(74) / 255.0, blue: CGFloat(74) / 255.0, alpha: 0.6)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        UserInfoCalled() //저장된 사용자 정보가 있는지
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.UserInfoTableView.separatorStyle = .none
        //바버튼 설정
        let cancleBtn = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancleBtnTapped))
        let saveBtn = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnTapped))
        cancleBtn.tintColor = .red
        saveBtn.tintColor = UIColor(red: CGFloat(74) / 255.0, green: CGFloat(74) / 255.0, blue: CGFloat(74) / 255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = cancleBtn
        self.navigationItem.rightBarButtonItem = saveBtn
        setTableView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isSavedUserInfo = "YES"
        UserDefaults.standard.setValue(isSavedUserInfo, forKey: "save")
    }
}
//MARK: TableView 설정
extension UserInfoTableViewController : UITableViewDelegate, UITableViewDataSource {
    func setTableView() {
        //테이블뷰
        UserInfoTableView.dataSource = self
        UserInfoTableView.delegate = self
        UserInfoTableView.isScrollEnabled = true
        UserInfoTableView.frame = view.bounds
        UserInfoTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //UITableView에 셀 등록
        UserInfoTableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: "cell")
        UserInfoTableView.backgroundColor = .white
        self.view.addSubview(TitleLabel)
        self.view.addSubview(UserInfoTableView)
        TitleLabel.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(100)
        }
        UserInfoTableView.snp.makeConstraints{ (make) in
            make.top.equalTo(TitleLabel.snp.bottom).offset(0)
            make.leading.trailing.bottom.equalToSuperview().inset(0)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 200
        }else if indexPath.row == 10 || indexPath.row == 9 {
            return 150
        }else{
            return 90
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customTableViewCell = UserInfoTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserInfoTableViewCell
        var save = UserDefaults.standard.string(forKey: "save")
        if save != "YES" {
            customTableViewCell.UserInfoText.text = UserInfo[indexPath.row]
            customTableViewCell.cellInfo = UserInfo[indexPath.row]
        }else{
            customTableViewCell.UserInfoText.text = UserList[indexPath.row]
            customTableViewCell.cellInfo = UserInfo[indexPath.row]
        }
        return customTableViewCell
    }
}
//Button Method
extension UserInfoTableViewController {
    @objc func cancleBtnTapped() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    @objc func saveBtnTapped() {
        // 모든 텍스트뷰의 선택을 해제하고 포커스 해제
        for cell in UserInfoTableView.visibleCells {
            if let customCell = cell as? UserInfoTableViewCell {
                customCell.UserInfoText.resignFirstResponder()
            }
        }
        // userInputs에 새롭게 입력받은 텍스트들 저장
        UserInfoTableViewCell.saveUserInfo { success in
            if success {
                print("저장 성공")
                // 저장이 성공했을 때의 처리 (예: 다음 화면으로 이동)
                let nextViewController = MainViewController()
                self.navigationController?.pushViewController(nextViewController, animated: true)
            } else {
                print("저장 실패")
                // 저장이 실패했을 때의 처리
            }
        }
    }
    func UserInfoCalled() {
        if let retrievedDict = UserDefaults.standard.dictionary(forKey: "UserInfo") {
            UserList.append(retrievedDict["성명"] as? String ?? "성명")
            UserList.append(retrievedDict["나이"] as? String ?? "나이")
            UserList.append(retrievedDict["성별"] as? String ?? "성별")
            UserList.append(retrievedDict["거주 지역"] as? String ?? "거주 지역")
            UserList.append(retrievedDict["직업"] as? String ?? "직업")
            UserList.append(retrievedDict["취미"] as? String ?? "취미")
            UserList.append(retrievedDict["소득 수준"] as? String ?? "소득 수준")
            UserList.append(retrievedDict["가족 구성원"] as? String ?? "가족 구성원")
            UserList.append(retrievedDict["종교"] as? String ?? "종교")
            UserList.append(retrievedDict["건강 상태"] as? String ?? "건강 상태")
            UserList.append(retrievedDict["장애 여부"] as? String ?? "장애 여부")
        }
    }
}
