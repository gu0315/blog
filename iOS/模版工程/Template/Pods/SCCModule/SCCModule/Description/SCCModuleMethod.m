//
//  SCCModuleMethod.m
//  Pods
//
//  Created by 葛亮 on 16/10/20.
//
//

#import "SCCModuleMethod.h"
#import "SCCModuleDescription.h"
#import "SCCModulor.h"

@interface SCCModuleMethod ()

@property (nonatomic) SEL methodSelector;

@property (nonatomic, copy) NSString *methodName;

@property (nonatomic) BOOL isNativeMethod;

@property (nonatomic) BOOL isClassMethod;

@property (nonatomic) SCCParamType methodResultType;

@property (nonatomic, strong) SCCModuleParamEnumerator *enumerator;

@end

@implementation SCCModuleMethod

- (instancetype)init {
    if (self = [super init]) {
        self.methodName = @"";
        self.isNativeMethod = NO;
        self.isClassMethod = NO;
        self.methodResultType = SCCParamTypeEmpty;
    }
    return self;
}

#pragma mark - 设置method相关描述

- (SCCModuleMethod *(^)(NSString *))name {
    return ^SCCModuleMethod *(NSString *name) {
        NSParameterAssert(name);
        self.methodName = name;
        return self;
    };
}

- (SCCModuleMethod *)name:(NSString *)name {
    return self.name(name);
}

- (SCCModuleMethod *(^)(SEL))selector {
    return ^SCCModuleMethod *(SEL selector) {
        NSParameterAssert(selector);
        self.methodSelector = selector;
        return self;
    };
}

- (SCCModuleMethod *)selector:(SEL)selector {
    return self.selector(selector);
}

- (SCCModuleMethod *(^)(BOOL))justNative {
    return ^SCCModuleMethod *(BOOL justNative) {
        self.isNativeMethod = justNative;
        return self;
    };
}

- (SCCModuleMethod *)justNative:(BOOL)justNative {
    return self.justNative(justNative);
}

- (SCCModuleMethod *(^)(BOOL))classMethod {
    return ^SCCModuleMethod *(BOOL classMethod) {
        self.isClassMethod = classMethod;
        return self;
    };
}

- (SCCModuleMethod *)classMethod:(BOOL)classMethod {
    return self.classMethod(classMethod);
}

- (SCCModuleMethod *(^)(void (^)(SCCModuleParamEnumerator *enumerator)))parameters {
    return ^SCCModuleMethod *(void (^paramsDescriptionBlock)(SCCModuleParamEnumerator *enumerator)) {
        NSParameterAssert(paramsDescriptionBlock);
        if (paramsDescriptionBlock && self.methodSelector) {
            NSMethodSignature *sig;
            if (self.isClassMethod) {
                sig = [self.module.moduleClass methodSignatureForSelector:self.methodSelector];
            } else {
                sig = [self.module.moduleClass instanceMethodSignatureForSelector:self.methodSelector];
            }
            if (sig) {
                NSUInteger argNum = [sig numberOfArguments];
                for (int i = 2; i < argNum; i++) {
                    SCCModuleParam *param = [[SCCModuleParam alloc] init];
                    [self.enumerator.params addObject:param];
                }
                paramsDescriptionBlock([self.enumerator enumerate]);
                NSAssert([self.enumerator end], @"请描述所有的参数");
            }
        }
        return self;
    };
}

- (SCCModuleMethod *)parameters:(void (^)(SCCModuleParamEnumerator *enumerator))paramsDescriptionBlock {
    return self.parameters(paramsDescriptionBlock);
}

- (SCCModuleMethod *)resultType:(SCCParamType)type {
    return self.resultType(type);
}

- (SCCModuleMethod *(^)(SCCParamType))resultType {
    return ^SCCModuleMethod *(SCCParamType returnType) {
        self.methodResultType = returnType;
        return self;
    };
}

#pragma mark - 执行方法

