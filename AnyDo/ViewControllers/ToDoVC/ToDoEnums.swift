//
//  Enums.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/27/21.
//

import UIKit

extension ToDoViewController {

    // MARK: Enums

    enum DesignConstants {
        static var defaultPadding: CGFloat { return 16 }
        static var taskOptionsCellHeight: CGFloat { return 58.5 }
        static var dividerHeight: CGFloat { return 0.5 }
        static var taskDescriptionViewHeight: CGFloat { return 120 }
        static var taskTextViewHeight: CGFloat { return 100 }
        static var datePickerLeftRightTopConstraints: CGFloat { return 8 }
        static var taskTextViewLeftRightTopConstraints: CGFloat { return 8 }
        static var deleteButtonHeight: CGFloat { return 56 }
        static var defaultCornRadius: CGFloat { return 16 }
        static var defaultNavBarHeight: CGFloat { return 44 }
        static var calendarInfoStackHeight: CGFloat { return 40 }
    }

    enum FontSizes {
        static var taskTextViewFontSize: CGFloat { return 17 }
    }
    
}
