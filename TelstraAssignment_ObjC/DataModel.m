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
    self.title = json[@"titile"];
    
    return self;
}
@end
