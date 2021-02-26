//
//  ViewController.swift
//  SchmoozeApp
//
//  Created by Ondrej Rafaj on 24/02/2021.
//

import UIKit
import SnapKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        func add(button title: String, position: Int) {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(go), for: .touchUpInside)
            button.backgroundColor = .lightGray
            button.setTitleColor(.darkText, for: .normal)
            button.setTitleColor(.darkGray, for: .highlighted)
            button.layer.cornerRadius = 8
            
            view.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.top.equalTo((120 + position * 60))
                make.leading.equalTo(view).offset(16)
                make.height.equalTo(44)
                make.trailing.equalTo(view).offset(-16)
            }
            
            go(button)
        }
        
        add(button: "GET", position: 0)
        add(button: "POST", position: 1)
        add(button: "PUT", position: 2)
        add(button: "PATCH", position: 3)
        add(button: "DELETE", position: 4)
        add(button: "OPTION", position: 5)
        
        // Test unfulfilled request
        var hangingRequest = URLRequest(url: URL(string: "https://www.raywenderlich.com/robots.txt")!)
        hangingRequest.httpMethod = "HANGING"
        Tracker.default.register(request: hangingRequest)
        
        // Test Error
        let req = URLRequest(url: URL(string: "https://www.raywenderlich.com/errors/errors/errors/errors/errors/errors/errors/errors/errors/errors/errors/errors/errors/errors.txt?/errors&errors/errors/errors")!)
        hangingRequest.httpMethod = "ERROR"
        let errorRequest = Tracker.default.register(request: req)
        
        enum Error: Swift.Error {
            case myConnectionError
        }
        
        Tracker.default.register(response: Error.myConnectionError.schmoozify(), for: errorRequest)
    }
    
    @objc func go(_ sender: UIButton) {
        var req = URLRequest(url: URL(string: "https://www.raywenderlich.com/robots.txt")!)
        req.httpMethod = sender.title(for: .normal)
        
        let trackerRequest = Tracker.default.register(request: req)
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: req) { (data, response, error) in
            Tracker.default.handle(data: data, response: response, error: error, for: trackerRequest)
        }
        task.resume()
    }


}

