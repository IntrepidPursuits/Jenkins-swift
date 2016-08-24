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
                return
        }
        
        if let builds = json["builds"] as? [JSON] {
            for buildDict in builds {
                let newBuild = Build(json: buildDict)
                self.builds.append(newBuild)
            }
        }
        
        self.buildable = json["buildable"] as? Bool
        self.color = json["color"] as? String
        self.concurrentBuild = json["concurrentBuild"] as? Bool
        self.jobDescription = json["description"] as? String
        self.displayName = json["displayName"] as? String
        
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
        
        self.name = name
        self.nextBuildNumber = json["nextBuildNumber"] as? Int
        
        if let queueItem = json["queueItem"] as? JSON {
            self.queueItem = JobQueueItem(json: queueItem)
        }
        self.url = url
    }
}

extension Job : CustomStringConvertible {
    public var description: String {
        return "Job \(name) @ \(url)"
    }
}

    
        
    }
}
