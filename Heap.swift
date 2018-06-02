//
//  Heap.swift
//
//  Created by apple on 01/06/18.
//  Copyright © 2018 shiv. All rights reserved.
//

import Foundation

public struct Heap<T> {
    
    // type of nodes and number of nodes
    var nodes = [T]()
    
    private var orderCriteria: (T, T) -> Bool
    
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
    }
    
    // building Heap
    private mutating func configureHeap(from array: [T]) {
        nodes = array
        for i in stride(from: (nodes.count/2-1), through: 0, by: -1) {
            shiftDown(i)
        }
    }
    
    // is the heap is empty or not
    public var isEmpty: Bool {
        return nodes.isEmpty
    }
    
    // number of nodes in the heap
    public var count: Int {
        return nodes.count
    }
    
    @inline(__always) internal func 
}

