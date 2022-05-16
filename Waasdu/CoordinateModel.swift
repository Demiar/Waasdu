////
////  Coordinate.swift
////  Waadsu test
////
////  Created by Алексей on 12.05.2022.
//
import Foundation

// MARK: - Coordinate
struct CoordinateModel: Codable {
    let type: String
    let features: [Feature]?
}

// MARK: - Feature
struct Feature: Codable {
    let type: String
    //let properties: Properties?
    let geometry: Geometry?
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [[[[Double]]]]?
}
