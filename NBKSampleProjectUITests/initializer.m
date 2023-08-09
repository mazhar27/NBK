//
//  initializer.m
//  NBKSampleProjectUITests
//
//  Created by Mazhar HUSAIN on 09/08/2023.
//

#import <Foundation/Foundation.h>
#import "NBKSampleProjectUITests-Swift.h"

        __attribute__((constructor))
        void CucumberishInit()
        {
            [CucumberishInitializer setupCucumberish];
        }
