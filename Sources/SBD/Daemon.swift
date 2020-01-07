import Darwin
import Foundation

class Daemon {
    let loop = RunLoop.current
    
    func main(arguments:[String]) -> Int {
        loop.run()
        return 0
    }
}
