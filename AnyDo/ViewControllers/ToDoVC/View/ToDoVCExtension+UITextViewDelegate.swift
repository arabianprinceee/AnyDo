//
//  ToDoVCExtension+UITextViewDelegate.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/19/21.
//

import UIKit

extension ToDoViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
}

