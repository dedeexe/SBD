import Foundation

final class Daemon: KernelHandler {
    
    fileprivate let kernel: Kernel
    fileprivate let argv: [String]
    fileprivate let argc: Int32
    fileprivate var environment: [String:String] = [:]
    fileprivate var timer: Timer = Timer()
    fileprivate var running: Bool = false
    fileprivate let signalTrap: SignalTrap = SignalTrap()
    fileprivate var exitStatus: Int32 = 0
    
    init(argc: Int32, argv: [String], kernel: Kernel) {
        self.argc = argc
        self.argv = argv
        self.kernel = kernel
        __SignalTransfer.shared(daemon: self)
        
        bindSignal()
    }
    
    private func bindSignal() {
        signalTrap.handle(sender: self, signal: SIGHUP) { value in
            __SignalTransfer.shared().send(signal: value)
        }
    }
    
    private func wait() {
        while running {
            sleep(50)
        }
    }
    
    @discardableResult
    func execute() -> Int32 {
        if running {
            return -1
        }
        
        running = true
        kernel.execute(argc: argc, argv: argv, env: environment)
        wait()
        return exitStatus
    }
    
    @discardableResult
    func shutdown() -> Int32 {
        exitStatus = -1
        
        if running {
            running = false
            exitStatus = 0
        }
        
        return exitStatus
    }
    
    func trap(signal:Int32) {
        kernel.trap(signal: signal)
    }
    
    func exit(status: Int32) {
        exitStatus = status
        shutdown()
    }
    
}

private class __SignalTransfer {
    
    private static var selfRef: __SignalTransfer?
    private var daemon: Daemon
    
    private init(daemon:Daemon) {
        self.daemon = daemon
    }
    
    @discardableResult
    static func shared(daemon:Daemon? = nil) -> __SignalTransfer {
        if let ref = selfRef {
            return ref
        }
        
        if let daemon = daemon {
            selfRef = __SignalTransfer(daemon: daemon)
            return selfRef!
        }
        
        fatalError("Fail. No daemon defined")
    }
    
    func send(signal: Int32) {
        daemon.trap(signal: signal)
    }
}
