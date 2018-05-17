//
//  DataModel.m
//  TelstraAssignment_ObjC
//
//  Created by Yash on 16/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

-(id)initWithJson:(NSDictionary *)json {
    if ([json[@"title"] isKindOfClass:[NSString class]])
        self.title = json[@"title"];
    else
        self.title = @"";
    
    if ([json[@"description"] isKindOfClass:[NSString class]])
        self.desc = json[@"description"] ;
    else
        self.desc = @"";
    
    if ([json[@"imageHref"] isKindOfClass:[NSString class]])
        self.imageURL = json[@"imageHref"];
    else
        self.imageURL = @"";
    
    return self;
}
@end
