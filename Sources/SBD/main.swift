import Darwin

func main(_ argc:Int32, _ argv:[String]) -> Int32 {
    if argc == 1 {
        print("normal")
        call(argv[0], arguments: ["--daemon"])
        return 0
    }
    
    if argv.contains("--daemon") {
        print("daemon")
        let kernel = KernelProcess()
        let daemon = Daemon(argc: argc, argv: argv, kernel: kernel)
        return daemon.execute()
    }
    
    return 0
}

//----------------------------------------------------------------------
let argc = CommandLine.argc
let argv = CommandLine.arguments
let result = main(argc, argv)
exit(result)
