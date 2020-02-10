//
//  NetworkEngine.swift
//  Payback
//
//  Created by Kaustubh on 07/02/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//
import Foundation

public typealias JSON = [String: Any]
public typealias HTTPHeaders = [String: String]

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


final class NetworkEngine {
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func load(path: String, method: RequestMethod, params: JSON, completion: @escaping (Any?, CustomError?) -> ()) -> URLSessionDataTask? {
        if !Reachability.isConnectedToNetwork() {
            completion(nil, CustomError(code: 4, type: "", message: "Not connected to internet"))
            return nil
        }
        
//        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params)
        let request = NSMutableURLRequest(url: NSURL(string:baseUrl)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = params as! [String : String]
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            // Parsing incoming data
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse {
                    if (200..<300) ~= httpResponse.statusCode || httpResponse.statusCode == 403 {
                        completion(data, nil)
                    }
                    else {
                        completion(nil, CustomError(code: httpResponse.statusCode, type: "Invalid", message: httpResponse.description))
                    }
                }else {
                    let error = try? JSONDecoder().decode(CustomError.self, from: data)
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        
        return task
    }
}

extension URL {
    init(baseUrl: String, path: String, params: JSON, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get, .delete:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    init(baseUrl: String, path: String, method: RequestMethod, params: JSON) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}
