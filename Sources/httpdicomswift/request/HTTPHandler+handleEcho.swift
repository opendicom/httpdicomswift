//
//  handleEcho.swift
//
//
//  Created by cbaeza on 3/21/19.
//
import NIO
import NIOHTTP1

public extension HTTPHandler {
    
    func handleEcho(context: ChannelHandlerContext, request: HTTPServerRequestPart) {
        switch request {
        case .head(let request):
            self.infoSavedRequestHead = request
            self.infoSavedBodyBytes = 0
            self.keepAlive = request.isKeepAlive
            self.state.requestReceived()
        case .body(buffer: let buf):
            self.infoSavedBodyBytes += buf.readableBytes            
        case .end:
            self.state.requestComplete()
            let response = "echo"
            self.buffer.clear()
            self.buffer.writeString(response)
            var headers = HTTPHeaders()
            headers.add(name: "Content-Length", value: "\(response.utf8.count)")
            context.write(self.wrapOutboundOut(.head(httpResponseHead(request: self.infoSavedRequestHead!, status: .ok, headers: headers))), promise: nil)
            context.write(self.wrapOutboundOut(.body(.byteBuffer(self.buffer))), promise: nil)
            self.completeResponse(context, trailers: nil, promise: nil)
        }
    }
    
}
