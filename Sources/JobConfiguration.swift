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
    func fetchJobConfiguration(_ job: Job, _ handler: (response: String?, error: Error?) -> Void) {
        fetchJobConfiguration(job.name, handler)
    }
    
    func fetchJobConfiguration(_ name: String, _ handler: (response: String?, error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("config.xml") else {
                handler(response: nil, error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        fetchJobConfiguration(url: url, handler)
    }
    
    func fetchJobConfiguration(url: URL, _ handler: (response: String?, error: Error?) -> Void) {
        client?.get(path: url, rawResponse: true) { xml, error in
            
            if let xml = xml as? String {
                handler(response: xml, error: nil)
                return
            }
            
            handler(response: nil, error: error)
        }
    }
}

// MARK: Job Configuration crud operations

public extension Jenkins {
    func create(_ job: Job, configuration: JobConfiguration, _ handler: (error: Error?) -> Void) {
        create(job.name, configuration: configuration, handler)
    }
    
    func create(_ name: String, configuration: JobConfiguration, _ handler: (error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("createItem") else {
                handler(error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        client?.post(path: url, body: configuration) { response, error in
            
        }
    }
    
    func update(_ job: Job, description: String, _ handler: (error: Error?) -> Void) {
        update(job.name, description: description, handler)
    }
    
    func update(_ name: String, description: String, _ handler: (error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("description") else {
                handler(error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        client?.post(path: url, params: ["description" : description]) { response, error in
            handler(error: error)
        }
    }
    
    func update(_ job: Job, configuration: JobConfiguration, _ handler: (error: Error?) -> Void) {
        update(job.name, configuration: configuration, handler)
    }
    
    func update(_ name: String, configuration: JobConfiguration, _ handler: (error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("config.xml") else {
                handler(error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        client?.post(path: url, body: configuration) { response, error in
            handler(error: error)
        }
    }
    
    func delete(_ job: Job, _ handler: (error: Error?) -> Void) {
        delete(job.name, handler)
    }
    
    func delete(_ name: String, _ handler: (error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("doDelete") else {
                handler(error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        client?.post(path: url) { response, error in
            handler(error: error)
        }
    }

}

