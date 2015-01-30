//
//  NewEmpViewController.m
//  JsonExample
//
//  Created by Sesha Sai Bhargav Bandla on 1/30/15.
//  Copyright (c) 2015 Sesha Sai Bhargav Bandla. All rights reserved.
//

#import "NewEmpViewController.h"
#import "Employee.h"
@interface NewEmpViewController ()

@end

@implementation NewEmpViewController
@synthesize txtEmpId,txtFirstNmae,txtDesignation,txtSalary,txtPhoneno;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSubmitDetails:(id)sender {
   
    NSString *str=[NSString stringWithFormat:@"http://joomerang.geniusport.com/geniusport/api.php?json=[{\"method_identifier\":\"createEmployee\",\"params\":{\"empid\":\"%@\",\"fullname\":\"%@\",\"desig\":\"%@\",\"salary\":\"%@\",\"phno\":\"%@\"}}]",txtEmpId.text,txtFirstNmae.text,txtDesignation.text,txtSalary.text,txtPhoneno.text ];
     str =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:str];
    NSError  *error;
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"%@",dic);
 
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
