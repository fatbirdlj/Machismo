//
//  main.m
//  Test
//
//  Created by 刘江 on 2017/3/21.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _Status {
    Active = 0,
    Inactive
} Status;


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(Status.Active);
    }
    return 0;
}

