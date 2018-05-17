//
//  DataModel.h
//  TelstraAssignment_ObjC
//
//  Created by Yash on 16/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *desc;
@property(strong, nonatomic) NSString *imageURL;

-(id)initWithJson:(NSDictionary *)json;

@end
