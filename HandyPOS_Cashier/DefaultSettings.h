//
//  DefaultSettings.h
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/11.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefaultSettings : NSManagedObject

+ (void) removeAllPrinterPath ;
+ (void) saveIfNotExistsPrinterPath : (NSString *) path ;
+ (NSString *) getPrintPath ;

@end

NS_ASSUME_NONNULL_END

#import "DefaultSettings+CoreDataProperties.h"
