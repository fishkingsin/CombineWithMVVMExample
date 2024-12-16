//
//  Combine+ignoreNil.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 16/12/2024.
//

import Combine

func ignoreNil<T>(_ value: T?) -> AnyPublisher<T, Never> {
    value.map { Just($0).eraseToAnyPublisher()} ?? Empty().eraseToAnyPublisher()
}

