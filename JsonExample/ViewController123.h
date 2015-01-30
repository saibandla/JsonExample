//
//  ViewController123.h
//  JsonExample
//
//  Created by Sesha Sai Bhargav Bandla on 1/30/15.
//  Copyright (c) 2015 Sesha Sai Bhargav Bandla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@interface ViewController123 : UIViewController
@property(nonatomic,strong)IBOutlet UITextField *txtEmpId;
@property (weak, nonatomic) IBOutlet UITextField *txtFistName;
@property (weak, nonatomic) IBOutlet UITextField *txtDesignation;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneno;

@property (weak, nonatomic) IBOutlet UITextField *txtSalary;
@property(nonatomic,strong) Employee *emp;
@end
