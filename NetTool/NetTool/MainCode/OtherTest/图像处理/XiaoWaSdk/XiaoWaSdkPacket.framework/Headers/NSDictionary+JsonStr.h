//
//  NSDictionary+JsonStr.h
//  XG
//
//  Created by chenjoy on 15/9/30.
//  Copyright © 2015年 memobird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonStr)

- (NSString *) jsonstring;
- (NSString *)jsonstringBy:(NSJSONWritingOptions)opt;
- (NSString *) jsonstringForNet;
- (NSString *)jsonstringForServ;

@end
