//
//  ParentViewController.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 23/06/24.
//

import UIKit

class ParentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 8, y: 8, width: 60, height: 60))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader : UIAlertController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}
