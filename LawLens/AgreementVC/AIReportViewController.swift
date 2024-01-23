//
//  AIReportViewController.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/08.
//

import UIKit

class AIReportViewController: UIViewController {
    var posts : [PetitionAPIModel] = [
    ]
    //로딩인디케이터
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .darkGray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
        }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.94938308, green: 0.960082829, blue: 0.9535366893, alpha: 1)
        label.text = "AI Report : "
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let ContentTextView : UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.backgroundColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .left
        textView.textColor = .lightGray
        textView.text = ""
        return textView
    }()
    private let AIBtn : UIButton = {
       let view = UIButton()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.setTitle("\t국민동의 청원 페이지로 이동", for: .normal)
        view.setTitleColor(UIColor(
            red: CGFloat((0x2D31AC & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x2D31AC & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x2D31AC & 0x0000FF) / 255.0,
            alpha: 1.0), for: .normal)
        view.setImage(UIImage(systemName: "arrow.right"), for: .normal)
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
        self.title = "청원서 작성 AI"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "복사", style: .plain, target: self, action: #selector(copyMethod))
        setupView()
        reportChatGPTResponse()
        PetitionTableViewController.fetchPosts(page: 0) { [weak self] (newPosts, error) in
                guard let self = self else { return }
                    
                if let newPosts = newPosts {
                    // 초기 데이터를 posts 배열에 추가
                    self.posts += newPosts
                    print("Initial data fetch - Success")
                } else if let error = error {
                // 오류 처리
                print("Error fetching initial data: \(error.localizedDescription)")
            }
        }
    }
    
}
extension AIReportViewController {
    func setupView() {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.94938308, green: 0.960082829, blue: 0.9535366893, alpha: 1)
        View.layer.borderWidth = 0.7
        View.layer.borderColor = CGColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        let fold = UIView()
        fold.backgroundColor = #colorLiteral(red: 0.7956857681, green: 0.8059142828, blue: 0.8170601726, alpha: 1)
        View.addSubview(fold)
        View.addSubview(titleLabel)
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
        titleLabel.snp.makeConstraints{(make) in
            make.leading.top.equalToSuperview().inset(10)
            make.trailing.equalTo(fold.snp.leading).inset(0)
            make.height.equalTo(40)
        }
        ContentTextView.snp.makeConstraints{ (make) in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        AIBtn.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
        }
        self.view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    @objc func AIBtnTapped() {
        self.startLoading()
        //상위 20개에 대한 중복체크가 완료 되었을때 팝업창을 보여주고 확인을 누르면 -> 이동
        ChatGptAPIMethod.DuplicateCheck(AIReportText: self.ContentTextView.text, PetitionList: posts){ success in
            if success{
                DispatchQueue.main.async {
                    self.stopLoading()
                    self.Alert(N: ChatGptAPIMethod.Duplicate)
                }
            }else{
                print("중복체크 에러")
            }
        }
    }
    @objc func copyMethod() {
        // UIPasteboard 인스턴스를 가져옴
        let pasteboard = UIPasteboard.general
        // 클립보드에 문자열 설정
        pasteboard.string = ContentTextView.text

        // 복사가 완료되었음을 사용자에게 알리는 등 추가적인 동작 수행 가능
        print("Text copied to clipboard: \(String(describing: ContentTextView.text))")
    }
    func Alert(N : Int) {
        let Alert = UIAlertController(title: "유사 청원", message: "최근 청원 중 유사한 청원이 \(N)개 있습니다. 새롭게 청원을 등록하시겠습니까?", preferredStyle: .alert)
        let Petition = UIAlertAction(title: "청원 게시", style: .default){ _ in
            self.navigationController?.pushViewController(AgreementWebViewController(), animated: true)
        }
        let Agreement = UIAlertAction(title: "청원 동의", style: .default){ _ in
            self.navigationController?.pushViewController(PetitionWebViewController(), animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .default){ _ in }
        Alert.addAction(Petition)
        Alert.addAction(Agreement)
        Alert.addAction(cancel)
        self.present(Alert, animated: true)
    }
}
//Chatgpt AIReport Method
extension AIReportViewController {
    func startLoading() {
        loadingIndicator.startAnimating()
    }

    func stopLoading() {
        loadingIndicator.stopAnimating()
    }
    func reportChatGPTResponse() {
        startLoading()
        ChatGptAPIMethod.reportChatGPTResponse(EffectText: AgreementViewController.EffectText, contentText: AgreementViewController.ContentText) { success in
            if success {
                // 비동기 메서드 호출 성공 처리
                DispatchQueue.main.async {
                    self.ContentTextView.text = ChatGptAPIMethod.ChatGptReport
                    self.stopLoading()
                }
                print("ChatGPT response generated successfully.")
            } else {
                // 비동기 메서드 호출 실패 처리
                print("Failed to generate ChatGPT response.")
            }
        }
    }
}
