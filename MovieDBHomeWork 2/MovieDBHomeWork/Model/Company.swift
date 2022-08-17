//
//  Company.swift
//  ChallengeMovieDB
//
//  Created by Christian Quicano on 2/23/22.
//

import Foundation

struct Company: Codable {
    let logoPath: String?
    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
    }
}
