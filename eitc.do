clear
**** If you need to install coefplot use the code below
* ssc install coefplot, replace
use "C:\Users\Jose\Dropbox\R Markdown\Data Analytics III\eitc.dta", clear

summarize if children==0
summarize if children == 1
summarize if children >=1
summarize if children >=1 & year == 1994

gen cearn = earn if work == 1

gen anykids = (children >= 1)
gen post93 = (year >= 1994)

preserve
collapse work, by(year anykids)

gen work0 = work if anykids==0
label var work0 "Single women, no children"
gen work1 = work if anykids==1
label var work1 "Single women, children"

sort year
twoway (line work0 year) (line work1 year), ytitle(Labor Force Participation Rates)
restore

* Run a simple D-I-D Regression

gen interaction = post93*anykids
reg work post93 anykids interaction

* Include Relevant Demographics in Regression

gen age2 = age^2          /*Create age-squared variable*/
gen nonlaborinc = finc - earn     /*Non-labor income*/

reg work post93 anykids interaction nonwhite age age2 ed finc nonlaborinc


* Create some new variables

gen interu = urate*anykids

gen onekid = (children==1) 
gen twokid = (children>=2)
gen postXone = post93*onekid
gen postXtwo = post93*twokid

* Estimate a Placebo Model

gen placebo = (year >= 1992)
gen placeboXany = anykids*placebo

reg work anykids placebo placeboXany if year<1994

local coefinter 1.anykids#1996.year 1.anykids#1995.year 1.anykids#1994.year 1.anykids#1993.year 1.anykids#1992.year

* Simple D-I-D Regression for Coefplot

reg work anykids##year
coefplot, keep(`coefinter') coeflabel(1.anykids#1996.year="1996" 1.anykids#1995.year="1995" 1.anykids#1994.year="1994" 1.anykids#1993.year="1993" 1.anykids#1992.year="1992") yline(0) vertical

* D-I-D Regression with Controls for Coefplot

reg work anykids##year nonwhite age age2 ed finc nonlaborinc
coefplot, keep(`coefinter') coeflabel(1.anykids#1996.year="1996" 1.anykids#1995.year="1995" 1.anykids#1994.year="1994" 1.anykids#1993.year="1993" 1.anykids#1992.year="1992") yline(0) vertical
