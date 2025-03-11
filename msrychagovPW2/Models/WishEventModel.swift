//
//  WishEventModel.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//


import UIKit

struct WishEventModel: Codable {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var eventIdentifier: String?
}
