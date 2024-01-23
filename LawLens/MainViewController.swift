//
//  ViewController.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/04.
//

import UIKit
import SnapKit
import WebKit
class MainViewController: UIViewController, WKNavigationDelegate {
    var NewsWebView: WKWebView! //뉴스 웹뷰
    //제목
    private let DescriptionTitle : UIStackView = {
        let StackView = UIStackView()
        StackView.distribution = .fill
        StackView.axis = .vertical
        StackView.spacing = 40
        StackView.backgroundColor = .white
        let FirstLabel = UILabel()
        FirstLabel.textAlignment = .center
        FirstLabel.backgroundColor = .white
        FirstLabel.textColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        FirstLabel.text = "LawLens"
        FirstLabel.font = UIFont.boldSystemFont(ofSize: 25)
        let SecondLabel = UILabel()
        SecondLabel.textAlignment = .center
        SecondLabel.backgroundColor = .white
        SecondLabel.textColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 0.5)
        SecondLabel.text = "열린국회에서 제공하는 공공데이터를 기반합니다"
        SecondLabel.font = UIFont.boldSystemFont(ofSize: 15)
         
        StackView.addArrangedSubview(FirstLabel)
        StackView.addArrangedSubview(SecondLabel)
        
         return StackView
    }()
    //청원계류현황 버튼
    private let PetitionBtn : UIButton = {
        let Btn = UIButton()
        Btn.backgroundColor = .white
        Btn.setTitle("청원계류현황", for: .normal)
        Btn.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), for: .normal)
        Btn.layer.cornerRadius = 10
        Btn.layer.masksToBounds = true
        Btn.layer.borderWidth = 0.7
        Btn.layer.borderColor = CGColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        Btn.addTarget(self, action: #selector(PetitionBtnTapped), for: .touchUpInside)
        return Btn
    }()
    //진행중인입법 버튼
    private let ProceedingBtn : UIButton = {
        let Btn = UIButton()
        Btn.backgroundColor = .white
        Btn.setTitle("진행 중인 입법", for: .normal)
        Btn.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), for: .normal)
        Btn.layer.cornerRadius = 10
        Btn.layer.masksToBounds = true
        Btn.layer.borderWidth = 0.7
        Btn.layer.borderColor = CGColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        Btn.addTarget(self, action: #selector(ProceedingBtnTapped), for: .touchUpInside)
        return Btn
    }()
    //국민동의청원 버튼
    private let AgreementBtn : UIButton = {
        let Btn = UIButton()
        Btn.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        Btn.setTitle("국민동의청원 참여하기 \t>", for: .normal)
        Btn.setTitleColor(.white, for: .normal)
        Btn.layer.cornerRadius = 10
        Btn.layer.masksToBounds = true
        Btn.addTarget(self, action: #selector(AgreementBtnTapped), for: .touchUpInside)
        return Btn
    }()
    //뉴스뷰
    private let NewsView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.7
        view.layer.borderColor = CGColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .white
        if let navigationBar = navigationController?.navigationBar {
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]}
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = ""
        let ImageView = UIImageView()
        ImageView.image = UIImage(named: "CongressIcon")
        ImageView.contentMode = .scaleAspectFill
        ImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        let custombarbtn = UIBarButtonItem(customView: ImageView)
        self.navigationItem.leftBarButtonItem = custombarbtn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBtnTapped))
        setupView()
    }
}
//SnapKit으로 오토레이아웃
extension MainViewController {
    func setupView() {
        let View = UIView()
        View.backgroundColor = .white
        View.addSubview(DescriptionTitle)
        View.addSubview(PetitionBtn)
        View.addSubview(ProceedingBtn)
        View.addSubview(AgreementBtn)
        setNewsWebView()
        NewsView.addSubview(NewsWebView)
        View.addSubview(NewsView)
        
        self.view.addSubview(View)
        View.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        AgreementBtn.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        PetitionBtn.snp.makeConstraints{ (make) in
            make.leading.equalTo(AgreementBtn.snp.leading)
            make.bottom.equalTo(AgreementBtn.snp.top).offset(-20)
            make.width.equalTo(AgreementBtn.snp.width).dividedBy(2.2)
            make.height.equalTo(80)
        }
        ProceedingBtn.snp.makeConstraints{ (make) in
            make.trailing.equalTo(AgreementBtn.snp.trailing)
            make.bottom.equalTo(AgreementBtn.snp.top).offset(-20)
            make.width.equalTo(AgreementBtn.snp.width).dividedBy(2.2)
            make.height.equalTo(80)
        }
        DescriptionTitle.snp.makeConstraints{ ( make) in
            make.leading.equalTo(AgreementBtn.snp.leading)
            make.trailing.equalTo(AgreementBtn.snp.trailing)
            make.bottom.equalTo(ProceedingBtn.snp.top).offset(-50)
        }
        NewsView.snp.makeConstraints{ (make) in
            make.top.equalTo(AgreementBtn.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-40)
            make.leading.equalTo(AgreementBtn.snp.leading)
            make.trailing.equalTo(AgreementBtn.snp.trailing)
        }
    }
}
//MARK: - Method
extension MainViewController {
    //웹뷰 설정 메서드
    func setNewsWebView() {
        //뉴스 웹뷰
        NewsWebView = WKWebView(frame: self.view.bounds)
        NewsWebView.navigationDelegate = self
        NewsWebView.layer.cornerRadius = 10
        NewsWebView.layer.masksToBounds = true
        NewsWebView.backgroundColor = .white
        NewsWebView.contentMode = .scaleAspectFit
        if let url = URL(string: "https://www.naon.go.kr"){
            // 웹 페이지를 로드
            let request = URLRequest(url:url)
            NewsWebView.load(request)
        }
    }
    @objc func closeBtnTapped() {
        let Alert = UIAlertController(title: "설정", message: nil, preferredStyle: .alert)
        let Info = UIAlertAction(title: "개인정보 변경", style: .default){ _ in
            self.navigationController?.pushViewController(UserInfoTableViewController(), animated: true)
        }
        let logout = UIAlertAction(title: "로그아웃", style: .default) { _ in
            let window = UIWindow(frame: UIScreen.main.bounds)
            let viewController = LoginViewController() //처음 보일 view controller
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController //위에서 만든 view controller를 첫 화면으로 띄우기
            window.makeKeyAndVisible() //화면에 보이게끔
            self.navigationController?.pushViewController(LoginViewController(), animated: false)
        }
        let cancel = UIAlertAction(title: "취소", style: .default){_ in}
        Alert.addAction(Info)
        Alert.addAction(logout)
        Alert.addAction(cancel)
        self.present(Alert, animated: true)
    }
    @objc func PetitionBtnTapped() {
        self.navigationController?.pushViewController(PetitionTableViewController(), animated: true)
    }
    @objc func ProceedingBtnTapped() {
        self.navigationController?.pushViewController(ProceedingTableTableViewController(), animated: true)
    }
    @objc func AgreementBtnTapped() {
        self.navigationController?.pushViewController(AgreementViewController(), animated: true)
    }
}
