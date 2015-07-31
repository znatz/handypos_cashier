//
//  NetworkManager.m
//  HandyPOS_Cashier
//
//  Created by 小泉 丈太 on 2015/07/31.
//  Copyright © 2015年 小泉 丈太. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetworkManager
 
 + (void) fetchDBFile : (NSString *)dbfileName
 {
     NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/app/database";
     
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", dbURI, dbfileName]];
     NSLog(@"%@", url);
     NSURLRequest *myRequest;
     
     myRequest = [NSURLRequest requestWithURL:url
     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
     timeoutInterval:30.0];
     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
     
     // sqliteの保存場所を指定
     NSString *documentDir;
     documentDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
     dbfileName = [NSString stringWithFormat:@"%@", dbfileName];
     NSString *downloadDestinationPath = [documentDir stringByAppendingPathComponent:dbfileName];
     operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadDestinationPath append:NO];
     
     
     [operation
     setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
     id responseObject)
     {
     NSLog(@"ダウンロード成功！ dbの保存先:%@", downloadDestinationPath);
     }
     failure:^(AFHTTPRequestOperation *operation,
     NSError *error)
     {
     NSLog(@"Error ->: %@", [error localizedDescription]);
     }];
     
     [operation start];
 }
 
 + (void) fetchAllDB {
    [self fetchDBFile:@"Master.sqlite"];
}



@end

/*
 #import "AFNetworking.h"
 #import <AFNetworking/AFNetworking.h>
 
 @implementation ConnectionManager
 
 + (void) fetchDBFile : (NSString *)dbfileName
 {
 //    NSString * dbURI = @"http://127.0.0.1:3000";
 //    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST";
 NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/app/database";
 
 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", dbURI, dbfileName]];
 NSLog(@"%@", url);
 NSURLRequest *myRequest;
 
 myRequest = [NSURLRequest requestWithURL:url
 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
 timeoutInterval:30.0];
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
 
 // sqliteの保存場所を指定
 NSString *documentDir;
 documentDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
 dbfileName = [NSString stringWithFormat:@"%@", dbfileName];
 NSString *downloadDestinationPath = [documentDir stringByAppendingPathComponent:dbfileName];
 operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadDestinationPath append:NO];
 
 
 [operation
 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
 id responseObject)
 {
 NSLog(@"ダウンロード成功！ dbの保存先:%@", downloadDestinationPath);
 }
 failure:^(AFHTTPRequestOperation *operation,
 NSError *error)
 {
 NSLog(@"Error ->: %@", [error localizedDescription]);
 }];
 
 [operation start];
 }
 
 + (void) fetchAllDB {
 //    [self fetchDBFile:@"BurData.sqlite"];
 //    [self fetchDBFile:@"UpdateData.sqlite"];
 
[self fetchDBFile:@"Master.sqlite"];
[self fetchDBFile:@"Azukari.sqlite"];

}


+ (void)uploadFile : (NSString *) dbfileName;
{
    //    NSString * dbURI = @"http://127.0.0.1:3000/fromIOS";
    //    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/iosReceiver.php";
    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/public/iosReceiver";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * tanto = [[NSUserDefaults standardUserDefaults] objectForKey:@"tantoID"];
    NSDictionary *params = @{ @"tanto": tanto};
    
    NSString *documentDir;
    documentDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *uploadLocationPath = [documentDir stringByAppendingPathComponent:dbfileName];
    
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:uploadLocationPath];
    
    [manager POST : dbURI
       parameters : params
constructingBodyWithBlock : ^( id <AFMultipartFormData> formData )
     {
         [formData appendPartWithFileData:data name:@"file" fileName:dbfileName mimeType:@"application/x-sqlite3"];
         
     }
          success : ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //         NSLog(@"response is :  %@",responseObject);
     }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ *****", [error description]);
     }];
    
    
}


+ (void)uploadKey : (NSString *) key value : (NSString *) value
{
    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/iosReceiver.php";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ key : value};
    
    [manager POST : dbURI
       parameters : params
constructingBodyWithBlock : ^( id <AFMultipartFormData> formData )
     {
     }
          success : ^(AFHTTPRequestOperation *operation, id responseObject)
     {
     }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ *****", [error description]);
     }];
    
    
}



*/