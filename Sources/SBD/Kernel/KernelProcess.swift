import Darwin

class KernelProcess: Kernel {
    private weak var handler: KernelHandler?
    private var environment: [String: String] = [:]
    
    func trap(signal: Int32) {
        print("Good Signal")
    }
    
    func execute(argc: Int32, argv: [String], env: [String : String]) {
        print("AEEEE CAREI")
    }
    
    func set(environment: [String : String]) {
        self.environment = environment
    }
    
    func set(handler: KernelHandler) {
        self.handler = handler
    }
}
