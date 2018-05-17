//
//  ResponseParser.m
//  TelstraAssignment_ObjC
//
//  Created by Yash on 17/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import "ResponseParser.h"
#import "DataModel.h"

@implementation ResponseParser

#pragma Mark - Parser Methods
/*
class func imagesFromJSON(_ json: [[String: AnyObject]]) -> [DataModel] {
    var images = [DataModel]()
    for image in json {
        do {
            images.append(try DataModel(json: image))
        }
        catch DataModelError.dataIDEmpty {
            print("imageIDEmpty")
        }
        catch {}
    }
    return images
}
*/

+(NSMutableArray *)imageDataFromJson:(NSMutableArray *)json {
    NSMutableArray *datamodels = [[NSMutableArray alloc] init];
    for (NSDictionary *data in json) {
        DataModel *model = [[DataModel alloc] initWithJson:data];
        [datamodels addObject:model];
    }
    return datamodels;
}

@end
