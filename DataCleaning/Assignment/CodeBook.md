#Code Book

The new dataset (after step 5 of the assignment), contains up to 68 features.

The first one is the activity ID, the second one is the subject ID, then we can find the mean of each of the values of the mean and std deviation of the original features.

## Features
1, subject: ID of the subject performing the experiment (integer [1:30])
2, activity: Label of the activity (character, one of [WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING])

3 to 68:
Average of the original mean and std values for each feature. The new feature name is wrapped bymean() and is composed of several parts:

- It starts withtime" orfrec" depending on the domain of the variable (temporal or frequency)

- It follows withbody" orgravity" depending on the type of acceleration sugnal.

- It containsjerk" if it is related to the value of theJerk" index. 

- It will end inx",y" orz" depending on the axis this feature registers. It containsmag" if it is instead referring to the actual magnitude.

## Feature names
The feature names are:

activity                                          
subject                                           
mean( time.body.accelerometer.mean.x )            
mean( time.body.accelerometer.mean.y )            
mean( time.body.accelerometer.mean.z )            
mean( time.body.accelerometer.std.x )             
mean( time.body.accelerometer.std.y )             
mean( time.body.accelerometer.std.z )             
mean( time.gravity.accelerometer.mean.x )         
mean( time.gravity.accelerometer.mean.y )         
mean( time.gravity.accelerometer.mean.z )         
mean( time.gravity.accelerometer.std.x )          
mean( time.gravity.accelerometer.std.y )          
mean( time.gravity.accelerometer.std.z )          
mean( time.body.accelerometer.jerk.mean.x )       
mean( time.body.accelerometer.jerk.mean.y )       
mean( time.body.accelerometer.jerk.mean.z )       
mean( time.body.accelerometer.jerk.std.x )        
mean( time.body.accelerometer.jerk.std.y )        
mean( time.body.accelerometer.jerk.std.z )        
mean( time.body.gyroscope.mean.x )                
mean( time.body.gyroscope.mean.y )                
mean( time.body.gyroscope.mean.z )                
mean( time.body.gyroscope.std.x )                 
mean( time.body.gyroscope.std.y )                 
mean( time.body.gyroscope.std.z )                 
mean( time.body.gyroscope.jerk.mean.x )           
mean( time.body.gyroscope.jerk.mean.y )           
mean( time.body.gyroscope.jerk.mean.z )           
mean( time.body.gyroscope.jerk.std.x )            
mean( time.body.gyroscope.jerk.std.y )            
mean( time.body.gyroscope.jerk.std.z )            
mean( time.body.accelerometer.mag.mean )          
mean( time.body.accelerometer.mag.std )           
mean( time.gravity.accelerometer.mag.mean )       
mean( time.gravity.accelerometer.mag.std )        
mean( time.body.accelerometer.jerk.mag.mean )     
mean( time.body.accelerometer.jerk.mag.std )      
mean( time.body.gyroscope.mag.mean )              
mean( time.body.gyroscope.mag.std )               
mean( time.body.gyroscope.jerk.mag.mean )         
mean( time.body.gyroscope.jerk.mag.std )          
mean( frec.body.accelerometer.mean.x )            
mean( frec.body.accelerometer.mean.y )            
mean( frec.body.accelerometer.mean.z )            
mean( frec.body.accelerometer.std.x )             
mean( frec.body.accelerometer.std.y )             
mean( frec.body.accelerometer.std.z )             
mean( frec.body.accelerometer.jerk.mean.x )       
mean( frec.body.accelerometer.jerk.mean.y )       
mean( frec.body.accelerometer.jerk.mean.z )       
mean( frec.body.accelerometer.jerk.std.x )        
mean( frec.body.accelerometer.jerk.std.y )        
mean( frec.body.accelerometer.jerk.std.z )        
mean( frec.body.gyroscope.mean.x )                
mean( frec.body.gyroscope.mean.y )                
mean( frec.body.gyroscope.mean.z )                
mean( frec.body.gyroscope.std.x )                 
mean( frec.body.gyroscope.std.y )                 
mean( frec.body.gyroscope.std.z )                 
mean( frec.body.accelerometer.mag.mean )          
mean( frec.body.accelerometer.mag.std )           
mean( frec.body.body.accelerometer.jerk.mag.mean )
mean( frec.body.body.accelerometer.jerk.mag.std )
mean( frec.body.body.gyroscope.mag.mean )         
mean( frec.body.body.gyroscope.mag.std )          
mean( frec.body.body.gyroscope.jerk.mag.mean )    
mean( frec.body.body.gyroscope.jerk.mag.std )
