//
//  SCCDynamicModulor.h
//  Pods
//
//  Created by 葛亮 on 16/12/21.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SCCModuleDescription;

@interface SCCDynamicModulor : NSObject

+ (instancetype)dynamicModulor NS_SWIFT_NAME(sharedInstance());

- (SCCModuleDescription *)dynamicModuleDescriptionWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
