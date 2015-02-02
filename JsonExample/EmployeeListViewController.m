//
//  EmployeeListViewController.m
//  JsonExample
//
//  Created by Sesha Sai Bhargav Bandla on 1/30/15.
//  Copyright (c) 2015 Sesha Sai Bhargav Bandla. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "EmployeeListViewController.h"
#import "ViewController123.h"
#import "Employee.h"
@interface EmployeeListViewController ()
@property(nonatomic,strong)NSMutableArray *selectedCellsArray;
@end

@implementation EmployeeListViewController
NSArray *listdata;
NSMutableArray *NamesList;

@synthesize filteredArray,SearchBar;
BOOL servercontentChanged;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSMutableArray *)selectedCellsArray
{
    if(!_selectedCellsArray)
    {
        _selectedCellsArray=[[NSMutableArray alloc]init];
    }
    return _selectedCellsArray;
}
+(BOOL)isserverContentChanged
{
    return servercontentChanged;
}
+(void)setserverContentChanged:(BOOL)flag
{
    servercontentChanged=flag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    servercontentChanged=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self reloadEntireView];
}
-(void)reloadEntireView
{
    
    if(servercontentChanged)
    {
        dispatch_async(kBgQueue, ^{
            NSString *serverUrl=@"http://joomerang.geniusport.com/geniusport/api.php?json=[{\"method_identifier\":\"getAllEmployees\"}]";
            serverUrl=[serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NamesList=[[NSMutableArray alloc]init];
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:serverUrl]];
            NSLog(@"API Called");
            [self performSelectorOnMainThread:@selector(displayListonTable:) withObject:data waitUntilDone:YES];
            //             [self performSelectorInBackground:@selector(displayListonTable:) withObject:data waitUntilDone:YES];
        });
    }
    else
    {
        [self.tableView reloadData];
    }
}
-(void)displayListonTable:(NSData *)data
{
    NSError *error;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    listdata=[dic objectForKey:@"response"];
    for(NSDictionary *loc in listdata)
    {
        [NamesList addObject:[loc objectForKey:@"fullName"]];
    }
    self.filteredArray = [NSMutableArray arrayWithCapacity:[listdata count]];
    [self.tableView reloadData];
    servercontentChanged=NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *currentOBJ;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentOBJ=[filteredArray objectAtIndex:indexPath.row];
        [self.searchDisplayController setActive:NO animated:YES];
    }
    else {
        
currentOBJ=[listdata objectAtIndex:indexPath.row];
    }
    NSString *empid=[currentOBJ objectForKey:@"empId"];
    if(!self.tableView.allowsMultipleSelection)
    {
    ViewController123 *details=[[UIStoryboard storyboardWithName:@"Main"
                                                          bundle:nil]
                                instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    details.empId=empid;
    [self.navigationController pushViewController:details animated:YES];
    }
    else
    {
        [self.selectedCellsArray addObject:empid];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredArray count];
    } else {
        return [NamesList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EmployeeCell";
    UITableViewCell *cell;
    
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDictionary *currentOBJ;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
 currentOBJ=[filteredArray objectAtIndex:indexPath.row];
    } else {
 currentOBJ=[listdata objectAtIndex:indexPath.row];
    }
    cell.textLabel.text=[currentOBJ objectForKey:@"fullName"];
    return cell;
}
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName contains[c] %@",searchText];
  
    filteredArray = [NSMutableArray arrayWithArray:[[listdata copy] filteredArrayUsingPredicate:predicate]];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
- (IBAction)onClickBarButton:(UIBarButtonItem *)sender {
    if([sender.title isEqualToString:@"Edit"])
    {
        [self.tableView setAllowsMultipleSelection:YES];
        sender.title=@"Delete";
        
    }
    else
    {
        for(NSString *empId in self.selectedCellsArray)
        {
            dispatch_async(kBgQueue, ^{
                
                NSString *str=[NSString stringWithFormat:@"http://joomerang.geniusport.com/geniusport/api.php?json=[{\"method_identifier\":\"deleteEmployee\",\"params\":{\"empid\":\"%@\"}}]",empId];
                str =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url=[NSURL URLWithString:str];
                NSURLRequest *req=[NSURLRequest requestWithURL:url];
                NSURLResponse *response;
                NSError *error;
                NSData *responsedata=[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
                [self performSelectorOnMainThread:@selector(showMessageToUserafterDelete:) withObject:responsedata waitUntilDone:YES];
                
            });

        }
        sender.title=@"Edit";
    }
}
-(void)showMessageToUserafterDelete:(NSData *)responseData;
{
    
    
    if(self.selectedCellsArray.count>=1)
    {
        [self.selectedCellsArray removeObjectAtIndex:0];
        if(self.selectedCellsArray.count==0)
        {
            servercontentChanged=YES;
            [self reloadEntireView];
[self.tableView setAllowsMultipleSelection:NO];
        }
        return;
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
