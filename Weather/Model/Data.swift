//
//  Data.swift
//  Weather
//
//  Created by Daniil G on 01.10.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import Foundation

extension Date {
    func week() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
