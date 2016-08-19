/*
 * Jenkins Swift Client
 */

public final class Job {
    private(set) var buildable = false
    private(set) var color = ""
    private(set) var concurrentBuild = false
    private(set) var jobDescription = ""
    private(set) var displayName = ""
    private(set) var firstBuild: Build?
    private(set) var healthReports: [HealthReport] = []
    private(set) var inQueue = false
    private(set) var keepDependencies = false
    private(set) var lastBuild: Build?
    private(set) var lastCompletedBuild: Build?
    private(set) var lastFailedBuild: Build?
    private(set) var lastStableBuild: Build?
    private(set) var lastSuccessfulBuild: Build?
    private(set) var lastUnstableBuild: Build?
    private(set) var lastUnsuccessfulBuild: Build?
    private(set) var name = ""
    private(set) var nextBuildNumber = 0
    private(set) var queueItem: JobQueueItem?
    private(set) var scm = ""
    private(set) var url = ""

    init(json: JSON) {
        
    }
}

extension Job : CustomStringConvertible {
    public var description: String {
        return "Job @ (\(url)) - \(name)"
    }
}

public final class JobQueueItem {
    var blocked = false
    var buildable = false
    var buildableStartTime = 0
    var id = 0
    var timeSinceQueue = 0
    var parameters = ""
    var isStuck = false
    var taskName = ""
    var taskURL = ""
    var queueReason = ""
    
    init(json: JSON) {
        
    }
}
