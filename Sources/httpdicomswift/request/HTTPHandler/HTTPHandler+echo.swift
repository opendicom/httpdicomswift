//
//  handleEcho.swift
//
//
//  Created by cbaeza on 3/21/19.
//
import NIO
import NIOHTTP1

public extension HTTPHandler {
   
   //context is used for the creation of the response
   //the handler handleEcho is called
   // - at least once with property .head,
   // - zero or more times with property .body
   // - and once with property .end
    func echo(
      context: ChannelHandlerContext,
      request: HTTPServerRequestPart
      ) {
        switch request {
        case .head(let request):
            print("head")
            self.state.requestReceived()
         context.write(self.wrapOutboundOut(.head(httpResponseHead(request: request, status: .ok, headers: HTTPHeaders()))), promise: nil)

        case .body(buffer: let buf):
            print("body")
            print(buf.debugDescription)
            context.write(self.wrapOutboundOut(
            .body(.byteBuffer(buf))), promise: nil)

        case .end:
            print("end")
            self.state.requestComplete()
            self.completeResponse(context, trailers: nil, promise: nil)
        }
    }
    
}
