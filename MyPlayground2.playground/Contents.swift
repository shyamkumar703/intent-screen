import Foundation

class RateLimiter {
    var userAccessDictionary = [String: [Double]]()
    var limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    func canAccess(user: String) -> Bool {
//        let currDate = Date().timeIntervalSince1970
        /*
         If the array has length less than 5, accept
         Start at the beginning of the array
            If the timestamp is more than 2 seconds earlier than the current date, remove
            If it's not, then increment our counter
            If the counter is greater than 5, deny
         */
        let currDate = Date().timeIntervalSince1970
        userAccessDictionary[user]?.append(currDate)
        if let userAccessHistoryArr = userAccessDictionary[user] {
            // if a history exists
            if userAccessHistoryArr.count <= limit {
                // Add new timestamp to the array
                return true
                // Return true
            } else {
                var counter = 0
                var indicesToRemove = [Int]()
                for (index, stamp) in userAccessHistoryArr.enumerated() {
                    if currDate - stamp > 2 {
                        indicesToRemove.append(index)
                        continue
                    } else {
                        counter += 1
                    }
                }
                
                var numberOfElementsRemoved = 0
                for index in indicesToRemove {
                    userAccessDictionary[user]?.remove(at: index - numberOfElementsRemoved)
                    numberOfElementsRemoved += 1
                }
                
                if counter > limit {
                    return false
                } else {
                    return true
                }
            }
        } else {
            userAccessDictionary[user] = [currDate]
            return true
        }
    }
}

let user = "shyam"

let limiter = RateLimiter(limit: 5)

// 2, sleep 1, 5, sleep 1, 1

print(limiter.canAccess(user: user))
print(limiter.canAccess(user: user))
sleep(1)
// 1.x
for _ in 0..<5 {
    print(limiter.canAccess(user: user))
}
sleep(1)
// 2.x
print(limiter.userAccessDictionary[user], Date().timeIntervalSince1970) //false
print(limiter.canAccess(user: user))


