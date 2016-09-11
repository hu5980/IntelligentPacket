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
    
    void (^REGISTER_REQUEST_BLOCK)();                                   // 1. 申请注册
    void (^REGISTER_CONFIM_BLOCK)();                                    // 2. 确认注册
    void (^LOGIN_BLOCK)();                                              // 3. 登录BANGDING
    void (^CR_BLOCK)();                                                 // 4. 实时查询
    void (^PHB_BLOCK)();                                                // 5. 设置亲情号码
    void (^MONITOR_BLOCK)();                                            // 6. 亲情号码监听
    void (^ACT_BLOCK)();                                                // 7. 请求终端操作
    void (^GPS_BLOCK)();                                                // 8. GPS开关功能
    void (^LXR_BLOCK)();                                                // 9. 获取联系人
    void (^DELETEBINDDEV_BLOCK)();                                      // 10. DELETEBINDDEV
    void (^DELETELXR_BLOCK)();                                          // 11. 删除联系人
    void (^BANGDING_BLOCK)();                                           // 12. 箱子绑定
    void (^BAGLIST_BLOCK)();                                            // 13. 箱子列表
    void (^GETHISTORYRECORD_BLOCK)();                                   // 15. 箱子历史位置
    void (^SETSAFEREGION_BLOCK)();                                      // 14. 提交安全栏
    void (^MODIFYPERSONALDATA_BLOCK)();                                 // 18. 修改用户资料
    void (^MCUDATA_BLOCK)();
    
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
        }
    });
    [_sigton config];
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

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag result:(void(^)(NSData *data, long tag, NSError*error))result  {
    
    [self.socket writeData:data withTimeout:2 tag:tag];
    [self.socket readDataWithTimeout:timeout tag:tag];
    switch (tag) {
        case ITP_REGISTER_REQUEST_TAG:
            REGISTER_REQUEST_BLOCK = result;
            break;
        case ITP_REGISTER_CONFIM_TAG:
            REGISTER_CONFIM_BLOCK = result;
            break;
        case ITP_LOGIN_TAG:
            LOGIN_BLOCK = result;
            break;
        case ITP_CR_TAG:
            CR_BLOCK = result;
            break;
        case ITP_PHB_TAG:
            PHB_BLOCK = result;
            break;
        case ITP_MONITOR_TAG:
            MONITOR_BLOCK = result;
            break;
        case ITP_ACT_TAG:
            ACT_BLOCK = result;
            break;
        case ITP_GPS_TAG:
            GPS_BLOCK = result;
            break;
        case ITP_LXR_TAG:
            LXR_BLOCK = result;
            break;
        case ITP_DELETEBINDDEV_TAG:
            DELETEBINDDEV_BLOCK = result;
            break;
        case ITP_DELETELXR_TAG:
            DELETELXR_BLOCK = result;
            break;
        case ITP_BANGDING_TAG:
            BANGDING_BLOCK = result;
            break;
        case ITP_BAGLIST_TAG:
            BAGLIST_BLOCK = result;
            break;
        case ITP_GETHISTORYRECORD_TAG:
            GETHISTORYRECORD_BLOCK = result;
            break;
        case ITP_SETSAFEREGION_TAG:
            SETSAFEREGION_BLOCK = result;
            break;
        case ITP_MODIFYPERSONALDATA_TAG:
            MODIFYPERSONALDATA_BLOCK = result;
            break;
        case ITP_MCUDATA_TAG:
            MCUDATA_BLOCK = result;
            break;
        default:
            break;
    }
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
    [self disConnect];
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    switch (tag) {
        case ITP_REGISTER_REQUEST_TAG:
        {
            if ([dataStr rangeOfString:ITP_REGISTER_REQUEST].location != NSNotFound&&REGISTER_REQUEST_BLOCK) {
                REGISTER_REQUEST_BLOCK(data, tag, nil);
                REGISTER_REQUEST_BLOCK = nil;
            }
            break;
        }
        case ITP_REGISTER_CONFIM_TAG:
        {
            if ([dataStr rangeOfString:ITP_REGISTER_CONFIM].location != NSNotFound&&REGISTER_CONFIM_BLOCK) {
                REGISTER_CONFIM_BLOCK(data, tag, nil);
                REGISTER_CONFIM_BLOCK = nil;
            }
            break;
        }
        case ITP_LOGIN_TAG:
        {
            if ([dataStr rangeOfString:ITP_LOGIN].location != NSNotFound&&LOGIN_BLOCK) {
                LOGIN_BLOCK(data, tag, nil);
                LOGIN_BLOCK = nil;
            }
            break;
        }
        case ITP_CR_TAG:
        {
            if ([dataStr rangeOfString:ITP_CR].location != NSNotFound&&CR_BLOCK) {
                CR_BLOCK(data, tag, nil);
                CR_BLOCK = nil;
            }
            break;
        }
        case ITP_PHB_TAG:
        {
            if ([dataStr rangeOfString:ITP_PHB].location != NSNotFound&&PHB_BLOCK) {
                PHB_BLOCK(data, tag, nil);
                PHB_BLOCK = nil;
            }
            break;
        }
        case ITP_MONITOR_TAG:
        {
            if ([dataStr rangeOfString:ITP_MONITOR].location != NSNotFound&&MONITOR_BLOCK) {
                MONITOR_BLOCK(data, tag, nil);
                MONITOR_BLOCK = nil;
            }
            break;
        }
        case ITP_ACT_TAG:
        {
            if ([dataStr rangeOfString:ITP_ACT].location != NSNotFound&&ACT_BLOCK) {
                ACT_BLOCK(data, tag, nil);
                ACT_BLOCK = nil;
            }
            break;
        }
        case ITP_GPS_TAG:
        {
            if ([dataStr rangeOfString:ITP_GPS].location != NSNotFound&&GPS_BLOCK) {
                GPS_BLOCK(data, tag, nil);
                GPS_BLOCK = nil;
            }
            break;
        }
        case ITP_LXR_TAG:
        {
            if ([dataStr rangeOfString:ITP_LXR].location != NSNotFound&&LXR_BLOCK) {
                LXR_BLOCK(data, tag, nil);
                LXR_BLOCK = nil;
            }
            break;
        }
        case ITP_DELETEBINDDEV_TAG:
        {
            if ([dataStr rangeOfString:ITP_DELETEBINDDEV].location != NSNotFound&&DELETEBINDDEV_BLOCK) {
                DELETEBINDDEV_BLOCK(data, tag, nil);
                DELETEBINDDEV_BLOCK = nil;
            }
            break;
        }
        case ITP_DELETELXR_TAG:
        {
            if ([dataStr rangeOfString:ITP_DELETELXR].location != NSNotFound&&DELETELXR_BLOCK) {
                DELETELXR_BLOCK(data, tag, nil);
                DELETELXR_BLOCK = nil;
            }
            break;
        }
        case ITP_BANGDING_TAG:
        {
            if ([dataStr rangeOfString:ITP_BANGDING].location != NSNotFound&&BANGDING_BLOCK) {
                BANGDING_BLOCK(data, tag, nil);
                BANGDING_BLOCK = nil;
            }
            break;
        }
        case ITP_BAGLIST_TAG:
        {
            if ([dataStr rangeOfString:ITP_BAGLIST].location != NSNotFound&&BAGLIST_BLOCK) {
                BAGLIST_BLOCK(data, tag, nil);
                BAGLIST_BLOCK = nil;
            }
            break;
        }
        case ITP_GETHISTORYRECORD_TAG:
        {
            if ([dataStr rangeOfString:ITP_GETHISTORYRECORD].location != NSNotFound&&GETHISTORYRECORD_BLOCK) {
                GETHISTORYRECORD_BLOCK(data, tag, nil);
                GETHISTORYRECORD_BLOCK = nil;
            }
            break;
        }
        case ITP_SETSAFEREGION_TAG:
        {
            if ([dataStr rangeOfString:ITP_SETSAFEREGION].location != NSNotFound&&SETSAFEREGION_BLOCK) {
                SETSAFEREGION_BLOCK(data, tag, nil);
                SETSAFEREGION_BLOCK = nil;
            }
            break;
        }
        case ITP_MODIFYPERSONALDATA_TAG:
        {
            if ([dataStr rangeOfString:ITP_MODIFYPERSONALDATA].location != NSNotFound&&MODIFYPERSONALDATA_BLOCK) {
                MODIFYPERSONALDATA_BLOCK(data, tag, nil);
                MODIFYPERSONALDATA_BLOCK = nil;
            }
            break;
        }
        case ITP_MCUDATA_TAG:
        {
            if ([dataStr rangeOfString:ITP_MCUDATA].location != NSNotFound&&MCUDATA_BLOCK) {
                MCUDATA_BLOCK(data, tag, nil);
                MCUDATA_BLOCK = nil;
            }
            break;
        }
        default:
            break;
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
    [self disConnect];
    if (REGISTER_REQUEST_BLOCK) {
        REGISTER_REQUEST_BLOCK(nil, ITP_REGISTER_REQUEST_TAG, nil);
        REGISTER_REQUEST_BLOCK = nil;
    }
    if (REGISTER_CONFIM_BLOCK) {
        REGISTER_CONFIM_BLOCK(nil, ITP_REGISTER_CONFIM_TAG, nil);
        REGISTER_CONFIM_BLOCK = nil;
    }
    if (LOGIN_BLOCK) {
        LOGIN_BLOCK(nil, ITP_LOGIN_TAG, nil);
        LOGIN_BLOCK = nil;
    }
    if (CR_BLOCK) {
        CR_BLOCK(nil, ITP_CR_TAG, nil);
        CR_BLOCK = nil;
    }
    if (PHB_BLOCK) {
        PHB_BLOCK(nil, ITP_PHB_TAG, nil);
        PHB_BLOCK = nil;
    }
    if (MONITOR_BLOCK) {
        MONITOR_BLOCK(nil, ITP_MONITOR_TAG, nil);
        MONITOR_BLOCK = nil;
    }
    if (ACT_BLOCK) {
        ACT_BLOCK(nil, ITP_ACT_TAG, nil);
        ACT_BLOCK = nil;
    }
    if (GPS_BLOCK) {
        GPS_BLOCK(nil, ITP_GPS_TAG, nil);
        GPS_BLOCK = nil;
    }
    if (LXR_BLOCK) {
        LXR_BLOCK(nil, ITP_LXR_TAG, nil);
        LXR_BLOCK = nil;
    }
    if (DELETEBINDDEV_BLOCK) {
        DELETEBINDDEV_BLOCK(nil, ITP_DELETEBINDDEV_TAG, nil);
        DELETEBINDDEV_BLOCK = nil;
    }
    if (DELETELXR_BLOCK) {
        DELETELXR_BLOCK(nil, ITP_DELETELXR_TAG, nil);
        DELETELXR_BLOCK = nil;
    }
    if (BANGDING_BLOCK) {
        BANGDING_BLOCK(nil, ITP_BANGDING_TAG, nil);
        BANGDING_BLOCK = nil;
    }
    if (BAGLIST_BLOCK) {
        BAGLIST_BLOCK(nil, ITP_BAGLIST_TAG, nil);
        BAGLIST_BLOCK = nil;
    }
    if (GETHISTORYRECORD_BLOCK) {
        GETHISTORYRECORD_BLOCK(nil, ITP_GETHISTORYRECORD_TAG, nil);
        GETHISTORYRECORD_BLOCK = nil;
    }
    if (SETSAFEREGION_BLOCK) {
        SETSAFEREGION_BLOCK(nil, ITP_SETSAFEREGION_TAG, nil);
        SETSAFEREGION_BLOCK = nil;
    }
    if (MODIFYPERSONALDATA_BLOCK) {
        MODIFYPERSONALDATA_BLOCK(nil, ITP_MODIFYPERSONALDATA_TAG, nil);
        MODIFYPERSONALDATA_BLOCK = nil;
    }
    if (MCUDATA_BLOCK) {
        MCUDATA_BLOCK(nil, ITP_MCUDATA_TAG, nil);
        MCUDATA_BLOCK = nil;
    }
    
}



@end
