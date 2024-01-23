//
//  ChatGptAPIMethod.swift
//  LawLens
//
//  Created by 정성윤 on 2024/01/10.
//

import Foundation
import ChatGPTSwift
class ChatGptAPIMethod {
    static var ChatGptContent = ""
    static var ChatGptReport = ""
    static var Duplicate = 0
    //퍼센트
    static var Percent = ""
    var userInfo = UserInfoModel(name: "", age: "", gender: "", location: "", job: "", hobby: "", income: "", family: "", religion: "", health: "", Disability: "")
    static func generateChatGPTResponse(petitionSummary: String, completion: @escaping (Bool) -> Void) {
        let apiKey = "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"
        let endpoint = "https://api.openai.com/v1/chat/completions"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // 저장된 값 불러오기
        var UserInfo = UserInfoModel(name: "", age: "", gender: "", location: "", job: "", hobby: "", income: "", family: "", religion: "", health: "", Disability: "")
        if let retrievedDict = UserDefaults.standard.dictionary(forKey: "UserInfo") {
                    UserInfo.name = retrievedDict["성명"] as? String ?? ""
                    UserInfo.age = retrievedDict["나이"] as? String ?? ""
                    UserInfo.gender = retrievedDict["성별"] as? String ?? ""
                    UserInfo.location = retrievedDict["거주 지역"] as? String ?? ""
                    UserInfo.job = retrievedDict["직업"] as? String ?? ""
                    UserInfo.hobby = retrievedDict["취미"] as? String ?? ""
                    UserInfo.income = retrievedDict["소득 수준"] as? String ?? ""
                    UserInfo.family = retrievedDict["가족 구성원"] as? String ?? ""
                    UserInfo.religion = retrievedDict["종교"] as? String ?? ""
                    UserInfo.health = retrievedDict["건강 상태"] as? String ?? ""
                    UserInfo.Disability = retrievedDict["장애 여부"] as? String ?? ""
            let parameters: [String: Any] = [
                "model": "gpt-3.5-turbo",
                "messages": [
                    ["role": "system", "content": "You are the person who manages petitions in the National Assembly. Let me know what changes will happen to me if this petition is approved. Please let me know about the changes in relation to my information that will be provided next. And guess how directly you think the petition is related to me, in terms of percentage. The answer format is as follows. 1.Social changes that will occur if the petition is approved 2.Changes to me 3.Relevance Prediction and Expected Percentage. You must answer in Korean."],
                    ["role": "user", "content": "petition summary : \(petitionSummary), My information : \"age : \(UserInfo.age), sex : \(UserInfo.gender), residence : \(UserInfo.location), job : \(UserInfo.job), hobby : \(UserInfo.hobby), income level : \(UserInfo.income), family member : \(UserInfo.family), religion : \(UserInfo.religion), health condition : \(UserInfo.health), Disability : \(UserInfo.Disability)\""]
                ]
            ]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else {
                print("Invalid HTTP body")
                return
            }
            
            request.httpBody = httpBody
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    completion(false)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let choices = json["choices"] as? [[String: Any]],
                               let firstChoice = choices.first,
                               let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        ChatGptContent = content
                        // 정규표현식을 사용하여 % 기호 앞에 있는 숫자 추출
                        let regex = try! NSRegularExpression(pattern: "(\\d+)%")
                        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

                        // 추출된 숫자 출력
                        for match in matches {
                            if let range = Range(match.range(at: 1), in: content) {
                                let number = content[range]
                                Percent = String(number)
                                print(number)
                            }
                        }
                        print("Content: \(content)")
                        completion(true)
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                    completion(false)
                }
            }
            task.resume()
        }
    }
    static func reportChatGPTResponse(EffectText : String, contentText : String, completion: @escaping (Bool) -> Void) {
        let apiKey = "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"
        let endpoint = "https://api.openai.com/v1/chat/completions"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are the one who writes petitions to the National Assembly. Please write a detailed petition based on the purpose of the petition and the brief contents of the petition provided. The petition must be able to get a lot of people's approval. The answer format is as follows. 1. purpose of the petition. 2. contents of the petition. You must answer in Korean."],
                ["role": "user", "content": "purpose of the petition : \(EffectText), brief contents of the petition : \(contentText)"]
            ]
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Invalid HTTP body")
            return
        }
        
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let choices = json["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    ChatGptReport = content
                    print("Content: \(content)")
                    completion(true)
                }
            } catch {
                print("JSON parsing error: \(error)")
                completion(false)
            }
        }
        task.resume()
    }
    static func DuplicateCheck(AIReportText : String, PetitionList : [PetitionAPIModel], completion: @escaping (Bool) -> Void){
        let apiKey = "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"
        let endpoint = "https://api.openai.com/v1/chat/completions"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "Compare my petition with existing petitions and tell me the number of similar petitions. N number. like this. Just tell me the numbers. 8. Like this."],
                ["role": "user", "content": "my petition : \(AIReportText), existing petition : \(PetitionList)"]
            ]
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Invalid HTTP body")
            return
        }
        
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let choices = json["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    // 정규 표현식을 사용하여 숫자 추출
                    let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
                    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
                    let numberString = matches.map {
                        String(content[Range($0.range, in: content)!])
                    }.joined()
                    
                    // 추출된 숫자를 숫자로 변환
                    if let number = Int(numberString) {
                        Duplicate = number
                        print("Number: \(number)")
                        completion(true)
                    } else {
                        print("Failed to extract number from content")
                        completion(false)
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
                completion(false)
            }
        }
        task.resume()
    }
}
