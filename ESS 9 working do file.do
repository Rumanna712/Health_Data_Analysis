//Date created:14/12/2022
//Name: Rumanna Rahman
//Datase: ESS round 9, 2018

// Review dataset
describe
// Original dataset contains 49,519 obsevations and 572 variables. 

//Reveiew internet use, how often
tab netusoft 
tab netusoft, m 
tab netusoft, sort 
graph bar, over(netusoft)
codebook netusoft 

// Recoding netusoft
recode netusoft (1=1 "Never") (2=2 "Only occasionally") (3=3 "A few times a week") (4=4 "Most days") (5=5 "Every day") (.a=.) (.b=.) (.c=.), gen(netusoftNEW)  

//Review new variable netusoftNEW
tab netusoftNEW
codebook netusoftNEW
graph bar, over(netusoftNEW) 
graph bar, over(netusoftNEW) by(gndr) 

// Review Internet use, how much time on typical day, in minutes
tab netustm, m
histogram netustm, freq norm d 
sum netustm
codebook netustm 

//Recoding netustm 
recode netustm (.a=.) (.b=.) (.c=.) (.d=.), gen(netustmNEW)   

// Review new variable netustmNEW 
tab netustmNEW
tab netustmNEW, m 
codebook netustmNEW

// Creating a summary index of the variables netusoftNEW & netustmNEW  
gen index = (netusoftNEW+netustmNEW)
gen internetuse=index 
label variable internetuse "Internet use" 

// Review new variable internetuse
tab internetuse, m
codebook internetuse
histogram internetuse, freq norm d  
tabstat internetuse, stat(count mean median sd min max) 
/* This is a continuous variable with positively skewed distribution. The mean is 206.37, median is 155, sd is 170.86, minimum value is 4 and maximum value is 1445. */ 

// Review Subjective general health
tab health
codebook health
graph bar, over(health) by(gndr)
recode health (1/2=0 "Good") (3/5=1 "Less than good") (.a=.) (.b=.) (.c=.), gen(healthNEW) 

// Review new created variable healthNEW
tab healthNEW
codebook healthNEW 
graph bar, over(healthNEW)
graph bar, over(healthNEW) by(gndr)
// Review Gender
tab gndr, m
codebook gndr 
sum gndr 
graph bar, over(gndr) 
// Male=1 and female=2, 46.49% male and 53.51% female 

// Review age of respondents
tab agea, m 
sum agea
codebook agea 
histogram agea, freq norm d  
tabstat agea, stat(count mean median sd min max) 
// Continuous variable with approximately normal distribution 
// Recoding agea 
recode agea (.a=.), gen(age)
tab age, m 
codebook age 
histogram age, freq norm d  
tabstat age, stat(count mean median sd min max)

// Another recoding of agea
recode agea (15/50=0 "50 or younger") (51/90=1 "Older than 50") (.a=.), gen(age_cat) 
tab age_cat, m 
codebook age_cat 

// Review area of residence
tab domicil
codebook domicil 
graph bar, over(domicil) 
// Recoding domicil 
recode domicil (1/3=0 "Urban") (4/5=1 "Rural") (.a=.) (.b=.) (.c=.), gen(domicilNEW) 

// Review new variable domicilNEW 
tab domicilNEW
codebook domicilNEW 
graph bar, over(domicilNEW) 

// Summarize X, Y and potential Z variables
sum healthNEW internetuse gndr age domicilNEW
sum healthNEW internetuse gndr age_cat domicilNEW

// Creating pop variables 

gen pop_9=1 if healthNEW!=. & internetuse!=. & age_cat!=. & domicilNEW!=. & gndr!=.   
tab pop_9 
/** There are 34,232 individuals included in our analytical sample **/

// Simple logistic regression 
 
sum healthNEW internetuse if pop_9==1 
logistic healthNEW internetuse if pop_9==1  

/*** From the result, we can see there is a negative association, odds ratio (OR) is 0.99. Thus, with a unit increase in internet use there is lower odds of reporting 'less than good' health. 
There is a statistically significant association between healthNEW and internetuse, as reflected in p-value (0.000) and 95% confidence interval (0.99 to 0.99).
***/
sum healthNEW gndr if pop_9==1 
logistic healthNEW i.gndr if pop_9==1 

