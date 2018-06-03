//
//  Heap.swift
//
//  Created by apple on 01/06/18.
//  Copyright © 2018 shiv. All rights reserved.
//

import Foundation

public struct Heap<T> {
    
    // type of nodes contained in the array
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
    
    // parent node index
    @inline(__always) internal func parentIndex(ofIndex i: Int) -> Int {
        return (i-1)/2
    }
    
    // left child Index
    @inline(__always) internal func leftChildIndex(ofIndex i: Int) -> Int {
        return (2*i + 1)
    }
    
    // right child Index
    @inline(__always) internal func rightChildIndex(ofIndex i: Int) -> Int {
        return (2*i + 2)
    }
    
    // top element in the Heap
    // maximum for max-heap and minimum for min-heap
    public func peek() -> T? {
        return nodes.first
    }
    
    // inserting a single element
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    
    // function adds the sequence of values to the heap.
    // this reorders the heap so that the max heap or
    // min-heap property still holds. O(logn)
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        // insert each value of the sequence to the heap
        for value in sequence {
            insert(value)
        }
    }
    
    /** allows to change an element. This reorders the heap
        so that the max-heap or min-heap property still holds
     **/
    public mutating func replace(index i: Int, value: T) {
        
        // check that this index is less than the total nodes count in the heap
        guard i < nodes.count else { return }
        
        remove(at: i)
        insert(value)
    }
    
    /** Remove the root node from the heap in O(logn) **/
    @discardableResult public mutating func remove() -> T? {
       
        guard !nodes.isEmpty else { return nil }
        
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            // use the last node to replace the first one
            // then fix the heap by shifting this new first node into its proper position
            let value = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(0)
            return value
        }
    }
    
    internal mutating func shiftUp(_ index: Int) {
        
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
            nodes[childIndex] = nodes[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        nodes[childIndex] = child
    }
    
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
        
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = leftChildIndex + 1
        
        var first = index
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex],nodes[first]) {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex],nodes[first]) {
            first = rightChildIndex
        }
        if first == index { return }
        
        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }
    
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
    
}


extension Heap where T: Equatable {
    
    public func index(of node: T) -> Int? {
        return nodes.index(where: {$0 == node })
    }
    
    /** Removes the first occurrence of a node from the heap. **/
    @discardableResult public mutating func remove(node: T) -> T? {
        if let index = index(of: node) {
            return remove(at: index)
        }
        
        return nil
    }
}


