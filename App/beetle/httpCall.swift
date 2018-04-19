//
//  httpCall.swift
//  beetle
//
//  Created by ivo kroon on 10/04/2018.
//  Copyright © 2018 ivo kroon. All rights reserved.
//

import Foundation

class HttpCall{
    
    func makeGetCall(urlString:String, taskCallback: @escaping (Bool,
        AnyObject?) -> ()){
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // make the request
        URLSession(configuration: URLSessionConfiguration.default)
            .dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let data = try JSONSerialization
                     .jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                return taskCallback(true, data as AnyObject)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
                
        }.resume()
    }
    
    // MAKE AN POST CALL
    func makePostCall(urlString:String, dataCollection:Dictionary<String, Any>, taskCallBack: @escaping (Bool, AnyObject?) -> ()){
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        // CREATE NEW REQUEST
        var request = URLRequest(url: url)
        
        //GET THE DATA THAT NEED TO BE POSTED
        var postString:String = "";
        for (tag, data) in dataCollection{
            postString += "\(tag)=\(data)&"
        }
        // THE BODY
        request.httpBody = postString.data(using: .utf8)
        //WE NEED THIS
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        // WE ARE GOING TO POST
        request.httpMethod = "POST"
        // START
        URLSession.shared.dataTask(with: request)
        {data,response,error in
            guard error == nil else {
                print("Call failed url: ", url)
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do{
                guard let data = try JSONSerialization
                    .jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // SEND BACK AN ARRAY TO DO SUTFF WITH
                return taskCallBack(true, data as AnyObject)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }.resume()
    }
}
