protocol KernelHandler: AnyObject {
    func exit(status: Int32)
}

protocol Kernel {
    func trap(signal: Int32)
    func execute(argc:Int32, argv:[String], env:[String: String])
    func set(environment: [String:String])
    func set(handler: KernelHandler)
}
