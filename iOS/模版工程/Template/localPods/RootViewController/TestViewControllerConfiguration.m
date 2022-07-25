//
//  TestViewControllerConfiguration.m
//  RootViewController
//
//  Created by 顾钱想 on 2022/7/25.
//

#import "TestViewControllerConfiguration.h"
#import "IntegrationManager.h"
#import <objc/runtime.h>

char *kTestViewControllerConfiguration InjectableDATA = "+[TestViewControllerConfiguration(FBInjectable) fb_injectable]";

@implementation TestViewControllerConfiguration

+ (long)integrationPriority {
    return  2;
}

+ (void)fb_injectable {
    
}

@end