/*** From the result, female respondents have higher odds (OR=1.16) of reporting 'less than good' health compared to man. 
This is a statistically significant association healthNEW and gndr, as reflected in p-value (0.000) and 95% confidence interval (1.10 to 1.21).
***/
sum healthNEW age_cat if pop_9==1 
logistic healthNEW i.age_cat if pop_9==1 

/*** The variable age_cat has two categories: 0=50 or younger, 1= Older than 50. Here, the first category (50 or younger) is reference category. 
From the results, respondents older than 50 reports 2.77 times higher odds (OR=2.77) of "less than good" health compared to respondents who are 50 or younger. Association is statistically significant as p value is 0.000 and 95% confidence interval (2.63 to 2.91) ***/ 

sum healthNEW domicilNEW if pop_9==1 
logistic healthNEW i.domicilNEW if pop_9==1  

/** OR= 0.97 means that there is almost no association between respondent's area of residence and self reported less than good health. Association is not statistically significant as p= 0.263 which is more than 0.05 and 95% confidence interval (0.92 to 1.02) ***/ 

// Multiple logistic regression 

sum healthNEW internetuse gndr age_cat domicilNEW if pop_9==1 
logistic healthNEW internetuse i.gndr i.age_cat i.domicilNEW if pop_9==1  

 






// Extra 
gen pop_9b=1 if healthNEW!=. & netustmNEW!=. & age_cat!=. & domicilNEW!=. & gndr!=.
tab pop_9b

sum healthNEW netustmNEW if pop_9b==1 
logistic healthNEW netustmNEW if pop_9b==1  

sum healthNEW netustmNEW gndr age_cat domicilNEW if pop_9b==1 
logistic healthNEW netustmNEW i.gndr i.age_cat i.domicilNEW if pop_9b==1


// Extra-2
gen pop_9c=1 if healthNEW!=. & netustmNEW!=. & age!=. & domicilNEW!=. & gndr!=.
tab pop_9c

logistic healthNEW netustmNEW if pop_9c==1  

sum healthNEW netustmNEW gndr age domicilNEW if pop_9c==1 
logistic healthNEW netustmNEW i.gndr age i.domicilNEW if pop_9c==1



// Extra-3
gen pop_9d=1 if healthNEW!=. & netustmNEW!=. & age!=. & domicilNEW!=. & gndr!=. & cntry!=.
tab pop_9d

logistic healthNEW netustmNEW if pop_9d==1  

sum healthNEW netustmNEW gndr age domicilNEW cntry if pop_9d==1 
logistic healthNEW netustmNEW i.gndr age i.domicilNEW cntry if pop_9d==1

tab cntry
codebook cntry

// Review sclmeet
tab sclmeet
codebook sclmeet
recode sclmeet (1=1 "Never") (2=2 "Less than once a month") (3=3 "Once a month") (4=4 "Several times a month") (5=5 "Once a week") (6=6 "Several times a week") (.a=.) (.b=.) (.c=.), gen(netusoftNEW)

// Extra 4 The Analysis Included in the study
tab netusoftNEW 
codebook netusoftNEW 
gen pop_9F=1 if healthNEW!=. & netusoftNEW!=. & age!=. & domicilNEW!=. & gndr!=. 
tab pop_9F

logistic healthNEW ib1.netusoftNEW if pop_9F==1  

sum healthNEW gndr if pop_9F==1 
logistic healthNEW i.gndr if pop_9F==1 

sum healthNEW age if pop_9F==1 
logistic healthNEW age if pop_9F==1 

sum healthNEW domicilNEW if pop_9F==1 
logistic healthNEW i.domicilNEW if pop_9F==1

sum healthNEW netusoftNEW gndr age domicilNEW if pop_9F==1 
logistic healthNEW ib1.netusoftNEW i.gndr age i.domicilNEW if pop_9F==1 

logistic healthNEW ib1.netusoftNEW i.domicilNEW if pop_9F==1 


// Model diagnostics 

quietly logistic healthNEW ib1.netusoftNEW i.gndr age i.domicilNEW if pop_9F==1
linktest 
quietly logistic healthNEW ib1.netusoftNEW i.gndr age i.domicilNEW if pop_9F==1
estat vce,corr 

