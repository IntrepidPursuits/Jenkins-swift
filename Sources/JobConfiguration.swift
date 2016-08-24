//
//  JobConfiguration.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 8/22/16.
//
//

import Foundation

public typealias JobConfiguration = String

// MARK: Job Configuration

public extension Jenkins {
    func fetchJobConfiguration(_ job: Job, handler: (response: String?, error: Bool) -> Void) {
        fetchJobConfiguration(job.name, handler: handler)
    }
    
    func fetchJobConfiguration(_ name: String, handler: (response: String?, error: Bool) -> Void) {
        guard let url = URL(string: baseURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("config.xml") else {
                handler(response: nil, error: true)
                return
        }
        
        fetchJobConfiguration(url: url, handler: handler)
    }
    
    func fetchJobConfiguration(url: URL, handler: (response: String?, error: Bool) -> Void) {
        client?.get(path: url, rawResponse: true) { xml in
            if let xml = xml as? String {
                handler(response: xml, error: false)
            }
            
            handler(response: nil, error: true)
        }
    }
}

// MARK: Job Configuration crud operations

public extension Jenkins {
    func create(_ job: Job, configuration: JobConfiguration, handler: (error: Bool) -> Void) {
        create(job.name, configuration: configuration, handler: handler)
    }
    
    func create(_ name: String, configuration: JobConfiguration, handler: (error: Bool) -> Void) {
        guard let url = URL(string: baseURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("createItem") else {
                handler(error: true)
                return
        }
        
        client?.post(path: url, body: configuration) { response in
            handler(error: (response == nil))
        }
    }
    
    func update(_ job: Job, description: String, handler: (error: Bool) -> Void) {
        update(job.name, description: description, handler: handler)
    }
    
    func update(_ name: String, description: String, handler: (error: Bool) -> Void) {
        guard let url = URL(string: baseURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("description") else {
                handler(error: true)
                return
        }
        
        client?.post(path: url, params: ["description" : description]) { response in
            handler(error: (response == nil))
        }
    }
    
    func update(_ job: Job, configuration: JobConfiguration, handler: (error: Bool) -> Void) {
        update(job.name, configuration: configuration, handler: handler)
    }
    
    func update(_ name: String, configuration: JobConfiguration, handler: (error: Bool) -> Void) {
        guard let url = URL(string: baseURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("config.xml") else {
                handler(error: true)
                return
        }
        
        client?.post(path: url, body: configuration) { response in
            handler(error: (response == nil))
        }
    }
    
    func delete(_ job: Job, handler: (error: Bool) -> Void) {
        delete(job.name, handler: handler)
    }
    
    func delete(_ name: String, handler: (error: Bool) -> Void) {
        guard let url = URL(string: baseURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("doDelete") else {
                handler(error: true)
                return
        }
        
        client?.post(path: url) { response in
            handler(error: (response == nil))
        }
    }

}

