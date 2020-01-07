import Darwin
import Foundation

func config(setup:inout Setup, using arguments: [String]) -> Int {

}

@available(OSX 10.13, *)
func execute(argc:Int, argv:[String], setup: inout Setup) -> Int {
    if argc == 1 {
        call(argv[0], arguments: ["--daemon"])
        return 0
    }
    
    if argv.contains("--daemon") {
        
    }
}

func main() -> Int {
    
    let processInfo = ProcessInfo.processInfo
    let argments = processInfo.arguments
    let environment = processInfo.environment
    
    return 0
}

main()
