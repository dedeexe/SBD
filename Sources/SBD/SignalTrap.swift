import Darwin

class SignalTrap {
    
    typealias SignalHandler = (@convention(c)(Int32) -> Void)
    
    func handle(sender:Any?, signal:Int32, action: @escaping SignalHandler) {
        typealias SignalAction = sigaction
        
        var sig_action_struct = sigaction()
        sig_action_struct.__sigaction_u = unsafeBitCast(action, to: __sigaction_u.self)
        sigaction(signal, &sig_action_struct, nil)
    }
}
