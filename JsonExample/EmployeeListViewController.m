//
//  EmployeeListViewController.m
//  JsonExample
//
//  Created by Sesha Sai Bhargav Bandla on 1/30/15.
//  Copyright (c) 2015 Sesha Sai Bhargav Bandla. All rights reserved.
//

#import "EmployeeListViewController.h"
#import "ViewController123.h"
#import "Employee.h"
@interface EmployeeListViewController ()

@end

@implementation EmployeeListViewController
NSArray *listdata;
NSMutableArray *NamesList;
@synthesize filteredArray,SearchBar;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *serverUrl=@"http://joomerang.geniusport.com/geniusport/api.php?json=[{\"method_identifier\":\"getAllEmployees\"}]";
    serverUrl=[serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NamesList=[[NSMutableArray alloc]init];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:serverUrl]];
    NSError *error;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    listdata=[dic objectForKey:@"response"];
    for(NSDictionary *loc in listdata)
    {
        [NamesList addObject:[loc objectForKey:@"fullName"]];
    }
    self.filteredArray = [NSMutableArray arrayWithCapacity:[listdata count]];
    [self.tableView reloadData];
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
    ViewController123 *details=[[UIStoryboard storyboardWithName:@"Main"
                                                          bundle:nil]
                                instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    details.empId=empid;
    [self.navigationController pushViewController:details animated:YES];

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
