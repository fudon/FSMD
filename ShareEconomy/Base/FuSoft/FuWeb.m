//
//  FuWeb.m
//  Daiyida
//
//  Created by fudon on 14-10-17.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "FuWeb.h"
#import "FuSoft.h"

@implementation FuWeb
{
    NSMutableData  *_webData;
    NSInteger       _diff;
    BOOL            _isPicture;
}

+ (void)requestWithUrl:(NSString *)url params:(NSDictionary *)bDic successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock
{
//    if (dic == nil) {
//        if (failBlock) {
//            failBlock(@"参数错误");
//            return;
//        }
//    }
    [[self alloc] requestWithUrl:url params:bDic method:@"POST" successBlock:successBlock failBlock:failBlock];
}

+ (void)requestWithUrl:(NSString *)url params:(NSDictionary *)dic fileName:(NSString *)fileName imageData:(NSData *)imageData successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock
{
    [[self alloc] postHeaderImageFileUrl:url fileToPost:fileName picData:imageData dic:(NSDictionary *)dic success:successBlock fail:failBlock];
}

- (void)requestWithUrl:(NSString *)url params:(NSDictionary *)dic method:(NSString *)method successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock
{
    _successBlock = successBlock;
    _failBlock = failBlock;
    
    [self publicRequestWithUrlString:url params:dic mehtod:method];
}

+ (void)pictureUrl:(NSString *)urlString successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock
{
    [[self alloc] requestWithUrlGet:urlString successBlock:successBlock failBlock:failBlock];
}

- (void)requestWithUrlGet:(NSString *)url successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock
{
    _isPicture = YES;
    _successBlock = successBlock;
    _failBlock = failBlock;
    [self publicRequestWithUrlStringGet:url];
}

- (void)publicRequestWithUrlStringGet:(NSString *)urlS
{
    NSString *urlString = [urlS stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)publicRequestWithUrlString:(NSString *)urlString params:(id)dic mehtod:(NSString *)method
{
    NSString *jsonString =[FuData jsonStringWithObject:dic];
    NSData *data = [FuData dataFromString:jsonString];

    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@.action",HostUrlString,urlString];
    urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];//@"POST" @"GET"
    [request setTimeoutInterval:30];
    [request setHTTPBody:data];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *length = [NSString stringWithFormat:@"%@",@([data length])];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];

    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)postHeaderImageFileUrl:(NSString *)url fileToPost:(NSString *)imageName picData:(NSData *)imageData dic:(NSDictionary *)dic
                      success:(SuccessBlock)success fail:(FailBlock)fail
{
    _successBlock = success;
    _failBlock = fail;
    
    //creating the url request:
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@",HostUrlString,url];
    url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *cgiUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];
    
    //adding header information:
    [postRequest setHTTPMethod:@"POST"];
    
    NSString *stringBoundary = @"----WebKitFormBoundaryPSC9yBXLaUJzLTGH";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [postRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //setting up the body:
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"img\"; filename=\"%@\"\r\n", imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: application/image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:imageData];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];//后面还需要数据时用
    
    //写入sessionid的内容
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"sessionid"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *sessionid = [dic objectForKey:@"sessionid"];
    [postBody appendData:[FuData dataFromString:sessionid]];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //写入mobile的内容
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"mobile"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *mobile = [dic objectForKey:@"mobile"];
    [postBody appendData:[FuData dataFromString:mobile]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    //写入nick的内容
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"nick"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *nick = [dic objectForKey:@"nick"];
    [postBody appendData:[FuData dataFromString:nick]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //写入style的内容
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"style"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *style = [dic objectForKey:@"style"];
    [postBody appendData:[FuData dataFromString:style]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 写入尾部内容，与前面对应
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postBody length]];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:postBody];
    [NSURLConnection connectionWithRequest:postRequest delegate:self];
    NSLog(@"kkk2");
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _webData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *string = [[NSString alloc] initWithFormat:@"服务器错误或未联网:%@",error];
    FSLog(@"%@",string);
    if (_failBlock) {
        _failBlock(string);
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    
    if (_isPicture) {
        if (_webData.length == 0) {
            if (_failBlock) {
                _failBlock(@"图片数据为空");
            }
        }else{
            if (_successBlock) {
                _successBlock(_webData);
            }
        }
        return;
    }
    
    NSString *string = [FuData dataToString:_webData];
    NSLog(@"%@",string);
    id dic = [FuData objectFromJSonstring:string];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *code = [dic objectForKey:@"type"];
        if ([code integerValue] == 1) {
            if (_successBlock) {
                _successBlock(dic);
            }
        }else{
            NSString *msg = [dic objectForKey:@"msg"];
            if (_failBlock) {
                _failBlock(msg);
            }
        }
    }else{
        if (_failBlock) {
            _failBlock(@"返回非字典数据");
        }
    }
}

@end
