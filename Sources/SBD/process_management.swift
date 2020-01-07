import Foundation

@available(OSX 10.13, *)
func call(_ binary: String, arguments: [String]) -> ProcessChannel {
    let address = URL(fileURLWithPath: binary)
    let task = Process()
    task.executableURL = address
    task.arguments = arguments
    let channel = ProcessChannel(process: task)
    try? task.run()
    
    return channel
}
