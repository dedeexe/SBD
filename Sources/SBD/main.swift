import Darwin
import Foundation

func execute(argc:Int32, argv:[String]) -> Int32 {
    if argc == 1 {
        print("normal")
        call(argv[0], arguments: ["--daemon"])
        return 0
    }
    
    if argv.contains("--daemon") {
        print("daemon")
        let daemon = Daemon(argc: argc, argv: argv, env: [:])
        return daemon.start()
    }
    
    return 0
}

func main() -> Int32 {
    let processInfo = ProcessInfo.processInfo
    let argments = processInfo.arguments
    let environment = processInfo.environment
    return execute(argc: Int32(argments.count), argv: argments)
}

main()
