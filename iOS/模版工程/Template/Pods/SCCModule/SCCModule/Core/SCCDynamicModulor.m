//
//  SCCDynamicModulor.m
//  Pods
//
//  Created by 葛亮 on 16/12/21.
//
//

#import "SCCDynamicModulor.h"

@implementation SCCDynamicModulor

+ (instancetype)dynamicModulor {
    static SCCDynamicModulor *dynamicModulor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dynamicModulor = [[SCCDynamicModulor alloc] init];
    });
    return dynamicModulor;
}

- (SCCModuleDescription *)dynamicModuleDescriptionWithName:(NSString *)name {
    //TODO: 增加动态modulor的下发机制
    return nil;
}

@end

