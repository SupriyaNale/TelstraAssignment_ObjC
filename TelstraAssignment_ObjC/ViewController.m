//
//  ViewController.m
//  TelstraAssignment_ObjC
//
//  Created by Yash on 16/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"
#import "Reachability.h"

#import <SystemConfiguration/SystemConfiguration.h>

#import "UIAlertController+show.h"
@interface ViewController ()
{
    Reachability *internetReachableFoo;
}
@end

@implementation ViewController

#pragma Mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Title";//Constants.Messages.title
    
//    () = DataManager.sharedInstance.fetchedData.count > 0 ? () : fetch()
    [self fetch];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
//    self.cache = NSCache()
//    session = URLSession.shared
//    task = URLSessionDownloadTask()
    
    [self drawTable];
//    pullToRefresh()

}

-(void)viewDidLayoutSubviews {
    [self drawTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self designWithIndex:indexPath cell:cell];
    
    return cell;
}

#pragma Mark - UITableViewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma Mark - UI Related Methods
-(void)drawTable {
    //Table View
    
    self.tableView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[CustomeTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - design

-(void)designWithIndex:(NSIndexPath *)indexPath  cell:(CustomeTableViewCell *)cell {
    [cell.titleLabel setText:@"Title"];
    [cell.descLabel setText:@"Description"];
    [cell.imageview setImage:[UIImage imageNamed:@"placeholder"]];
}

#pragma Mark - Get Data
-(void)fetch {
    self.loadingView.frame = CGRectMake(self.view.frame.size.width/2 - 30, self.view.frame.size.height/2 - 60, 100, 100);
    self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.loadingView startAnimating];
    [self.tableView addSubview:self.loadingView];
    
    if([self connected]) {
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:baseURL]];
        
        //create the Method "GET"
        [urlRequest setHTTPMethod:@"GET"];
        [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200)
            {
                NSString* newStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
//                NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
                NSData *finalData = [newStr dataUsingEncoding:NSUTF8StringEncoding];

                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:finalData options:0 error:&parseError];
                NSLog(@"The response is - %@",responseDictionary);
                // its array of dictionary
            }
            else
            {
                NSLog(@"Error");     
            }
        }];
        [dataTask resume];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
            [UIAlertController showAlertMessage:networkError];
        });
    }
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
@end
