import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func validateSubscription() {
    // Read repository.private from GitHub event payload
    var repoPrivate: Bool? = nil
    if let eventPath = ProcessInfo.processInfo.environment["GITHUB_EVENT_PATH"],
       let data = try? Data(contentsOf: URL(fileURLWithPath: eventPath)),
       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
       let repo = json["repository"] as? [String: Any],
       let isPrivate = repo["private"] as? Bool {
        repoPrivate = isPrivate
    }

    let upstream = "SwiftDocOrg/swift-doc"
    let action = ProcessInfo.processInfo.environment["GITHUB_ACTION_REPOSITORY"]
    let docsUrl = "https://docs.stepsecurity.io/actions/stepsecurity-maintained-actions"

    print("")
    print("\u{001B}[1;36mStepSecurity Maintained Action\u{001B}[0m")
    print("Secure drop-in replacement for \(upstream)")
    if repoPrivate == false { print("\u{001B}[32m\u{2713} Free for public repositories\u{001B}[0m") }
    print("\u{001B}[36mLearn more:\u{001B}[0m \(docsUrl)")
    print("")

    if repoPrivate == false { return }

    let env = ProcessInfo.processInfo.environment
    let serverUrl = env["GITHUB_SERVER_URL"] ?? "https://github.com"

    let actionValue = action ?? ""
    let repoName = env["GITHUB_REPOSITORY"] ?? ""
    let urlString = "https://agent.api.stepsecurity.io/v1/github/\(repoName)/actions/maintained-actions-subscription"

    var jsonBody = "{\"action\":\"\(actionValue)\"}"
    if serverUrl != "https://github.com" {
        jsonBody = "{\"action\":\"\(actionValue)\",\"ghes_server\":\"\(serverUrl)\"}"
    }

    print("[debug] POST \(urlString)")
    print("[debug] Body: \(jsonBody)")

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/curl")
    process.arguments = [
        "-s", "-o", "/dev/null",
        "-w", "%{http_code}",
        "-X", "POST",
        "-H", "Content-Type: application/json",
        "-d", jsonBody,
        "--max-time", "5",
        urlString
    ]

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = FileHandle.nullDevice

    var statusCode: Int?
    do {
        try process.run()
        process.waitUntilExit()
        let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        print("[debug] curl status: \(output)")
        statusCode = Int(output.trimmingCharacters(in: .whitespacesAndNewlines))
    } catch {
        print("[debug] curl error: \(error)")
    }

    if statusCode == 403 {
        print("\u{001B}[1;31mThis action requires a StepSecurity subscription for private repositories.\u{001B}[0m")
        print("\u{001B}[31mLearn how to enable a subscription: \(docsUrl)\u{001B}[0m")
        exit(1)
    }

    if statusCode == nil || statusCode == 0 {
        print("Timeout or API not reachable. Continuing to next step.")
    }
}
