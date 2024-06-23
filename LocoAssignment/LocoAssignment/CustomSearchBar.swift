//
//  CustomSearchBar.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 22/06/24.
//

import UIKit

protocol SearchBarProtocol: AnyObject {
    func searchItem(query: String)
    func searchTapped()
    func didEndEditing(text: String)
}

class CustomSearchBar: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchIconImageView: UIImageView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!

    weak var delegate : SearchBarProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CustomSearchBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let clearButton = searchField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButton.tintColor = .darkGray
        }
        searchIconImageView.image = UIImage(systemName: "magnifyingglass")
        searchIconImageView.tintColor = .darkGray
        searchField.textColor = .black
        searchField.tintColor = .systemBlue
        searchField.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        searchField.delegate = self

        searchBarView.backgroundColor = UIColor(red: 48, green: 49, blue: 52, alpha: 1)

        searchBarContainerView.layer.cornerRadius = 16
        searchBarContainerView.layer.borderColor = UIColor.white.cgColor
        searchBarContainerView.layer.borderWidth = 2
        searchBarView.autoresizingMask = [.flexibleWidth]

        searchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        delegate?.searchItem(query: self.searchField.text?.lowercased() ?? "")
    }
}

extension CustomSearchBar: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.searchTapped()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let str = (textField.text as String?) else { return }
        self.delegate?.didEndEditing(text: str)
    }
}