- (id)invokeWithParams:(NSDictionary *)params callback:(void (^)(NSDictionary *))callback {
    id module;
    id returnOb;
    NSMethodSignature *sig;
    if (self.isClassMethod) {
        module = self.module.moduleClass;
        sig = [self.module.moduleClass methodSignatureForSelector:self.methodSelector];
    } else {
        module = [[self.module.moduleClass alloc] init];
        sig = [module methodSignatureForSelector:self.methodSelector];
    }
    if (sig) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
        inv.selector = self.methodSelector;
        inv.target = module;
        
        NSMutableArray *holder = [NSMutableArray arrayWithCapacity:self.enumerator.params.count];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        [self.enumerator.params enumerateObjectsUsingBlock:^(SCCModuleParam * _Nonnull param, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramName = param.paramName;
            NSString *paramTypeDesc = @"";
            if (paramName) {
                id paramValue = params[paramName];
                switch (param.paramType) {
                    case SCCParamTypeBlock: {
                        paramValue = nil;
                        [inv setArgument:&callback atIndex:idx + 2];
                        break;
                    }
                    case SCCParamTypeMap: {
                        if (![paramValue isKindOfClass:[NSDictionary class]] && !param.isStrict) {
                            paramValue = params;
                        } else if (![paramValue isKindOfClass:[NSDictionary class]] && param.isStrict) {
                            if (paramValue) {
                                paramTypeDesc = @"Map";
                            }
                            paramValue = nil;
                        }
                        break;
                    }
                    case SCCParamTypeString: {
                        if (![paramValue isKindOfClass:[NSString class]]) {
                            if (paramValue) {
                                paramTypeDesc = @"String";
                            }
                            paramValue = nil;
                        }
                        break;
                    }
                    case SCCParamTypeNumber: {
                        if ([paramValue isKindOfClass:[NSString class]]) {
                            paramValue = [[[NSNumberFormatter alloc] init] numberFromString:paramValue];
                        } else if (![paramValue isKindOfClass:[NSNumber class]]) {
                            if (paramValue) {
                                paramTypeDesc = @"Number";
                            }
                            paramValue = nil;
                        }
                        break;
                    }
                    case SCCParamTypeObject: {
                        break;
                    }
                    case SCCParamTypeArray: {
                        if (![paramValue isKindOfClass:[NSArray class]]) {
                            if (paramValue) {
                                paramTypeDesc = @"Array";
                            }
                            paramValue = nil;
                        }
                        break;
                    }
                    default:
                        paramValue = nil;
                        break;
                }
                if (paramValue) {
                    [holder addObject:paramValue];
                    [inv setArgument:&paramValue atIndex:idx + 2];
                }else if (param.paramType != SCCParamTypeBlock && param.paramType != SCCParamTypeObject && [paramTypeDesc length] > 0){
                    // block 和 object 不存在类型转换问题
                    if ([SCCModulor modulor].exceptionHandler) {
                        NSException* exception = [[NSException alloc] initWithName:@"Param format failed" reason:[NSString stringWithFormat:@"key: %@ value: %@ to type: %@ failed", paramName, params[paramName], paramTypeDesc] userInfo: @{@"paramName": paramName, @"paramType": [param.class typeDescription: param.paramType], @"value": params[paramName], @"moduleName": self.module.moduleName}];
                        [SCCModulor modulor].exceptionHandler(exception);
                    }
                }
            }
        }];
#pragma clang diagnostic pop
        [inv retainArguments];
        [inv invoke];
        NSUInteger length = sig.methodReturnLength;
        NSString *type = [NSString stringWithUTF8String:sig.methodReturnType];
        if (length > 0
            && [type isEqualToString:@"@"]
            && self.methodResultType != SCCParamTypeUnknown
            && self.methodResultType != SCCParamTypeEmpty) {
            void *buffer;
            [inv getReturnValue:&buffer];
            returnOb = (__bridge id)(buffer);
        }
    }
    
    return returnOb;
}

#pragma mark - getter

- (SCCModuleParamEnumerator *)enumerator {
    if (!_enumerator) {
        _enumerator = [[SCCModuleParamEnumerator alloc] init];
    }
    return _enumerator;
}
#pragma mark - 模块方法描述

- (NSString *)description {
    NSMutableString *des = [NSMutableString stringWithFormat:@"\n==============方法==============\n名称：%@ \nSEL：%@ \n支持URL：%@ \n类方法：%@ \n", self.methodName, NSStringFromSelector(self.methodSelector), self.isNativeMethod ? @"false" : @"true", self.isClassMethod ? @"true" : @"false"];
    [self.enumerator.params enumerateObjectsUsingBlock:^(SCCModuleParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [des appendString:[NSString stringWithFormat:@"参数%@：%@\n", @(idx), [obj description]]];
    }];
    [des appendString:[NSString stringWithFormat:@"返回值：%@\n", [SCCModuleParam typeDescription:self.methodResultType]]];
    [des appendString:@"==================================\n"];
    return des.copy;
}

- (NSDictionary *)jsonDescription {
    NSMutableArray *arr = [NSMutableArray array];
    [self.enumerator.params enumerateObjectsUsingBlock:^(SCCModuleParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj.jsonDescription];
    }];
    NSDictionary *jsonDic = @{@"methodName": self.methodName,
                              @"methodSEL": NSStringFromSelector(self.methodSelector),
                              @"isNativeMethod": @(self.isNativeMethod),
                              @"isClassMethod": @(self.isClassMethod),
                              @"params": arr.copy,
                              @"return": [SCCModuleParam typeDescription:self.methodResultType]};
    return jsonDic;
}
@end
