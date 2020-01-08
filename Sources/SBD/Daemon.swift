//
//  Daemon.swift
//  SBD
//
//  Created by dede.exe on 07/01/20.
//

import Foundation
import Darwin

class Daemon: NSObject, PortDelegate {
    
    private let argv: [String]
    private let argc: Int32
    private let environment: [String:String]
    private let port: Port
    private var started: Bool
    private let loop: RunLoop
    private let signalTrap: SignalTrap = SignalTrap()
    
    init(argc: Int32, argv: [String], env: [String: String]) {
        self.started = false
        self.argc = argc
        self.argv = argv
        self.environment = env
        self.port = Port()
        self.loop = RunLoop.current
        self.loop.add(port, forMode: .default)
        
        super.init()
        bindSignal()
    }
    
    private func bindSignal() {
        signalTrap.handle(signal: SIGHUP) { value in
            print("Signal value: \(value)")
        }
    }
    
    func start() -> Int32 {
        if started {
            return -1
        }
        
        print("Fooooi demo")
        
        self.port.setDelegate(self)
        self.loop.run()
        return 0
    }
    
    func stop() -> Int32 {
        if started {
            return 0
        }
        
        return -1
    }
    
    func handle(_ message: PortMessage) {
        
    }
}


class SignalTrap {
    
    typealias SignalHandler = @convention(c)(Int32) -> Void
    
    func handle(signal:Int32, action: @escaping SignalHandler) {
        typealias SignalAction = sigaction
        
        var sig_action_struct = sigaction()
        sig_action_struct.__sigaction_u = unsafeBitCast(action, to: __sigaction_u.self)
        sigaction(signal, &sig_action_struct, nil)
    }
}
