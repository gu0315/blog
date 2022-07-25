//
//  UIViewController+SCCModulor.m
//  Pods
//
//  Created by 葛亮 on 16/6/2.
//
//

#import "UIViewController+SCCModulor.h"
#import "SCCModulor.h"
#import "SCCModuleURL.h"
#import "UINavigationController+SCCModulor.h"
#import "SCCViewControllerModuleConfig.h"

@implementation UIViewController (SCCModulor)

- (BOOL)scc_presentModule:(NSString *)moduleName animated:(BOOL)animated completion:(void (^)(void))completion params:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback
 {
    BOOL suc = NO;
    UIViewController *moduleVC = [[SCCModulor modulor] moduleName:moduleName openWithParams:params callback:callback];
    if ([moduleVC isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = moduleVC;
        Class naviCls = [self.navigationController class];
        if (naviCls) {
            UINavigationController *navi = [[naviCls alloc] initWithRootViewController:vc];
            if (navi) {
                vc = navi;
            }
        }
        [self presentViewController:vc animated:animated completion:completion];
        suc = YES;
    }
    return suc;
}

- (BOOL)scc_presentModuleUrl:(NSString *)urlString animated:(BOOL)animated completion:(void (^)(void))completion params:(NSDictionary *)params callback:(void (^)(NSDictionary *))callback{
    
    BOOL suc = NO;    
    NSArray<UIViewController *> *moduleVCs = [[SCCModulor modulor] modulesURLString:urlString performWithParams:params callback:callback];
    if (moduleVCs && moduleVCs.count > 0) {
        
        NSMutableArray<UIViewController *> *stachVCs = [[NSMutableArray alloc]init];
        [moduleVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIViewController class]]) {
                [stachVCs addObject:obj];
            }
        }];
        if ([stachVCs.firstObject isKindOfClass:[UINavigationController class]]) {//支持present出UINavigationController，eg：系统短信MFMessageComposeViewController
          [self presentViewController:stachVCs.firstObject animated:animated completion:completion];
          suc = YES;
        } else {
            UINavigationController *nav;
            Class naviCls = [self.navigationController class];
            if (naviCls && stachVCs.count > 0) {
                nav = [[naviCls alloc] init];
                [nav setViewControllers:stachVCs];
                [self presentViewController:nav animated:animated completion:completion];
                suc = YES;
            }
        }
    }
    return suc;
}

- (BOOL)scc_displayModuleUrl:(NSString *)urlString animated:(BOOL)animated params:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    BOOL suc = NO;
    if (![[SCCModulor modulor] isValidModuleUrlString:urlString]) {
        if ([SCCModulor modulor].unrecognizedInterceptor) {
            [[SCCModulor modulor].unrecognizedInterceptor sccInterceptOriginURL:urlString params:params callback:callback];
        }else{
            NSString *default404URL = [SCCViewControllerModuleConfig config].default404ModuleURL;
            if (default404URL.length && ![default404URL isEqualToString:urlString]) {
               [self scc_displayModuleUrl:default404URL animated:animated params:@{@"p":urlString} callback:nil];
            }
        }
    } else {
        SCCModuleURL *url = [[SCCModuleURL alloc] initWithString:urlString];
        if ([url.module_method isEqualToString:@"open.present"] || [url.module_method isEqualToString:@"open.present_callback"] ) {
            suc = [self scc_presentModuleUrl:urlString animated:animated completion:nil params:params callback:callback];
        } else {
            suc = [self.navigationController scc_setModules:urlString animated:animated withParams:params callback:callback];
        }

    }
    return suc;
}

- (BOOL)scc_displayModuleUrl:(NSString *)urlString {
    return [self scc_displayModuleUrl:urlString animated:YES params:nil callback:nil];
}
@end
