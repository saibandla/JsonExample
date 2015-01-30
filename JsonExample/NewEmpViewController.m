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
UIAlertView *alert;
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
    alert=[[UIAlertView alloc]initWithTitle:@"Message from Server" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	// Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UIView *v in self.view.subviews)
    {
        if([v isKindOfClass:[UITextField class]])
        {
            [v resignFirstResponder];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSubmitDetails:(id)sender {
   
    // ---------------------- Regualr way-------------------------------------
    if(![txtEmpId.text isEqualToString:@""]&&![txtFirstNmae.text isEqualToString:@""]&&![txtDesignation.text isEqualToString:@""]&&![txtSalary.text isEqualToString:@""]&&![txtPhoneno.text isEqualToString:@""])
    {
    NSString *str=[NSString stringWithFormat:@"http://joomerang.geniusport.com/geniusport/api.php?json=[{\"method_identifier\":\"createEmployee\",\"params\":{\"empid\":\"%@\",\"fullname\":\"%@\",\"desig\":\"%@\",\"salary\":\"%@\",\"phno\":\"%@\"}}]",txtEmpId.text,txtFirstNmae.text,txtDesignation.text,txtSalary.text,txtPhoneno.text ];
     str =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:str];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *responsedata=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    NSString *msg=[[dic objectForKey:@"response"] objectForKey:@"msg"];
    alert.message=msg;
    [alert show];
    }
    else
    {
        alert.message=@"Please enter all values";
        [alert show];
    }
    
// ---------------------- Alternative way-------------------------------------
//    NSError  *error;
//    NSData *data=[NSData dataWithContentsOfURL:url];
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"%@",dic);
 
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
