//
//  SpoonacularServerError.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/23/24.
//

public struct SpoonacularServerError: Decodable, Error {
    public let code: Int
    public let message: String
    public let status: String
}
