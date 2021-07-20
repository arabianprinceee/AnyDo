//
//  Extensions.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/20/21.
//

import Foundation

extension Double {

    func toInt() -> Int? {
        guard (self <= Double(Int.max).nextDown) && (self >= Double(Int.min).nextUp) else {
            return nil
        }
        return Int(self)
    }

}
