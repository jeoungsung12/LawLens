//
//  LoginViewController.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/04.
//

import Foundation
import UIKit
import SnapKit
import AuthenticationServices
class LoginViewController : UIViewController {
    //앱 제목
    private let TitleStack : UIStackView = {
       let StackView = UIStackView()
        StackView.distribution = .fill
        StackView.axis = .horizontal
        StackView.spacing = 0
        StackView.backgroundColor = .white
        let FirstLabel = UILabel()
         FirstLabel.backgroundColor = .white
         FirstLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
         FirstLabel.text = "Law"
         FirstLabel.font = UIFont.boldSystemFont(ofSize: 50)
        let SecondLabel = UILabel()
         SecondLabel.backgroundColor = .white
         SecondLabel.textColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 0.3)
         SecondLabel.text = "Lens"
         SecondLabel.font = UIFont.boldSystemFont(ofSize: 50)
        
        StackView.addArrangedSubview(FirstLabel)
        StackView.addArrangedSubview(SecondLabel)
        return StackView
    }()
    //국회 이미지
    private let CongressImage : UIImageView = {
        let ImageView = UIImageView()
        ImageView.backgroundColor = .white
        ImageView.image = UIImage(named: "Congress")
        ImageView.contentMode = .scaleAspectFit
        return ImageView
    }()
    //로그인 버튼(apple)
    //MARK: - LoginButton
    private let AppleBtn : ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton()
        btn.addTarget(self, action: #selector(AppleBtnTapped), for: .touchUpInside)
        return btn
    }()
    @objc func AppleBtnTapped() {
        self.navigationController?.pushViewController(UserInfoTableViewController(), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        setupView()
    }
}
//SnapKit으로 오토레이아웃
extension LoginViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    func setupView() {
        let View = UIView()
        View.backgroundColor = .white
        View.addSubview(TitleStack)
        View.addSubview(CongressImage)
        View.addSubview(AppleBtn)
        self.view.addSubview(View)
        View.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        CongressImage.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(200)
        }
        TitleStack.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(CongressImage.snp.top).offset(-50)
        }
        AppleBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(CongressImage.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
}
