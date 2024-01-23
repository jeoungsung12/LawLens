//
//  MatchingViewController.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/07.
//

import UIKit
import Charts
class MatchingViewController: UIViewController {
    let bill_name : String
    //이니셜라이저를 사용하여 Post 객체를 전달받아 post 속성에 저장
    init(bill_name: String) {
        self.bill_name = bill_name
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //로딩인디케이터
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .darkGray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
        }()
    private let pieChartView: PieChartView = {
            let chartView = PieChartView()
            return chartView
        }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "매칭 결과 : "
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let MatchingTextView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.isEditable = false
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .left
        textView.textColor = .lightGray
        textView.text = ""
        return textView
    }()
    private let PercentView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0)
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = bill_name
        self.view.addSubview(loadingIndicator)
        self.view.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0)
        setupView()
        // ChatGPT API 요청 호출
        fetchChatGPTResponse()
    }
}
extension MatchingViewController {
    func setupView() {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0)
        let View = UIView()
        View.backgroundColor = .white
        View.addSubview(titleLabel)
        View.addSubview(MatchingTextView)
        StackView.addArrangedSubview(PercentView)
        StackView.addArrangedSubview(View)
        self.view.addSubview(StackView)
        StackView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().inset(self.view.frame.height / 8.5)
            make.bottom.equalToSuperview().inset(0)
        }
        PercentView.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2.6)
        }
        View.snp.makeConstraints{(make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalTo(PercentView.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        titleLabel.snp.makeConstraints{(make) in
            make.leading.trailing.top.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        MatchingTextView.snp.makeConstraints{(make) in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    private func setupPieChart() {
            PercentView.addSubview(pieChartView)
            pieChartView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            let dataEntries = [
                PieChartDataEntry(value: Double(ChatGptAPIMethod.Percent) ?? 0, label: "관련"),
                PieChartDataEntry(value: (Double(100) - (Double(ChatGptAPIMethod.Percent) ?? 0)), label: "관련없음")
            ]

            let dataSet = PieChartDataSet(entries: dataEntries, label: "")
            dataSet.colors = ChartColorTemplates.vordiplom()
            dataSet.valueTextColor = .black

            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
        }
}
extension MatchingViewController{
    func startLoading() {
        loadingIndicator.startAnimating()
    }

    func stopLoading() {
        loadingIndicator.stopAnimating()
    }
    func fetchChatGPTResponse() {
        startLoading()
        ChatGptAPIMethod.generateChatGPTResponse(petitionSummary: bill_name) { success in
            if success {
                // 비동기 메서드 호출 성공 처리
                DispatchQueue.main.async {
                    self.MatchingTextView.text = ChatGptAPIMethod.ChatGptContent
                    self.setupPieChart()
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
