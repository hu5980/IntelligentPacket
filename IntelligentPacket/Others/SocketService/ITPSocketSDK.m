//
//  ITPSocketSDK.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPSocketSDK.h"


@implementation ITPSocketSDK
{
    void (^SuccessCallBack)();
    void (^FailureCallBack)();
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _socket = [GCDAsyncSocket new];
    }
    return self;
}

- (void)disConnect {
    
    [_socket setDelegate:nil delegateQueue:NULL];
    [_socket disconnect];
}


- (void)config {
    
    _socket.delegate = self;
    _socket.IPv4Enabled = YES;
    _socket.IPv6Enabled = YES;
    _socket.IPv4PreferredOverIPv6 = NO;
    _socket.delegateQueue = dispatch_get_main_queue();
}

+ (instancetype)shareInstance
{
    static ITPSocketSDK * _sigton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sigton) {
            _sigton = [[ITPSocketSDK alloc]init];
            [_sigton config];
        }
    });
    return _sigton;
}

// Host port 连接
- (BOOL)socketConnectToHost:(NSString *)host port:(uint16_t)port {
    
    NSAssert(_socket, @"Socket Can Not be nil!");
    NSAssert(host, @"Host Can Not be nil!");
    NSAssert(port, @"Port Can Not be nil!");
    
    NSError * error;
    
    BOOL abool = [_socket connectToHost:host onPort:port error:&error];
    return abool;
}

// Host port 重新连接
- (BOOL)socketReconnectToHost:(NSString *)host port:(uint16_t)port {
    if (_socket) [_socket disconnect];
    NSAssert(_socket, @"Socket Can Not be nil!");
    NSAssert(host, @"Host Can Not be nil!");
    NSAssert(port, @"Port Can Not be nil!");
    return [_socket connectToHost:host onPort:port error:nil];

}
// Url 连接
- (BOOL)socketConnectToUrl:(NSString *)url withTimeOut:(NSTimeInterval)tiemOut {
   
    NSAssert(url, @"Url Can Not be nil!");
   return [_socket connectToUrl:[NSURL URLWithString:url] withTimeout:tiemOut error:nil];
}

// Url 重新连接
- (BOOL)socketReconnectToUrl:(NSString *)url withTimeOut:(NSTimeInterval)tiemOut {
    if (_socket) [_socket disconnect];
    NSAssert(url, @"Url Can Not be nil!");
    return [_socket connectToUrl:[NSURL URLWithString:url] withTimeout:tiemOut error:nil];
}

// 写数据入口

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag success:(void(^)(NSData *data, long tag))success faillure:(void(^)(NSError *error))faillure {
    SuccessCallBack = success;
    FailureCallBack = faillure;
    [self.socket writeData:data withTimeout:2 tag:tag];
    [self.socket readDataWithTimeout:timeout tag:100];
}

#pragma mark - GCDAsyncSocket Delegate .
#pragma mark - 
#pragma mark -
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {

}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {

}

//  data back
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    if (SuccessCallBack) {
        SuccessCallBack(data, tag);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {

}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}


- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {

}

//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag {
//
//}
// 
//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
//
//}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock {

}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    if (FailureCallBack) {
        FailureCallBack(err);
    }
}



@end
