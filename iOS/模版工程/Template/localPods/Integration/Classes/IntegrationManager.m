//
//  IntegrationManager.m
//  Template
//
//  Created by 顾钱想 on 2022/7/18.
//
#import <UIKit/UIKit.h>
#import "IntegrationManager.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "IntegrationProtocol.h"

#define InjectableSectionName "QXInjectable"

static NSArray<Class>* readConfigurationClasses(){
    NSMutableArray<Class> * classes = [[NSMutableArray alloc] init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
        NSString *fullAppName = [NSString stringWithFormat:@"/%@.app/", appName];
        char *fullAppNameC = (char *)[fullAppName UTF8String];
        int num = _dyld_image_count();
        for (int i = 0; i < num; i++) {
            const char *name = _dyld_get_image_name(i);
            if (strstr(name, fullAppNameC) == NULL) {
                continue;
            }
            const struct mach_header *header = _dyld_get_image_header(i);
            Dl_info info;
            dladdr(header, &info);
            
            #ifndef __LP64__
                const struct mach_header *mhp = (struct mach_header*)info.dli_fbase;
                unsigned long size = 0;
                uint32_t *memory = (uint32_t*)getsectiondata(mhp, "__DATA", InjectableSectionName, & size);
            #else
                const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
                unsigned long size = 0;
                uint64_t *memory = (uint64_t*)getsectiondata(mhp, "__DATA", InjectableSectionName, & size);
            #endif
            for(int idx = 0; idx < size/sizeof(void*); ++idx){
                char *string = (char*)memory[idx];
                NSString *str = [NSString stringWithUTF8String:string];
                str = [str substringWithRange:NSMakeRange(2, str.length-3)];
                NSArray<NSString*> *components = [str componentsSeparatedByString:@" "];
                str = [components objectAtIndex:0];
                if(!str)return;

                NSString *className;
                NSRange range = [str rangeOfString:@"("];
                if(range.length > 0){
                    className = [str substringToIndex:range.location];
                } else{
                    className = str;
                }
                Class cls = NSClassFromString(className);
                if(cls) {
                    [classes addObject:cls];
                }
            }
        }
    });
    return classes;
}

@implementation IntegrationManager : NSObject

+ (Class)classForProtocol:(Protocol*)protocol{
    NSArray<Class> *classes = [self classesForProtocol_internal:protocol];
    Class result = NULL;
    for (Class cls in classes) {
        if(result == NULL){
            result = cls;
        }else{
            if([result integrationPriority] < [cls integrationPriority]){
                result = cls;
            }
        }
    }
    return result;
}

+ (NSArray<Class>*)classesForProtocol:(Protocol*)protocol{
    return [self classesForProtocol_internal:protocol];
}

+ (NSArray<Class>*)classesForProtocol_internal:(Protocol*)protocol{
    NSArray<Class> *allClasses = readConfigurationClasses();
    NSMutableArray<Class> *result = [NSMutableArray new];
    for (Class cls in allClasses) {
        if(class_conformsToProtocol(cls, protocol)){
            [result addObject:cls];
        }
    }
    NSLog(@"classes = \n%@", allClasses);
    return allClasses;
}


+ (void)executeArrayForProtocol:(Protocol*)protocol {
    NSArray<Class> *classes = [self classesForProtocol_internal:protocol];
    //TODO 遍历优先级,优先级高的先初始化
    NSArray<Class> *result = [classes sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2]; // 升序
    }];
    for (Class cls in result) {
        if(class_conformsToProtocol(cls, protocol)){
            [cls fb_injectable];
        }
    }
}


@end
