//
//  ProceedingTableTableViewController.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/07.
//
import Foundation
import UIKit
import SnapKit

class ProceedingTableTableViewController: UIViewController {
    var tableView = UITableView()
    var currentPage = 0
    let refresh = UIRefreshControl()
    var posts : [ProceedingAPIModel] = [
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]}
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: CGFloat(23) / 255.0, green: CGFloat(172) / 255.0, blue: CGFloat(255) / 255.0, alpha: 1.0)
        self.title = "진행중인 입법"
        //refreshControl init
        self.initRefresh()
        self.setTableview()
        // 처음에 초기 데이터를 불러옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
                guard let self = self else { return }
                    
                if let newPosts = newPosts {
                    // 초기 데이터를 posts 배열에 추가
                    self.posts += newPosts
                        
                    // 테이블 뷰 갱신
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Initial data fetch - Success")
                } else if let error = error {
                // 오류 처리
                print("Error fetching initial data: \(error.localizedDescription)")
            }
        }
    }
}
extension ProceedingTableTableViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func setTableview() {
        //UITableViewDelegate, UITableDataSource 프로토콜을 해당 뷰컨트롤러에서 구현
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        //UITableView에 셀 등록
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.leading.trailing.bottom.equalToSuperview().inset(0)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let post = posts[indexPath.row]
        cell.titleLabel.text = post.bill_name
        cell.dayLabel.text = "게시종료일 : " + post.noti
        cell.detailLabel.text = (post.proposer)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        showPostDetail(post: post)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //셀을 선택했을 때 해당 게시물의 상세 내용을 보여주기 위함
    func showPostDetail(post: ProceedingAPIModel){
        let detailViewController = ProceedingDetailViewController(post: post)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
extension ProceedingTableTableViewController {
    //진행중 입법예고
    func fetchPosts(page: Int, completion: @escaping ([ProceedingAPIModel]?, Error?) -> Void) {
        let urls = "https://open.assembly.go.kr/portal/openapi/nknalejkafmvgzmpt?KEY=9aabb437e71540e5a02aee015757865e&Type=json&plndex=\(page)&pSize=20"
        let urlss = URL(string: urls)
        // URLRequest 생성
        var request = URLRequest(url: urlss!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("에러 : \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, nil)
                return
            }
            //print(String(data: data, encoding: .utf8) ?? "데이터 출력 실패")

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let nknalejkafmvgzmpt = json?["nknalejkafmvgzmpt"] as? [[String: Any]],
                   let row = nknalejkafmvgzmpt.last?["row"] as? [[String: Any]] {
                    //print("결과 : \(nknalejkafmvgzmpt)")
                    var posts = [ProceedingAPIModel]()
                    
                    for item in row {
                        if let billName = item["BILL_NAME"] as? String,
                           let proposer = item["PROPOSER"] as? String,
                           let committee = item["CURR_COMMITTEE"] as? String,
                           let billNo = item["BILL_NO"] as? String,
                           let noti = item["NOTI_ED_DT"] as? String,
                           let proporser_cd = item["PROPOSER_KIND_CD"] as? String{
                            let post = ProceedingAPIModel(bill_name: billName, proposer_cd: proporser_cd, proposer: proposer, committee: committee, bill_no: billNo, noti: noti)
                            posts.append(post)
                        }
                    }
                    completion(posts, nil)
                }
            } catch let error as DecodingError {
                print("JSON 디코딩 에러: \(error)")
                completion(nil, error)
            } catch {
                print("기타 에러: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    //Refresh NewPage Method
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.clear
        self.tableView.refreshControl = refresh
    }
    @objc func refreshTable(refresh: UIRefreshControl) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.fetchPosts(page: self.currentPage) { [weak self] (newPosts, error) in
                        guard let self = self else { return }
                            
                        if let newPosts = newPosts {
                            // 초기 데이터를 posts 배열에 추가
                            self.posts.removeAll()
                            self.posts = newPosts
                                
                            // 테이블 뷰 갱신
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            print("Initial data fetch - Success")
                        } else if let error = error {
                        // 오류 처리
                        print("Error fetching initial data: \(error.localizedDescription)")
                    }
                }
                refresh.endRefreshing()
            }
        }
    //MARK: - UIRefreshControl of ScrollView
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y < -0.1) {
            self.refreshTable(refresh: self.refresh)
        }
    }
    //LoadNextPage Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView.contentOffset.y > (self.tableView.contentSize.height - self.tableView.bounds.size.height) && (posts.count % 20 == 0){
            self.fetchPosts(page: self.currentPage) { [weak self] (newPosts, error) in
                    guard let self = self else { return }
                        
                    if let newPosts = newPosts {
                        // 초기 데이터를 posts 배열에 추가
                        self.posts += newPosts
                            
                        // 테이블 뷰 갱신
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        print("Initial data fetch - Success")
                    } else if let error = error {
                    // 오류 처리
                    print("Error fetching initial data: \(error.localizedDescription)")
                }
            }
        }
    }
}
