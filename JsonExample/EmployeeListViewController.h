//
//  EmployeeListViewController.h
//  JsonExample
//
//  Created by Sesha Sai Bhargav Bandla on 1/30/15.
//  Copyright (c) 2015 Sesha Sai Bhargav Bandla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeListViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>
@property (strong,nonatomic) NSMutableArray *filteredArray;
@property IBOutlet UISearchBar *SearchBar;
+(BOOL)isserverContentChanged;
+(void)setserverContentChanged:(BOOL)flag;
@end
