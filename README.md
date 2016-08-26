# Jenkins-Swift
---

![Swift](http://img.shields.io/badge/swift-v3.0--dev.07.25-brightgreen.svg)
[![Build Status](https://travis-ci.org/IntrepidPursuits/Jenkins-swift.svg?branch=master)](https://travis-ci.org/IntrepidPursuits/Jenkins-swift)

Jenkins-Swift is a Jenkins CI client, written in Swift for MacOS. The client uses a development snapshot of Swift 3. The project will be updated to follow the latest Swift 3 snapshots as they're released.

The client allows for some simple control of Jenkins jobs and builds. With Jenkins-Swift you can accomplish a variety of tasks including:
  - Fetching all the jobs on your Jenkins servers
  - Fetching individual jobs
  - Creating, Updating and copying jobs
  - Deleting jobs
  - Retrieving information about the builds for a jobs

___

## Connecting

Initializing the client with the hostname, or IP address of Jenkins, as well as your port, username, API token and optionally a path to where your jobs are located and the transport method.

For example if your jobs live at `http://jenkins.myHost.com:8080/jobs/`

You can initialize the jenkins client like so:

    jenkins = try! Jenkins(host: "jenkins.myHost.com",
                           port: 8080,
                           user: "MyUsername",
                          token: "MyAPIToken",
                           path: "jobs")

The client will throw an error if the URL it builds from this data is invalid.

You can find your API token by logging into Jenkins and going to the `Configure` section of your profile. This section will have a button titled `Show API Token` to get your token. It's recommended to create a new user if deploying the Jenkins client on a server.

___

## Models

Jenkins passes partial objects back from calls that can potentially return a lot of data. Specifically this happens when requesting all jobs, or all builds for a job. The objects returned generally will only include a `name`, `url`, and possibly an `id`.

Fetching a single job or a single build will return all of the data associated with that object.

___

## Functions

#### Fetch Single Job

Fetching jobs is as simple as passing a name, or a Job object to one of the fetch functions.

    jenkins.fetch("MyProject") { job in
      if let job = job {
        print(job)
      }
      ...
    }

Passing a job object achieves the same effect, and serves as a convenience method.

#### Fetch All Jobs

Fetching all jobs will return partial job objects:

    jenkins.fetchJobs { jobs in
      print("Number of jobs: \(jobs.count)")
      ...
    }

#### Fetch Job Configuration XML

You may also wish to fetch the configuration for a job on Jenkins. This configuration is the XML tree used to create and update jobs. Currently no client side parsing is done, and the XML is passed back to the fetch configuration function.

    jenkins.fetchJobConfiguration("MyProject") { xml, error in
      if let error = error {
        print(error)
        return
      }

      print("Xml Length: \(xml.characters.count)")
    }

The XML passed back from this function can be used later to create a new job, or can be updated and uploaded to update the original project it was pulled from.

#### Create Job

Creating a job requires valid Jenkins configuration xml. An example of this XML can be found by fetching the configuration from an existing job on your system.

    jenkins.create("MyNewProject", configuration: response) { error in
      if let error = error {
        print(error)
        return
      }

      print("Created Project")
    }

#### Update Job

Similar to creating a project, updating a project only requires valid Jenkins configuration XML and a call to the update function

    jenkins.update("MyExistingProject", configuration: response) { error in
      if let error = error {
        print(error)
        return
      }

      print("Updated Project")
    }

#### Update Job Description

Sometimes you may want to update the description of the project without going through the hassle of reading and writing configuration XML. Use the `Update` method and pass in a description parameter instead of a configuration.

    jenkins.update("MyProject", description: updateString) { error in
      if let error = error {
        print("Error Updating Description: \(error)")
        return
      }

      print("Description Updated")
    }

#### Copy Job

Jenkins includes a native web-api call for copying jobs that makes the process a simple. Call the copy method passing in the existing project name, and the name of the new project.

    jenkins.copy("oldProjectToCopy", to: "MyNewProject") { error in
      if let error = error {
        print(error)
        return
      }

      print("Copied project")
    }

#### Delete Job

Call the delete method and pass in a job to delete it from Jenkins. There's no validation here, and the call is destructive. We recommend you use the `disable` function instead of deleting a project.

    jenkins.delete("MyJobToDelete") { error in
      ...
      print("Deleted \(job)")
    }

#### Enabling and Disabling Jobs

Both enabling and disabling require a simple call with the name of the project.

    // Disable job
    jenkins.disable(job: "MyProject") { error in
      if let error = error {
        print("Error disabling job: \(error)")
        return
      }

      print("Disabled job")
    }

    // Enable job
    jenkins.enable(job: "MyProject") { error in
      if let error = error {
        print("Error enabling job: \(error)")
        return
      }

      print("Enabled job")
    }

#### Building a Job

Building a job requires using 1 of 2 methods, depending on whether or not your project requires parameters. In both cases, you call the `build` method, and optionally pass in parameters. If parameters are passed in, the client will use the appropriate path to build the project with parameters. If parameters are required but aren't passed into the function, Jenkins will return an error.

    // Build without parameters
    jenkins.build("MyProject") { error in
        if let error = error {
            print(error)
            return
        }

        print("Built Job Without Parameters")
    }

    // Build with parameters

    let parameters: [String : String] = [
        "SlackChannel" : "MyProject-Channel",
        "Configuration" : "Test",
        "isReleaseBuild" : "true"
    ]

    jenkins.build("MyProject", parameters: parameters) { error in
      if let error = error {
        print(error)
        return
      }

      print("Building Job With Paramaters: \(parameters)")
    }

___

## Contributing

See the [contributing](https://github.com/IntrepidPursuits/Jenkins-Swift/blob/master/CONTRIBUTING.md) document for more information. Thank you to all [contributors](https://github.com/IntrepidPursuits/Jenkins-Swift/graphs/contributors).
___

## License

Jenkins-Swift is free software and may be redistributed under the terms specified in the [LICENSE](https://github.com/IntrepidPursuits/Jenkins-swift/blob/master/license.txt) file.

___

## About

Jenkins-Swift is maintained by Patrick Butkiewicz and Intrepid Pursuits.

![Intrepid Pursuits](https://avatars1.githubusercontent.com/u/2151424)
