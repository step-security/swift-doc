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

    var body: [String: String] = ["action": action ?? ""]
    if serverUrl != "https://github.com" { body["ghes_server"] = serverUrl }

    let repo = env["GITHUB_REPOSITORY"] ?? ""
    let url = URL(string: "https://agent.api.stepsecurity.io/v1/github/\(repo)/actions/maintained-actions-subscription")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.timeoutInterval = 3
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    let bodyString = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? ""
    print("[debug] POST \(url.absoluteString)")
    print("[debug] Body: \(bodyString)")

    let startTime = Date()
    let semaphore = DispatchSemaphore(value: 0)
    var statusCode: Int?

    URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error { print("[debug] error: \(error)") }
        if let http = response as? HTTPURLResponse {
            statusCode = http.statusCode
        }
        semaphore.signal()
    }.resume()

    let waitResult = semaphore.wait(timeout: .now() + 3.5)
    let elapsed = Date().timeIntervalSince(startTime)
    print("[debug] elapsed: \(String(format: "%.2f", elapsed))s, semaphore: \(waitResult == .timedOut ? "timedOut" : "signaled"), statusCode: \(String(describing: statusCode))")

    if statusCode == 403 {
        print("\u{001B}[1;31mThis action requires a StepSecurity subscription for private repositories.\u{001B}[0m")
        print("\u{001B}[31mLearn how to enable a subscription: \(docsUrl)\u{001B}[0m")
        exit(1)
    }

    if statusCode == nil {
        print("Timeout or API not reachable. Continuing to next step.")
    }
}
