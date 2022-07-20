//
//  IntegrationManager.h
//  Template
//
//  Created by 顾钱想 on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define InjectableDATA __attribute((used, section("__DATA, QXInjectable")))

@interface IntegrationManager : NSObject

+ (Class)classForProtocol:(Protocol*)protocol;
+ (NSArray<Class>*)classesForProtocol:(Protocol*)protocol;

@end

NS_ASSUME_NONNULL_END

