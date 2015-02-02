//
//  ViewController123.m
//  JsonExample
//
//  Created by Sesha Sai Bhargav Bandla on 1/30/15.
//  Copyright (c) 2015 Sesha Sai Bhargav Bandla. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "ViewController123.h"
#import "EmployeeListViewController.h"
@interface ViewController123 ()

@end

@implementation ViewController123
@synthesize empId,txtFistName,txtDesignation,txtPhoneno,txtSalary;
UIAlertView *alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
     alert=[[UIAlertView alloc]initWithTitle:@"Message from Server" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  
    dispatch_async(kBgQueue, ^{
        NSString *str=[NSString stringWithFormat:@"http://joomerang.geniusport.com/geniusport/api.php?json=[{\"method_identifier\":\"getEmployeeInfo\",\"params\":{\"empid\":\"%@\"}}]",empId];
        str =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:str];
        NSURLRequest *req=[NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responsedata=[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        [self performSelectorOnMainThread:@selector(fillData:) withObject:responsedata waitUntilDone:YES];
    });
	// Do any additional setup after loading the view.
}
-(void)fillData:(NSData *)responsedata
{
    NSError *error;
    NSDictionary *dic=[[NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error] objectForKey:@"response"];
    txtFistName.text=[dic objectForKey:@"fullName"];
    txtDesignation.text=[dic objectForKey:@"designation"];
    txtSalary.text=[dic objectForKey:@"salary"];
    txtPhoneno.text=[dic objectForKey:@"phoneNo"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onDeleteEmp:(id)sender {
    dispatch_async(kBgQueue, ^{

    NSString *str=[NSString stringWithFormat:@"http://joomerang.geniusport.com/geniusport/api.php?json=[{\"method_identifier\":\"deleteEmployee\",\"params\":{\"empid\":\"%@\"}}]",empId];
    str =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *responsedata=[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        [self performSelectorOnMainThread:@selector(showMessageToUser:) withObject:responsedata waitUntilDone:YES];

    });
   
}
-(void)showMessageToUser:(NSData *)responsedata
{
    NSError *error;
    [EmployeeListViewController setserverContentChanged:YES];
    NSDictionary *dic=[[NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error] objectForKey:@"response"];
    NSString *msg=[dic  objectForKey:@"msg"];
    alert.message=msg;
    [alert show];
}
- (IBAction)onUpdateEmp:(id)sender {
    dispatch_async(kBgQueue, ^{

    NSString *str=[NSString stringWithFormat:@"http://joomerang.geniusport.com/geniusport/api.php?json=[{\"method_identifier\":\"updateEmpIoyeeInfo\",\"params\":{\"empid\":\"%@\",\"fullname\":\"%@\",\"desig\":\"%@\",\"salary\":\"%@\",\"phno\":\"%@\"}}]",empId,txtFistName.text,txtDesignation.text,txtSalary.text,txtPhoneno.text];
    str =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *responsedata=[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        [self performSelectorOnMainThread:@selector(showMessageToUser:) withObject:responsedata waitUntilDone:YES];
    });
    
}

@end
