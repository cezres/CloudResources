//
//  ResourceIndexState.swift
//  CloudAssetsManager
//
//  Created by azusa on 2022/6/9.
//

import Foundation
import ComposableArchitecture
import Combine

struct ResourceIndexState: Equatable, Identifiable {
    var index: ResourceIndexesRecord
    
    var id: String { index.id }
    
    var resources: [Resource] = [] {
        didSet {
            guard resources != oldValue else { return }
            makeDataList()
        }
    }
    
    var isActive: Bool = false
    var isLoading: Bool = false
    var error: String = ""
    var leftList: [Resource] = []
    var rightList: [Resource] = []
}

extension ResourceIndexState {
    mutating func makeDataList() {
        var tempList = resources
        leftList = index.indexes.map { (key, value) -> Resource in
            if let index = tempList.firstIndex(where: { $0.id == value.id }) {
                return tempList.remove(at: index)
            } else {
                return Resource(id: "", name: key, version: 0, pathExtension: "", fileChecksum: "")
            }
        }.sorted(by: { $0.name < $1.name })
        rightList = tempList.sorted(by: { $0.name < $1.name })
    }
}

enum ResourceIndexAction {
    case setActive(Bool)
    case setLoading(Bool)
    case setError(String)
    case tapLeft(Resource)
    case tapRight(Resource)
    case upload
    case download
    case delete
    case save
    case deleteCompletion
}

let resourceIndexReducer = Reducer<ResourceIndexState, ResourceIndexAction, AppEnvironment>.init { state, action, env in
    switch action {
    case .setActive(let value):
        state.isActive = value
    case .tapLeft(let value):
        if let index = state.leftList.firstIndex(of: value) {
            state.leftList.remove(at: index)
        }
        if !value.id.isEmpty {
            state.rightList.append(value)
        }
        return Effect.run { subscriber in
            subscriber.send(.save)
            return AnyCancellable { }
        }
    case .tapRight(let value):
        if let index = state.rightList.firstIndex(of: value) {
            state.rightList.remove(at: index)
        }
        if !value.id.isEmpty {
            state.leftList.append(value)
        }
        return Effect.run { subscriber in
            subscriber.send(.save)
            return AnyCancellable { }
        }
//        .throttle(for: 4, scheduler: env.mainQueue, latest: true)
//        .catchToEffect(ResourceIndexAction.save)
    case .save:
//        var indexes: [ResourceIndexes.ResourceName: ResourceIndexes.Record] = [:]
//        state.leftList.forEach { resource in
//            indexes[resource.name] = .init(id: resource.id)
//        }
//        state.index.indexes = indexes
//        let saveValue = state.index
//        return Effect.task {
//            do {
//                try env.database.save(saveValue)
//            } catch {
//                debugPrint(error)
//            }
//        }
//        .receive(on: env.mainQueue)
//        .fireAndForget()
        break
    case .upload:
        let indexes = state.index
        return Effect.run { subscriber in
            subscriber.send(.setLoading(true))
            
//            Task {
//                do {
//                    let result = try await env.cktool.updateResourceIndexRecord(indexes: indexes)
//                } catch {
//                    DispatchQueue.main.async {
//                        subscriber.send(.setError(error.toString()))
//                    }
//                }
//                
//                DispatchQueue.main.async {
//                    subscriber.send(.setLoading(false))
//                }
//            }

            return AnyCancellable {}
        }
    case .download:
        break
    case .delete:
        let recordName = state.index.id
        let indexes = state.index
        state.isLoading = true
        return Effect.run { subscriber in
//            Task {
//                do {
//                    try await env.cktool.deleteRecord(recordName: recordName)
//                } catch {
//                    DispatchQueue.main.async {
//                        subscriber.send(.setError(error.toString()))
//                    }
//                }
//                try indexes.delete(to: env.database.database()!)
//                DispatchQueue.main.async {
//                    subscriber.send(.setActive(false))
//                    subscriber.send(.deleteCompletion)
//                }
//            }
            return AnyCancellable {}
        }
    case .deleteCompletion:
        state.isLoading = false
    case .setLoading(let value):
        state.isLoading = value
    case .setError(let value):
        state.error = value
    }
    return .none
}

