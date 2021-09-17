//
//  Enums.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/27/21.
//

import UIKit

extension MainViewController {

    // MARK: Enums

    enum DesignConstants {
        static var titleTopConstraint: CGFloat { return 60 }
        static var titleLeftConstraint: CGFloat { return 32 }
        static var doneTasksToTitleConstraint: CGFloat { return 18 }
        static var addItemButtonFrames: CGFloat { return 44 }
        static var addItemButtonBottomConstraint: CGFloat { return -54 }
        static var showHideButtonRightConstraing: CGFloat { return -32 }
        static var defaultCornerRadius: CGFloat { return 16 }
    }

    enum FontSizes {
        static var title: CGFloat { return 34 }
        static var underTitleLabels: CGFloat { return 15 }
    }

    enum CompletedTasksCondition {
        case hideCompleted
        case showCompleted
    }

}
