//
//  ContentView.swift
//  UserDefaultNilCheck
//
//  Created by Marcus Wu on 2024/6/26.
//

import SwiftUI
import Foundation

extension UserDefault where T: ExpressibleByNilLiteral {
    
    init(key: String, _ userDefaults: UserDefaults = .standard) {
        self.init(key, defaultValue: nil, userDefaults: userDefaults)
    }
    
}

@propertyWrapper
public struct UserDefault<T> {
    
    private let key: String
    
    private let defaultValue: T
    
    private let userDefaults: UserDefaults
        
    public init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    public var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) else {
                return defaultValue
            }
            
            return value as? T ?? defaultValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil() {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
    
}

public protocol OptionalProtocol {
    
    func isNil() -> Bool
    
}

extension Optional: OptionalProtocol {
    
    public func isNil() -> Bool {
        self == nil
    }
    
}

struct ContentView: View {
    
    @UserDefault("test", defaultValue: nil) var testCrash: String?
    
    init() {
        testCrash = nil
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
