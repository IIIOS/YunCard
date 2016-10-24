//
//  UIColor+Addition.m
//  cheguanjia
//
//  Created by gaojing on 12-11-28.
//  Copyright (c) 2012年 jizhiyou. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+ (UIColor *)colorWithHexRGB:(NSString *)hex{
    if(hex.length == 0) return [UIColor redColor];
    if([[hex substringToIndex:1] isEqualToString:@"#"]){
        hex = [hex substringFromIndex:1];
    }
    if(hex.length != 6) return [UIColor redColor];
    int i = 0;
    NSString *rstr = [hex substringWithRange:NSMakeRange(i, 2)]; i+=2;
    NSString *gstr = [hex substringWithRange:NSMakeRange(i, 2)]; i+=2;
    NSString *bstr = [hex substringWithRange:NSMakeRange(i, 2)]; i+=2;
    
    
    NSScanner *scanner;
    
    unsigned int red;
    scanner = [NSScanner scannerWithString:rstr];
    if(![scanner scanHexInt:&red]){
        return [UIColor redColor];
    }
    
    unsigned int green;
    scanner = [NSScanner scannerWithString:gstr];
    if(![scanner scanHexInt:&green]){
        return [UIColor redColor];
    }
    
    unsigned int blue;
    scanner = [NSScanner scannerWithString:bstr];
    if(![scanner scanHexInt:&blue]){
        return [UIColor redColor];
    }
    
    
    
    
//    NSScanner *scanner = [NSScanner scannerWithString:rstr];
//    if([scanner scanHexInt:&result]){
//        NSLog(@"%u", result);
//    }
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
    
}
@end
