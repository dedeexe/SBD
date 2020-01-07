import Foundation

class ProcessChannel {
    let output: Pipe
    let input: Pipe
    
    init(process: Process) {
        output = Pipe()
        input = Pipe()
        process.standardInput = input
        process.standardOutput = output
    }
}
