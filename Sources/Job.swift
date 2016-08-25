/*
 * Jenkins Swift Client
 */
import Foundation

public final class Job {
    private(set) var builds: [Build] = []
    private(set) var buildable: Bool?
    private(set) var color: String?
    private(set) var concurrentBuild: Bool?
    private(set) var jobDescription: String?
    private(set) var displayName: String?
    private(set) var firstBuild: Build?
    private(set) var healthReports: [HealthReport] = []
    private(set) var inQueue: Bool?
    private(set) var keepDependencies: Bool?
    private(set) var lastBuild: Build?
    private(set) var lastCompletedBuild: Build?
    private(set) var lastFailedBuild: Build?
    private(set) var lastStableBuild: Build?
    private(set) var lastSuccessfulBuild: Build?
    private(set) var lastUnstableBuild: Build?
    private(set) var lastUnsuccessfulBuild: Build?
    private(set) var name: String
    private(set) var nextBuildNumber: Int?
    private(set) var queueItem: JobQueueItem?
    private(set) var url: String?
    
    init(json: JSON) {
        guard let url = json["url"] as? String,
            let name = json["name"] as? String else {
                self.name = ""
                self.url = ""
                return
        }
        
        self.name = name
        self.url = url
        
        if let builds = json["builds"] as? [JSON] {
            for buildDict in builds {
                let newBuild = Build(json: buildDict)
                self.builds.append(newBuild)
            }
        }
        
        if let buildable = json["buildable"] as? Bool {
            self.buildable = buildable
        }
        
        if let color = json["color"] as? String {
            self.color = color
        }
        
        if let concurrentBuild = json["concurrentBuild"] as? Bool {
            self.concurrentBuild = concurrentBuild
        }
        
        if let jobDescription = json["description"] as? String {
            self.jobDescription = jobDescription
        }
        
        if let displayName = json["displayName"] as? String {
            self.displayName = displayName
        }
        
        if let firstBuild = json["firstBuild"] as? JSON {
            self.firstBuild = Build(json: firstBuild)
        }
        
        if let healthReports = json["healthReport"] as? [JSON] {
            for healthReportJSON in healthReports {
                let report = HealthReport(json: healthReportJSON)
                self.healthReports.append(report)
            }
        }
        
        if let lastBuild = json["lastBuild"] as? JSON {
            self.lastBuild = Build(json: lastBuild)
        }
        
        if let lastCompletedBuild = json["lastCompletedBuild"] as? JSON {
            self.lastCompletedBuild = Build(json: lastCompletedBuild)
        }
        
        if let lastFailedBuild = json["lastFailedBuild"] as? JSON {
            self.lastFailedBuild = Build(json: lastFailedBuild)
        }
        
        if let lastStableBuild = json["lastStableBuild"] as? JSON {
            self.lastStableBuild = Build(json: lastStableBuild)
        }
        
        if let lastSuccessfulBuild = json["lastSuccessfulBuild"] as? JSON {
            self.lastSuccessfulBuild = Build(json: lastSuccessfulBuild)
        }
        
        if let lastUnstableBuild = json["lastUnstableBuild"] as? JSON {
            self.lastUnstableBuild = Build(json: lastUnstableBuild)
        }
        
        if let lastUnsuccessfulBuild = json["lastUnsuccessfulBuild"] as? JSON {
            self.lastUnsuccessfulBuild = Build(json: lastUnsuccessfulBuild)
        }
        
        if let nextBuildNumber = json["nextBuildNumber"] as? Int {
            self.nextBuildNumber = nextBuildNumber
        }
        
        if let queueItem = json["queueItem"] as? JSON {
            self.queueItem = JobQueueItem(json: queueItem)
        }
        
    }
}

extension Job : CustomStringConvertible {
    public var description: String {
        return "Job \(name) @ \(url)"
    }
}

// MARK: Job

public extension Jenkins {
    func fetchJobs(_ handler: ([Job]) -> Void) {
        guard let url = URL(string: jenkinsURL)?
            .appendingPathComponent("api")
            .appendingPathComponent("json") else {
            handler([])
            return
        }
        
        client?.get(path: url) { response, error in
            guard let json = response as? JSON,
                let jobsJSON = json["jobs"] as? [JSON] else {
                    handler([])
                    return
            }
            
            let jobs = jobsJSON.map { json in
                return Job(json: json)
            }
            
            handler(jobs)
        }
    }
    
    func fetch(_ job: String, _ handler: (job: Job?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(job)
            .appendingPathComponent("api")
            .appendingPathComponent("json") else {
            handler(job: nil)
            return
        }
        
        client?.get(path: url) { response, error in
            guard let json = response as? JSON else {
                handler(job: nil)
                return
            }
            
            handler(job: Job(json: json))
        }
    }
    
    func fetch(_ job: Job, _ handler: (job: Job?) -> Void) {
        return fetch(job.name, handler)
    }
}

// MARK: Enabling and Disabling Jobs

public extension Jenkins {
    func enable(_ job: Job, _ handler: (error: Error?) -> Void) {
        enable(job: job.name, handler)
    }
    
    func enable(job named: String, _ handler: (error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(named)
            .appendingPathComponent("enable") else {
                handler(error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        client?.post(path: url) { response, error in
            handler(error: error)
        }
    }
    
    func disable(_ job: Job, _ handler: (error: Error?) -> Void) {
        disable(job: job.name, handler)
    }
    
    func disable(job named: String, _ handler: (error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(named)
            .appendingPathComponent("disable") else {
                handler(error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        client?.post(path: url) { response, error in
            handler(error: error)
        }
    }
}

// MARK: Build Jobs

public extension Jenkins {
    func build(_ name: String, parameters: [String : String], _ handler: (error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("buildWithParameters") else {
                handler(error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        client?.post(path: url, params: parameters) { response, error in
            handler(error: error)
        }
    }
    
    func build(_ job: Job, parameters: [String : String], _ handler: (error: Error?) -> Void) {
        build(job.name, parameters: parameters, handler)
    }
    
    func build(_ name: String, _ handler: (error: Error?) -> Void) {
        guard let url = URL(string: jobURL)?
            .appendingPathComponent(name)
            .appendingPathComponent("build") else {
                handler(error: JenkinsError.InvalidJenkinsURL)
                return
        }
        
        client?.post(path: url) { response, error in
            if let statusCode = response?.statusCode {
                if statusCode == 400 {
                    handler(error: JenkinsError.JobRequiresParameters)
                }
            }
            
            handler(error: error)
        }
    }
    
    func build(job: Job, _ handler: (error: Error?) -> Void) {
        build(job.name, handler)
    }
}
