//
//  SCCViewControllerModuleConfig.h
//  Pods
//
//  Created by 葛亮 on 16/8/2.
//
//

#import <Foundation/Foundation.h>

@interface SCCViewControllerModuleConfig : NSObject

+ (instancetype)config NS_SWIFT_NAME(sharedInstance());

@property (nonatomic, copy) NSString *default404ModuleURL;

@end
