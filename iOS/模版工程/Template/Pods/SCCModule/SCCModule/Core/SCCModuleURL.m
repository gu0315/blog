//
//  SCCModuleURL.m
//  Pods
//
//  Created by 葛亮 on 16/5/26.
//
//

#import "SCCModuleURL.h"
#import "SCCModuleURLInitInterceptor.h"

static NSString * const kCheniuEqual = @"%3D"; // =
static NSString * const kCheniuEqualMark = @"=";
static NSString * const kCheniuInterrogate = @"%3F"; // ?
static NSString * const kCheniuInterrogateMark = @"?";
static NSString * const kCheniuAnd = @"%26"; // &
static NSString * const kCheniuAndMark = @"&";
static NSString * const kCheniuLeftBracket = @"%5b"; //[
static NSString * const kCheniuLeftBracketMark = @"[";
static NSString * const kCheniuRightBracket = @"%5d"; //]
static NSString * const kCheniuRightBracketMark = @"]";
static NSString * const kCheniuOctothorpe = @"%23";
static NSString * const kCheniuOctothorpeMark = @"#";

@interface SCCModuleURL ()

@property (nonatomic, copy) NSString *module_action;
@property (nonatomic, strong) NSDictionary *module_param;
@property (nonatomic, strong) NSArray<NSString *> *module_names;
@property (nonatomic, copy) NSString *module_method;
@end
@implementation SCCModuleURL

static id<SCCModuleURLInitInterceptor> urlInitInterceptor = nil;

+ (void)setupURLInitInterceptor:(id<SCCModuleURLInitInterceptor>)interceptor {
    urlInitInterceptor = interceptor;
}

- (instancetype)initWithString:(NSString *)URLString {
    if (!URLString) {
        URLString = @"";
    }
    
    if (urlInitInterceptor) {
        URLString = [urlInitInterceptor interceptOriginURL:URLString];
    }
    
    if (self = [super initWithString:URLString]) {        
        self.module_names = [self _analyzePath];
        self.module_param = [self _analyzeQuery];
        self.module_method = [self.host copy];
    }
    return self;
}

#pragma mark - public method

- (NSString *)moduleRealName:(NSString *)moduleName {
    NSParameterAssert(moduleName);
    NSRange range = [moduleName rangeOfString:@"$"];
    if (range.location == 0 && moduleName.length > 1) {
        moduleName = [moduleName substringFromIndex:1];
    }
    return moduleName;
}

- (BOOL)moduleStackUnique:(NSString *)moduleName {
    NSParameterAssert(moduleName);
    NSRange range = [moduleName rangeOfString:@"$"];
    if (range.location == 0 && moduleName.length > 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 工具方法

- (NSArray *)_analyzePath {
    NSMutableArray<NSString *> *pathComp = self.pathComponents.mutableCopy;
    if (pathComp.count > 1) {
        [pathComp removeObjectAtIndex:0];
    }
    return pathComp.copy;
}

- (NSDictionary *)_analyzeQuery {    
    NSArray<NSString *> *subArray = [self.query componentsSeparatedByString:kCheniuAndMark];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionary];
    [subArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<NSString *> *queryKV = [obj componentsSeparatedByString:kCheniuEqualMark];
        if (queryKV.count == 2) {
            
            NSString *key = [queryKV firstObject];
            key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [queryKV lastObject];
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            BOOL isSpecialObj = [self isValidateSpecialObject:key];
            if (!isSpecialObj) {
                [tempDic setObject:value forKey:key];
            } else {
                
                
                NSArray *subKeys = [self _matchString:key toRegexString:@"\\[(.*?)\\]"];
                __block NSString *parentKey = [key substringWithRange:NSMakeRange(0, [key rangeOfString:[subKeys firstObject]].location)];
                
                
                __block id targetObj = tempDic[parentKey];
                __block id parentObj = tempDic;
                
                [subKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *subKeyStr = [[obj stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    
                    if (!subKeyStr.length) {
                        
                        if (!targetObj) {
                            targetObj = [NSMutableArray array];
                            [parentObj setObject:targetObj forKey:parentKey];
                            
                        }
                        [targetObj addObject:value];
                        
                        *stop = YES;
                    } else {
                        
                        if (!targetObj) {
                            targetObj = [NSMutableDictionary dictionary];
                            [parentObj setObject:targetObj forKey:parentKey];
                        }
                        
                        parentObj = targetObj;
                        targetObj = targetObj[subKeyStr];
                        if (idx == subKeys.count - 1) {
                            [parentObj setObject:value forKey:subKeyStr];
                        }
                    }
                    
                    parentKey = subKeyStr;
                }];
            }
        }
    }];
    return tempDic;
}

-(BOOL)isValidateSpecialObject:(NSString *)objectKey
{
    NSString *objectRegex = @"\\w+\\[(.*?)\\]";
    NSPredicate *objectPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",objectRegex];
    return [objectPredicate evaluateWithObject:objectKey];
}

- (NSArray *)_matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSString *component = [string substringWithRange:[match range]];
        [array addObject:component];
    }
    
    return array;
}
@end
