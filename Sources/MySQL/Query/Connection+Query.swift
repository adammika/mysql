import Async
import Foundation

extension MySQLConnection {
    /// A function that shoots a raw query without expecting a real answer
    @discardableResult
    public func administrativeQuery(_ query: MySQLQuery) -> Future<Void> {
        let promise = Promise<Void>()
        
        do {
            try self.write(query: query.queryString)
        } catch {
            return Future(error: error)
        }
        
        self.parser.drain { packet, _ in
            // Expect an `OK` or `EOF` packet
            if packet.payload.first == 0xff {
                // Otherwise, reutrn an error
                promise.fail(MySQLError(packet: packet))
                return
            }
            
            promise.complete()
        }.catch(onError: promise.fail)
        .finally {
            promise.complete()
        }.upstream?.request()
        
        return promise.future
    }
}

extension MySQLStateMachine {
    /// Writes a query to the connection
    ///
    /// Doesn't handle anything else
    func write(query: String) throws {
        var buffer = Data()
        buffer.reserveCapacity(query.utf8.count + 1)
        
        // SQL Query
        buffer.append(0x03)
        buffer.append(contentsOf: [UInt8](query.utf8))
        
        self.send(Packet(data: buffer))
    }
    
    /// Writes a preparation message to the connection
    func prepare(query: String) throws {
        var buffer = Data()
        buffer.reserveCapacity(query.utf8.count + 1)
        
        // SQL Query
        buffer.append(0x16)
        buffer.append(contentsOf: [UInt8](query.utf8))
        send.next(Packet(data: buffer))
    }
}
