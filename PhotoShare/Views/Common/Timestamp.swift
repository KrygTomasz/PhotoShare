//
//  Timestamp.swift
//  PhotoShare
//
//  Created by Krygu on 14/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import Foundation

protocol HasTimestamp {
    var timestamp: Double { get }
}

func insertSortedByTimestamp<T: HasTimestamp>(array: inout [T], item: T) -> IndexPath {
    var insertIndex = 0
    for i in 0..<array.count {
        if item.timestamp <= array[i].timestamp {
            if i == array.count - 1 {
                insertIndex = i + 1
            } else {
                if item.timestamp >= array[i+1].timestamp {
                    insertIndex = i + 1
                }
            }
        }
    }
    array.insert(item, at: insertIndex)
    return IndexPath(item: insertIndex, section: 0)
}

func insertSortedReversedByTimestamp<T: HasTimestamp>(array: inout [T], item: T) -> IndexPath {
    var insertIndex = 0
    for i in 0..<array.count {
        if item.timestamp >= array[i].timestamp {
            if i == array.count - 1 {
                insertIndex = i + 1
            } else {
                if item.timestamp <= array[i+1].timestamp {
                    insertIndex = i + 1
                }
            }
        }
    }
    array.insert(item, at: insertIndex)
    return IndexPath(item: insertIndex, section: 0)
}
