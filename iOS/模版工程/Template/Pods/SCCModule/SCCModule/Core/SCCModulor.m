//
//  SCCModulor.m
//  Pods
//
//  Created by 葛亮 on 16/5/26.
//
//

#import "SCCModulor.h"
#import "SCCModuleURL.h"
#import "SCCModuleProtocol.h"
#import <objc/runtime.h>
#import "SCCModuleDescription.h"
#import "SCCDynamicModulor.h"
#import "SCCModulorTakeEffectManager.h"

@implementation SCCModulor

static NSDictionary<NSString *, SCCModuleDescription *> *cache;

+ (instancetype)modulor {
    static SCCModulor *modulor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modulor = [[SCCModulor alloc] init];
    });
    return modulor;
}


- (instancetype)init {
    if (self = [super init]) {
        [self _cacheModuleProtocolClasses];
    }
    return self;
}

- (NSArray *)moduleScheme {
    if (!_moduleSchemes) {
        _moduleSchemes = @[];
    }
    return _moduleSchemes;
}

#pragma mark - dynamic modulor description

- (SCCModuleDescription *)moduleDescriptionWithName:(NSString *)name {
    NSParameterAssert(name);
    SCCModuleDescription *moduleDes = [[SCCDynamicModulor dynamicModulor] dynamicModuleDescriptionWithName:name];
    if (!moduleDes) {
        moduleDes = cache[name];
    }
    return moduleDes;
}


- (NSArray <SCCModuleDescription *> *)moduleDescriptionsWithURLString:(NSString *)urlString {
    NSParameterAssert(urlString);
    SCCModuleURL *url = [[SCCModuleURL alloc] initWithString:urlString];
    NSMutableArray<SCCModuleDescription *> *moduleDescriptions = [NSMutableArray array];
    if (![self.moduleSchemes containsObject:url.scheme]) {
        return moduleDescriptions;
    }
    if (url) {
        [url.module_names enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCCModuleDescription *moduleDes = [self moduleDescriptionWithName:[url moduleRealName:obj]];
            if (moduleDes) {
                [moduleDescriptions addObject:moduleDes];
            }
        }];
    }
    return moduleDescriptions;
}

#pragma mark - public method

- (NSArray *)modulesURLString:(NSString *)urlString performWithParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    NSParameterAssert(urlString);
    SCCModuleURL *url = [[SCCModuleURL alloc] initWithString:urlString];
    NSMutableArray *modules = [NSMutableArray array];
    if (![self.moduleSchemes containsObject:url.scheme]) {
        if ([SCCModulor modulor].unrecognizedInterceptor) {
            [[SCCModulor modulor].unrecognizedInterceptor sccInterceptOriginURL:urlString params:params callback:callback];
        }
        return modules;
    }
    if (url) {
        [url.module_names enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCCModuleDescription *moduleDes = [self moduleDescriptionWithName:[url moduleRealName:obj]];
            SCCModuleMethod *method = moduleDes.moduleMethods[url.module_method];
            if (!method.isNativeMethod) {
                NSMutableDictionary *methodParam = [NSMutableDictionary dictionaryWithDictionary:url.module_param];
                [methodParam addEntriesFromDictionary:params];
                id module = [method invokeWithParams:methodParam callback:callback];
                if (module) {
                    [modules addObject:module];
                }
            }
        }];
    }
    if ((!modules || modules.count == 0) && [SCCModulor modulor].unrecognizedInterceptor) {
        [[SCCModulor modulor].unrecognizedInterceptor sccInterceptOriginURL:urlString params:params callback:callback];
    }
    return modules.copy;
}

- (id)moduleName:(NSString *)moduleName performSelectorName:(NSString *)selectorName withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    NSParameterAssert(moduleName);
    NSParameterAssert(selectorName);
    id module;
    SCCModuleDescription *moduleDes = [self moduleDescriptionWithName:moduleName];
    SCCModuleMethod *method = moduleDes.moduleMethods[selectorName];
    if (method) {
        module = [method invokeWithParams:params callback:callback];
    }
    return module;
}

- (id)moduleName:(NSString *)moduleName openWithParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    NSParameterAssert(moduleName);
    id module;
    if (!module) {
        module = [self moduleName:moduleName performSelectorName:@"open.present" withParams:params callback:callback];
    }
    if (!module) {
        module = [self moduleName:moduleName performSelectorName:@"open" withParams:params callback:callback];
    }
    return module;
}

- (BOOL)isValidModuleUrlString:(NSString *)urlString {
    NSParameterAssert(urlString);
    SCCModuleURL *url = [[SCCModuleURL alloc] initWithString:urlString];
    __block BOOL isValid = NO;
    [url.module_names enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isValidModuleName:[url moduleRealName:obj]]) {
            isValid = YES;
        } else {
            isValid = NO;
            *stop = YES;
        }
    }];
    return isValid;
}

- (BOOL)isValidModuleName:(NSString *)moduleName {
    NSParameterAssert(moduleName);
    BOOL isValid = YES;
    SCCModuleDescription *moduleDes = cache[moduleName];
    if (!moduleDes) {
        isValid = NO;
    }
    return isValid;
}

