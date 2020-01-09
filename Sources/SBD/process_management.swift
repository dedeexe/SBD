import Foundation

func call(_ binary: String, arguments: [String]) {
    let task = Process()
    task.launchPath = binary
    task.arguments = arguments
    task.launch()
}