quietly logistic healthNEW ib1.netusoftNEW i.gndr age i.domicilNEW if pop_9F==1
estat gof

quietly logistic healthNEW ib1.netusoftNEW i.gndr age i.domicilNEW if pop_9F==1
lroc 
// Extra 5
gen pop_9g=1 if healthNEW!=. & netusoftNEW!=. & age_cat!=. & domicilNEW!=. & gndr!=. 
tab pop_9g

logistic healthNEW ib1.netusoftNEW if pop_9g==1  

sum healthNEW netusoftNEW gndr age_cat domicilNEW if pop_9g==1 
logistic healthNEW ib1.netusoftNEW i.gndr i.age_cat i.domicilNEW if pop_9g==1

logistic healthNEW i.age_cat if pop_9g==1 



//Interaction analysis 
logistic healthNEW ib1.netusoftNEW i.gndr if pop_9F==1 

//Save estimates
estimates store model1

// Multiple regression model with interaction effect 
logistic healthNEW ib1.netusoftNEW##i.gndr if pop_9F==1 

//Save estimates 
estimates store model2 

// Compare model fit 
lrtest model1 model2, stats
/*** 
From the table, we can see that the p-value of the likelihood ratio test is 0.001 which is less than 0.05. Therefore this can be suggested that the model2 fits the data better than model1. In other words, we can say that the model that contains interaction term (model2) fits the data better than the model without the interaction term (model1). 
We can therefore conclude that there is statistically significant interaction effect between frequency of internet use and gender on the self-rated less than good health of respondents. So, the association between frequency of internet use and health differ between male and female. 
***/ 

//Illustration

margins ib1.netusoftNEW##i.gndr
quietly margins gndr, at(netusoftNEW=(1 2 3 4 5))
marginsplot 
/*** 
Based on the marginsplot, there is small difference between the man and woman in frequency of internet use and self rated less than good health. Also there is almost no difference in number of reporting among man and woman respondents.    
***/

//Interaction analysis 2 
logistic healthNEW ib1.netusoftNEW age if pop_9F==1 

//Save estimates
estimates store model3

// Multiple regression model with interaction effect 
logistic healthNEW ib1.netusoftNEW##age if pop_9F==1 

//Save estimates 
estimates store model4

// Compare model fit 
lrtest model3 model4, stats

/*** 
From the table, we can see that the p-value of the likelihood ratio test is 0.91 which is more than 0.05. Therefore this can be suggested that the model2 does not fit the data better than model1. In other words, we can say that the model that contains interaction term (model2) does not fit the data better than the model without the interaction term (model1). ***/ 

//Illustration

margins ib1.netusoftNEW##age
margins ib1.netusoftNEW#c.age
quietly margins age, at(netusoftNEW=(1 2 3 4 5))
marginsplot 
// not feasible test because stata says 'only factor variables and their interactions are allowed'



//Interaction analysis 
logistic healthNEW ib1.netusoftNEW i.domicilNEW if pop_9F==1 

//Save estimates
estimates store model5

// Multiple regression model with interaction effect 
logistic healthNEW ib1.netusoftNEW##i.domicilNEW if pop_9F==1 

//Save estimates 
estimates store model6

// Compare model fit 
lrtest model5 model6, stats

/*** p value is 0.08. From the table, we can see that the p-value of the likelihood ratio test is 0.08 which is more than 0.05. Therefore this can be suggested that the model2 does not fit the data better than model1. In other words, we can say that the model that contains interaction term (model2) does not fit the data better than the model without the interaction term (model1). ***/

//Illustration

margins ib1.netusoftNEW##i.domicilNEW
quietly margins domicilNEW, at(netusoftNEW=(1 2 3 4 5))
marginsplot

/***The marginplot shows very slim differences in the slopes of two categories (people living in urban and rural areas) for predicting self-rated health in response to frequency of internet use. Here rural people is slightly below the reference group urban people. As, when never use internet rural people have lower odds of reporting less than good health than urban people. the difference gradually increases upto using internet a few times a week. Then it almost becomes same at the level of using internet on everyday and reporting 'less than good health'  
As the differences are very small, we can conclude that there is almost no differences among the area of residence od respondents in internet use frequency and self rated less than good health. Also there is almost same number of people reported from each categories. ***/





