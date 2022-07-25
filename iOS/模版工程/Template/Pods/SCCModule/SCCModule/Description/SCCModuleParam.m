//
//  SCCModuleParam.m
//  Pods
//
//  Created by 葛亮 on 16/10/20.
//
//

#import "SCCModuleParam.h"


@interface SCCModuleParam ()

@property (nonatomic, copy) NSString *paramName;

@property (nonatomic) SCCParamType paramType;

@property (nonatomic) BOOL isStrict;
@end

@implementation SCCModuleParam

- (instancetype)init {
    if (self = [super init]) {
        self.paramName = @"";
        self.paramType = SCCParamTypeUnknown;
        self.isStrict = NO;
    }
    return self;
}
#pragma mark - 参数描述

- (SCCModuleParam * _Nonnull (^)(BOOL))strict {
    return ^SCCModuleParam *(BOOL isStrict) {
        self.isStrict = isStrict;
        return self;
    };
}

- (SCCModuleParam *)strict:(BOOL)isStrict {
    return self.strict(isStrict);
}

- (SCCModuleParam *(^)(NSString *))name {
    return ^SCCModuleParam *(NSString *name) {
        NSParameterAssert(name);
        self.paramName = name;
        return self;
    };
}

- (SCCModuleParam *)name:(NSString *)name {
    return self.name(name);
}

- (SCCModuleParam *(^)(SCCParamType))type {
    return ^SCCModuleParam *(SCCParamType type) {
        self.paramType = type;
        return self;
    };
}

- (SCCModuleParam *)type:(SCCParamType)type {
    return self.type(type);
}

#pragma mark - 参数描述

- (NSString *)description {    
    NSString *des = [NSString stringWithFormat:@"%@:%@", self.paramName, [self.class typeDescription:self.paramType]];
    return des;
}

+ (NSString *)typeDescription:(SCCParamType)type {
    NSString *des = @"";
    switch (type) {
        case SCCParamTypeString:
            des = @"String";
            break;
        case SCCParamTypeNumber:
            des = @"Number";
            break;
        case SCCParamTypeBlock:
            des = @"Block";
            break;
        case SCCParamTypeObject:
            des = @"Object";
            break;
        case SCCParamTypeUnknown:
            des = @"Unknown";
            break;
        case SCCParamTypeMap:
            des = @"Map";
            break;
        case SCCParamTypeArray:
            des = @"Array";            
            break;
        case SCCParamTypeEmpty:
            des = @"Empty";
    }
    return des;
}

- (NSDictionary *)jsonDescription {
    NSDictionary *jsonDic = @{@"paramName": self.paramName,
                              @"paramType": [self.class typeDescription:self.paramType]};
    return jsonDic;
}
@end
