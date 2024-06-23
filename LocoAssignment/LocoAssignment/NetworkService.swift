//
//  NetworkService.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 22/06/24.
//

import Foundation
import UIKit

class NetworkService {
    
    ///Singleton pattern
    static let shared = NetworkService()
    private init() {}

    private let task = URLSession.shared
    
    /// this function is used to place network requests
    /// - Parameters:
    ///   - request: URLRequest containing all the details
    ///   - completion: closure to be used when response is fetched
    func makeRequest(
        request: URLRequest,
        completion: @escaping (
            _ data: Data? ,
            _ response: URLResponse? ,
            _ error: Error?
        ) -> ()
    ) {            
        let dataTask = task.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode < 200 || httpResponse.statusCode > 204 {
                        completion(nil , response , error)
                        return
                    }
                }
                guard let err = error else {
                    completion(data , response , nil)
                    return
                }
                print("error while calling the API")
                completion(nil , response , err)
            }
            dataTask.resume()
    }
    
    /// This function is for downloading the image from the servier
    /// - Parameters:
    ///   - url: URL of the image
    ///   - completion: closure to take action on the image which is downloaded
    func loadImage(from url: URL, completion: @escaping (_ image: UIImage) -> ()) {
        let dataTask = task.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("Could not create image from data")
            }
        }
        dataTask.resume()
    }
}
