//
//  SCCModuleDescription.m
//  Pods
//
//  Created by 葛亮 on 16/10/20.
//
//

#import "SCCModuleDescription.h"

@interface SCCModuleDescription ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, SCCModuleMethod *> *moduleMethods;

@property (nonatomic, copy) NSString *moduleName;

@property (nonatomic) Class moduleClass;
@end

@implementation SCCModuleDescription

- (instancetype)init {
    if (self = [super init]) {
        self.moduleName = @"";        
    }
    return self;
}
#pragma mark - 模块描述方法

- (SCCModuleDescription *(^)(Class))cls {
    return ^SCCModuleDescription *(Class cls) {
        NSParameterAssert(cls);
        self.moduleClass = cls;
        return self;
    };
}

- (SCCModuleDescription *)cls:(Class)cls {
    return self.cls(cls);
}

- (SCCModuleDescription *(^)(NSString *))name {
    return ^SCCModuleDescription *(NSString * name) {
        NSParameterAssert(name);
        self.moduleName = name;
        return self;
    };
}

- (SCCModuleDescription *)name:(NSString *)name {
    return self.name(name);
}

- (SCCModuleDescription *(^)(void (^)(SCCModuleMethod *method)))method {
    return ^SCCModuleDescription *(void (^methodDescriptionBlock)(SCCModuleMethod *method)) {
        NSParameterAssert(methodDescriptionBlock);
        if (methodDescriptionBlock) {
            SCCModuleMethod *method = [[SCCModuleMethod alloc] init];
            method.module = self;
            methodDescriptionBlock(method);
            NSAssert(method.methodName.length, @"请给方法设置名称");
            [self.moduleMethods setObject:method forKey:method.methodName];
        }
        return self;
    };
}

- (SCCModuleDescription *)method:(void (^)(SCCModuleMethod *method))methodDescriptionBlock {
    return self.method(methodDescriptionBlock);
}

- (SCCModuleDescription * _Nonnull (^)(void (^ _Nonnull)(SCCModuleMethod * _Nonnull)))openMethod {
    return ^SCCModuleDescription *(void (^methodDescriptionBlock)(SCCModuleMethod *method)) {
        NSParameterAssert(methodDescriptionBlock);
        if (methodDescriptionBlock) {
            SCCModuleMethod *method = [[SCCModuleMethod alloc] init];
            method.module = self;
            methodDescriptionBlock(method);
            method.name(@"open");
            [self.moduleMethods setObject:method forKey:method.methodName];
        }
        return self;
    };
}

- (SCCModuleDescription *)openMethod:(void (^)(SCCModuleMethod * _Nonnull))methodDescriptionBlock {
    return self.openMethod(methodDescriptionBlock);
}
#pragma mark - getter

- (NSMutableDictionary *)moduleMethods {
    if (!_moduleMethods) {
        _moduleMethods = [[NSMutableDictionary alloc] init];
    }
    return _moduleMethods;
}

#pragma mark - 模块描述

- (NSString *)description {
    NSMutableString *des = [NSMutableString stringWithFormat:@"\n+++++++++++++++++++模块+++++++++++++++++++++\n名称：%@ \n类名：%@", self.moduleName, NSStringFromClass(self.moduleClass)];
    [self.moduleMethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SCCModuleMethod * _Nonnull obj, BOOL * _Nonnull stop) {        
        [des appendString:[obj description]];
    }];
    [des appendString:@"\n++++++++++++++++++++++++++++++++++++++++++++\n"];
    return des.copy;
}

- (NSDictionary *)jsonDescription {
    NSMutableArray *arr = [NSMutableArray array];
    [self.moduleMethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SCCModuleMethod * _Nonnull obj, BOOL * _Nonnull stop) {
        [arr addObject:obj.jsonDescription];
    }];
    NSDictionary *jsonDic = @{@"moduleName": self.moduleName,
                              @"moduleClass": NSStringFromClass(self.moduleClass),
                              @"moduleMethods": arr.copy};
    return jsonDic;
}
@end
