//
//  AgreementViewController.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/07.
//

import UIKit
import SnapKit
class AgreementViewController: UIViewController, UITextViewDelegate {
    static var EffectText = ""
    static var ContentText = ""
    private let titleLabel1 : UILabel = {
        let label = UILabel()
        label.backgroundColor =  #colorLiteral(red: 0.94938308, green: 0.960082829, blue: 0.9535366893, alpha: 1)
        label.text = "청원 취지 : "
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let titleLabel2 : UILabel = {
        let label = UILabel()
        label.backgroundColor =  #colorLiteral(red: 0.94938308, green: 0.960082829, blue: 0.9535366893, alpha: 1)
        label.text = "청원 내용 : "
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let EffectTextView : UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.backgroundColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .left
        textView.textColor = .lightGray
        textView.text = "취지/목적 분명하게 적을 수록 더 좋은 글이 완성됩니다!"
        return textView
    }()
    private let ContentTextView : UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.backgroundColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .left
        textView.textColor = .lightGray
        textView.text = "간락하게라도 하고자 하는 내용을 핵심있게 적어주세요!"
        return textView
    }()
    private let AIBtn : UIButton = {
       let view = UIButton()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.setTitle(" AI 청원서 작성", for: .normal)
        view.setTitleColor(UIColor(
            red: CGFloat((0x2D31AC & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x2D31AC & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x2D31AC & 0x0000FF) / 255.0,
            alpha: 1.0), for: .normal)
        view.setImage(UIImage(systemName: "pencil"), for: .normal)
        view.tintColor = UIColor(
            red: CGFloat((0x2D31AC & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x2D31AC & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x2D31AC & 0x0000FF) / 255.0,
            alpha: 1.0)
        view.addTarget(self, action: #selector(AIBtnTapped), for: .touchUpInside)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        self.title = "청원서 작성"
        EffectTextView.delegate = self
        ContentTextView.delegate = self
        setupView()
    }

}
extension AgreementViewController {
    func setupView() {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.layer.shadowColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        let View = UIView()
        View.backgroundColor =  #colorLiteral(red: 0.94938308, green: 0.960082829, blue: 0.9535366893, alpha: 1)
        View.layer.borderWidth = 0.7
        View.layer.borderColor = CGColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        let fold = UIView()
        fold.backgroundColor =  #colorLiteral(red: 0.7956857681, green: 0.8059142828, blue: 0.8170601726, alpha: 1)
        View.addSubview(fold)
        View.addSubview(titleLabel1)
        View.addSubview(EffectTextView)
        let line = UIView()
        line.backgroundColor = .lightGray
        View.addSubview(line)
        View.addSubview(titleLabel2)
        View.addSubview(ContentTextView)
        StackView.addArrangedSubview(View)
        StackView.addArrangedSubview(AIBtn)
        self.view.addSubview(StackView)
        StackView.snp.makeConstraints{ (make) in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 8.5)
        }
        View.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().inset(self.view.frame.height / 8.5)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(80)
        }
        fold.snp.makeConstraints{ (make) in
            make.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().inset(0)
            make.height.width.equalTo(20)
        }
        titleLabel1.snp.makeConstraints{(make) in
            make.leading.top.equalToSuperview().inset(10)
            make.trailing.equalTo(fold.snp.leading).inset(0)
            make.height.equalTo(40)
        }
        EffectTextView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel1.snp.bottom).offset(15)
            make.height.equalToSuperview().dividedBy(5)
        }
        line.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(EffectTextView.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        titleLabel2.snp.makeConstraints{(make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.top.equalTo(line.snp.bottom).offset(10)
        }
        ContentTextView.snp.makeConstraints{ (make) in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel2.snp.bottom).offset(15)
        }
        AIBtn.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
        }
    }
    @objc func AIBtnTapped() {
        AgreementViewController.EffectText = EffectTextView.text
        AgreementViewController.ContentText = ContentTextView.text
        self.navigationController?.pushViewController(AIReportViewController(), animated: true)
    }
}
//UITextViewDelegate
extension AgreementViewController {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "입력하세요..."
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
