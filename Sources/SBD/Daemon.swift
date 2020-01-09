//
//  Daemon.swift
//  SBD
//
//  Created by dede.exe on 07/01/20.
//

import Foundation

protocol Daemon {
    func main(_ action:((Daemon) -> Void)?)
    func start() -> Int32
    func stop() -> Int32
}

class DaemonService: Daemon {
    
    fileprivate let argv: [String]
    fileprivate let argc: Int32
    fileprivate let environment: [String:String]
    fileprivate var timer: Timer = Timer()
    fileprivate var running: Bool = false
    fileprivate let loop: RunLoop
    fileprivate let signalTrap: SignalTrap = SignalTrap()
    fileprivate var action: ((Daemon) -> Void)?
    
    init(argc: Int32, argv: [String], env: [String: String]) {
        self.argc = argc
        self.argv = argv
        self.environment = env
        self.loop = RunLoop.current
        
        __SignalTransfer.shared(daemon: self)
        bindSignal()
    }
    
    private func bindSignal() {
        signalTrap.handle(sender: self, signal: SIGHUP) { value in
            __SignalTransfer.shared().send(signal: value)
        }
    }
    
    @discardableResult
    func start() -> Int32 {
        if running {
            return -1
        }
        
        running = true
        while running {
            action?(self)
            sleep(1)
        }
        
        print("Terminei")
        
        return 0
    }
    
    @discardableResult
    func stop() -> Int32 {
        if running {
            running = false
            return 0
        }
        
        return -1
    }
    
    func main(_ action: ((Daemon) -> Void)?) {
        self.action = action
    }
    
    func trap(signal:Int32) {
        if signal == SIGHUP {
            self.stop()
        }
    }
}

private class __SignalTransfer {
    
    private static var selfRef: __SignalTransfer?
    private var daemon: DaemonService
    
    private init(daemon:DaemonService) {
        self.daemon = daemon
    }
    
    @discardableResult
    static func shared(daemon:DaemonService? = nil) -> __SignalTransfer {
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
