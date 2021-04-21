import Foundation
import Network

public class SimpleServer {
	public var listener: NWListener
	public var connections: Array<NWConnection>
	public let requestHandler: (NWConnection, Data?) -> (data: Data?, close: Bool)
	
	public init(port: Int, requestHandler: @escaping (NWConnection, Data?) -> (data: Data?, close: Bool), newConnectionHandler: @escaping (NWConnection) -> (Data?) = {_ in return nil}) {
		self.listener = try! NWListener(using: .tcp, on: .init(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port)))
		self.connections = []
		self.requestHandler = requestHandler
		
		self.listener.newConnectionHandler = {connection in
			self.connections.append(connection)
			connection.start(queue: .main)
			let dataToSend = newConnectionHandler(connection)
			if dataToSend != nil {
				connection.send(content: dataToSend, completion: .contentProcessed({err in
					if err != nil {
						print("Error sending data")
					}
				}))
			}
			self.setupReceive(connection: connection)
		}
	}
	
	private func setupReceive(connection: NWConnection) {
		connection.receive(minimumIncompleteLength: 1, maximumLength: 65535, completion: {data, _, isLast, err in
			if err != nil {
				print("Error receiving data")
			} else {
				if isLast {
					connection.cancel()
				} else {
					let response = self.requestHandler(connection, data)
					let dataToSend = response.data
					if dataToSend != nil {
						connection.send(content: dataToSend, completion: .contentProcessed({err in
							if err != nil {
								print("Error sending data")
							}
							if response.close {
								connection.cancel()
							}
						}))
					}
					if !response.close {
						self.setupReceive(connection: connection)
					}
				}
			}
		})
	}
	
	public func start() {
		self.listener.start(queue: .main)
	}
}
