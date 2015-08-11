//
//  DefaultSettings.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/11.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "AppDelegate.h"
#import "DefaultSettings.h"

@implementation DefaultSettings

+ (void) saveIfNotExistsPrinterPath : (NSString *) path {
    
    NSError * error;
    
    AppDelegate * appDelegate        = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    NSEntityDescription * descript   = [NSEntityDescription entityForName:@"DefaultSettings" inManagedObjectContext:context];
    
    NSFetchRequest * request         = [[NSFetchRequest alloc] init];
    [request setEntity:descript];
    
    NSArray * result                 = [context executeFetchRequest:request error:&error];
    
    if (result.count > 0) {
        return;
    }
    
    DefaultSettings * settings       = [NSEntityDescription insertNewObjectForEntityForName:@"DefaultSettings" inManagedObjectContext:context];
    [settings setPrinterPATH:path];
    if (![context save:&error]) {
        NSLog(@"Error in saving to coredata");
    }
}

+ (void) removeAllPrinterPath {
    
    NSError * error;
    
    AppDelegate * appDelegate        = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    NSEntityDescription * descript   = [NSEntityDescription entityForName:@"DefaultSettings" inManagedObjectContext:context];
    
    NSFetchRequest * request         = [[NSFetchRequest alloc] init];
    [request setEntity:descript];
    
    NSArray * result                 = [context executeFetchRequest:request error:&error];
    
    for (NSManagedObject * toBeRemoved in result) {
        [context deleteObject:toBeRemoved];
    }
    
}

+ (NSString *) getPrintPath {
    NSError * error;
    AppDelegate * appDelegate        = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    NSEntityDescription * descript   = [NSEntityDescription entityForName:@"DefaultSettings" inManagedObjectContext:context];
    NSFetchRequest *      request    = [[NSFetchRequest alloc] init];
    [request setEntity:descript];
    NSArray * result                 = [context executeFetchRequest:request error:&error];
    NSString * printerPath           = [result[0] valueForKey:@"printerPATH"];
    return printerPath;
}

@end
