//
//  IntroViewController.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/04.
//

import Foundation
import UIKit
import SnapKit
class IntroViewController : UIViewController {
    //큰 제목
    private let LargeTitle : UILabel = {
       let label = UILabel()
        label.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.text = "LawLens"
        return label
    }()
    //작은 제목
    private let SmallTitle : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        label.textColor = UIColor(red: CGFloat(255) / 255.0, green: CGFloat(255) / 255.0, blue: CGFloat(255) / 255.0, alpha: 0.5)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "나에게 딱 맞는 법"
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        setupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.navigationController?.pushViewController(LoginViewController(), animated: false)
        }
    }
}
//SnapKit으로 오토레이아웃
extension IntroViewController {
    func setupView() {
        let View = UIView()
        View.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        View.addSubview(LargeTitle)
        View.addSubview(SmallTitle)
        self.view.addSubview(View)
        View.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        LargeTitle.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
        }
        SmallTitle.snp.makeConstraints{ (make) in
            make.bottom.equalTo(LargeTitle.snp.top).offset(-40)
            make.leading.equalTo(LargeTitle.snp.leading)
        }
    }
}
