//
//  NetworkManager.m
//  HandyPOS_Cashier
//
//  Created by 小泉 丈太 on 2015/07/31.
//  Copyright © 2015年 小泉 丈太. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "DBHelper.h"

@implementation NetworkManager
 
 + (void) fetchDBFile : (NSString *)dbfileName
 {
     NSString * dbURI        = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/app/database";
     NSString * documentDir  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
     NSString * downloadDestinationPath = [documentDir stringByAppendingPathComponent:dbfileName];
     NSURL    * url;
     NSURLRequest * myRequest;
     AFHTTPRequestOperation * operation;
     
     url        = [NSURL
                   URLWithString : [NSString stringWithFormat:@"%@/%@", dbURI, dbfileName]];
     
     myRequest  = [NSURLRequest
                                requestWithURL : url
                                cachePolicy : NSURLRequestReloadIgnoringLocalCacheData
                                timeoutInterval : 30.0];
     
     operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
     
     operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadDestinationPath append:NO];
     
     
     [operation
      setCompletionBlockWithSuccess : ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ダウンロード成功！ dbの保存先:%@", downloadDestinationPath);
     }
      failure : ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error ->: %@", [error localizedDescription]);
     }
      ];
     
     [operation start];
 }
 
 + (void) fetchAllDB {
     [self fetchDBFile:@"Cashier.sqlite"];
}



@end