- (void)modulesLog {
    __block NSInteger i = 0;
    [cache enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SCCModuleDescription * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"\n/////////////////// %@ \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ %@", @(i), obj);
        i++;
    }];
}

- (NSDictionary *)modulesJsonDescription {
    NSMutableArray *arr = [NSMutableArray array];
    [cache enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SCCModuleDescription * _Nonnull obj, BOOL * _Nonnull stop) {
        [arr addObject:obj.jsonDescription];
    }];
    NSDictionary *jsonDic = @{@"scheme": self.moduleScheme,
                              @"build": [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"],
                              @"version": [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"],
                              @"modules":arr};
    return jsonDic;
}

- (void)moduleLogWithName:(NSString *)name {
    NSParameterAssert(name);
    SCCModuleDescription *moduleDes = cache[name];
    NSLog(@"%@", moduleDes);
}
#pragma mark - 工具方法

- (void)_cacheModuleProtocolClasses {
    if (cache.count) {
        return;
    }
    Class *classes;
    unsigned int outCount;
    classes = objc_copyClassList(&outCount);
    NSMutableDictionary *tmpCache = [NSMutableDictionary dictionary];
    for (unsigned int i = 0; i < outCount; i++) {
        Class cls = classes[i];
        if (class_conformsToProtocol(cls, @protocol(SCCModuleProtocol))) {
            SCCModuleDescription *moduleDes;
            if ([cls respondsToSelector:@selector(moduleDescription:)]) {
                moduleDes = [[SCCModuleDescription alloc] init].cls(cls);
                [cls moduleDescription:moduleDes];
            } else {
                moduleDes = [self _compatibleModuleWithClass:cls];
            }
            if ([tmpCache objectForKey:moduleDes.moduleName] != nil) {
                if ([[SCCModulorTakeEffectManager manager].moduleTakeEffect.allKeys containsObject:moduleDes.moduleName]) {
                    if ([[[SCCModulorTakeEffectManager manager].moduleTakeEffect objectForKey:moduleDes.moduleName] isEqualToString:NSStringFromClass(cls)]) {
                        [tmpCache setObject:moduleDes forKey:moduleDes.moduleName];
                    }
                }else{
                    NSAssert([tmpCache objectForKey:moduleDes.moduleName] == nil, @"in class %@, module %@ has defined, please check!", NSStringFromClass(cls), moduleDes.moduleName);
                }
            }else{
                [tmpCache setObject:moduleDes forKey:moduleDes.moduleName];
            }
        }
    }
    free(classes);
    cache = tmpCache.copy;
}

- (void)registerModules:(NSArray <SCCModuleDescription *> *)modules {
    NSMutableDictionary *tmpCache = cache.mutableCopy;
    [modules enumerateObjectsUsingBlock:^(SCCModuleDescription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpCache setObject:obj forKey:obj.moduleName];
    }];
    
    cache = tmpCache.copy;
}

- (SCCModuleDescription *)_compatibleModuleWithClass:(Class)cls {
    NSString *moduleName = @"";
    NSString *moduleDescription = @"";
    
    if ([cls respondsToSelector:@selector(moduleName)]) {
        moduleName = [cls moduleName];
    }
    
    if ([cls respondsToSelector:@selector(moduleDescription)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        moduleDescription = [[cls moduleDescription] isKindOfClass:[NSString class]] ? [cls moduleDescription] : @"";
#pragma clang diagnostic pop
    }
    
    SCCModuleDescription *moduleDes = [[SCCModuleDescription alloc] init].cls(cls).name(moduleName);
    if ([cls instancesRespondToSelector:@selector(open:callback:)]) {
        [[moduleDes method:^(SCCModuleMethod * _Nonnull method) {
            [[method.name(@"open").selector(@selector(open:callback:)) parameters:^(SCCModuleParamEnumerator * _Nonnull enumerator) {
                    enumerator.next.name(@"dic").type(SCCParamTypeMap);
                    enumerator.next.name(@"block").type(SCCParamTypeBlock);
            }] resultType:SCCParamTypeObject];
        }]  method:^(SCCModuleMethod * _Nonnull method) {
            [[method.name(@"open_callback").selector(@selector(open:callback:)) parameters:^(SCCModuleParamEnumerator * _Nonnull enumerator) {
                enumerator.next.name(@"dic").type(SCCParamTypeMap);
                enumerator.next.name(@"block").type(SCCParamTypeBlock);
            }] resultType:SCCParamTypeObject];
        }];
    }
    if ([cls instancesRespondToSelector:@selector(open_present:callback:)]) {
        [moduleDes method:^(SCCModuleMethod * _Nonnull method) {
            [[method.name(@"open.present").selector(@selector(open_present:callback:)) parameters:^(SCCModuleParamEnumerator * _Nonnull enumerator) {
                enumerator.next.name(@"dic").type(SCCParamTypeMap);
                enumerator.next.name(@"block").type(SCCParamTypeBlock);
            }] resultType:SCCParamTypeObject];
        }];
    }
    
    return moduleDes;
}
@end



