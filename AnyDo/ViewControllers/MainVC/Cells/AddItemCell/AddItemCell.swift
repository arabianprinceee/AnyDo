//
//  AddItemCell.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/27/21.
//

import UIKit

class AddItemCell: UITableViewCell, UITextFieldDelegate {

    var onTextDidChange: ((String) -> Void)?
    static let identifier: String = "AddItemCell"

    private var textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = NSLocalizedString("new", comment: "")
        textfield.textColor = .gray
        textfield.font = UIFont.systemFont(ofSize: 17)
        return textfield
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(textField)
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(named: "CardsBackground")

        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 56),
            textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 53),
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text != "" {
            onTextDidChange?(text)
            self.textField.endEditing(true)
            self.textField.text = nil
            return true
        }
        self.textField.endEditing(true)
        self.textField.text = nil
        return false
    }
}
