# Law Firm Social Media Use In Orange County, CA
##### *A Quantitative Analysis*

### INTRODUCTION

I've spent a lot of time in digital marketing (I've worked as a Data Scientist for a marketing consulting firm and am married to a [fashion blogger/social media influencer](http://www.instagram.com/dressmeblonde)).  So naturally, once I began spending time around lawyers and law firms I couldn't help but notice how many lawyers seemed to be behind the rest of the world when it came to social media use. 

I wanted to understand how attorneys were using social media and if it was effective from a marketing perspective. So, in spring of 2016, I undertook a quantitative study of the social media use of law firms and lawyers in Orange County, CA. I analyzed the websites of 1,400+ firms in Orange County and surveyed 400+ attorneys about their attitudes towards and adoption of social media. 

### METHODS

*Background Research / Literature Review*

I found surprisingly little research into how law firms were using social media. The best source of data was from the American Bar Association's ("ABA") Annual [Legal Technology Report](http://www.americanbar.org/publications/techreport/2015/SocialMedia.html).  However, the ABA Report fell short of answering the questions I was interested in a number of key ways:

1. it relied on self-reported data, but I was interested in what law firms were actually doing, not what they were reporting;
2. it was unclear from if there were any meaningful correlations between platform use, practice area, etc;
3. there was no indication of whether or not social media use was actually effective for these law firms from a marketing perspective (effective meaning contributing to their bottom line somehow); and
4. the report analyzed trends on a national level, but failed to look at a specific geographic location.

*Study Scope*

I chose to study law firms in Orange County, CA for a number of key reasons:
1. I was attending law school at UC Irvine School of Law;
2. the Orange County legal community is one of the larger legal commiunities in the US, which means that it spans all practice areas and firm sizes; and
3. focusing on one county meant I could analyze an entire bounded population instead of relying on sampling.

I used two general methods to determine social media use among private law firms in Orange County, CA. In the first method, I used the homepage from firm websites to determine the number of social media accounts per firm and to classify each firm by practice area. In the second method, I sent a survey on firm social media use to private law firm attorneys in Orange County, CA. 

I performed all data collection and analyses in R. I identified private practice law firms and attorneys in Orange, County CA from attorney email addresses on an Orange County Bar Association (“OCBA”) member list. This list was obtained from the OCBA website member portal in August 2015 and contained email addresses for 5,445 individual attorneys.

*First Method – Website Analysis*

For this first method, I discarded personal identifying information except for the domain name of the email address. Since I was only interested in private practice attorneys, I used a text-classifier to programmatically exclude non-private practice attorneys from my analysis (e.g. in-house counsel, government attorneys, etc.). Additionally, I did not include entries without an email address or with an email addresses with non-legal specific domains (e.g. gmail.com, yahoo.com, etc.). The resulting list contained 3,675 attorney email addresses from 1,429 unique firms. I obtained firm website addresses from the domain name of the remaining email addresses. 

I classified each firm by number of attorneys on the list: “Solo” (one attorney), “Small” (2-10 attorneys), “Mid-Sized” (11-99 attorneys), and “Top 400” (100+ attorneys). I cross referenced firm names by the 2015 Law360 400 Largest US Law Firms list (“Law360 Top 400”). Firms that had less than 100 attorneys in Orange County, CA, but were on the Law360 Top 400 list were classified as Top 400. Data on small and midsized firms that may have satellite offices outside of Orange County was not readily available. As a result, there may be some inaccuracies in the classification of these groups. 

*Data Collection*

I scraped HTML from each firm or solo practitioner website homepage using the rvest package in R. I did not scrape the entire website for each firm or solo practitioner in order to simplify the computational load and resulting analysis. I analyzed all linked URLS on each home page with a simple script to determine if the firm or solo practitioner homepage had linked to a social media profile, which I recorded as a binary TRUE/FALSE response. For purposes of this analysis, I only considered four top social media networks: Facebook, LinkedIn, Twitter, and Instagram.  I relied on the assumption that if a firm or solo practitioners has and uses a social media account, it will link to that account on the homepage of its website. This may not hold true in all cases, and as a result my approach may have omitted some firms or solo practitioners that had social media accounts, but did not link to them on their respective websites. 

I used a simple keyword classifier to categorize each law firm or solo practitioner homepage by practice areas. I adapted a list of [OCBA Sections and Committees](http://www.ocbar.org/SectionsCommittees/Sections.aspx) from the OCBA website, and identified keywords relating to each practice area to develop a list of practice areas.  I used a keyword classifier to on the HTML of each homepage and recorded the response as a binary TRUE/FALSE. Many firms were categorized as having more than one practice area. 

*Second Method – Survey Analysis*

For the second survey method, I emailed each attorney on the OCBA list with a link to the survey and a description of the purpose of the survey. The survey was created and distributed using Google Forms.  I received 476 responses to my survey, or a response rate of 8.7%, without invalid email addresses removed. (This response rate would be significantly higher if I had first removed invalid email addresses).

*Data Analysis*

I performed all data analysis in R. For the website data, I initially used variable selection techniques to explore the most important variables in determining social media account. I used the both Random Forest implementation in the randomForest package and the regsubsets function from the leaps package to determine general variable importance, to check data integrity, and to validate later analysis results. 

I used Classification And Regression Trees (CART) from the rpart package and the rpart.plot package[13] to draw classification trees. I used Adobe Illustrator CCto format the figures. For the survey data, I used R as well as Microsoft Excel to analyze the data. 

### RESULTS

In the interest of not making this post any longer, I'll only highlight a few figures here, but you can download all of the figures [here](http://beauwalker.com/wp-content/uploads/2017/02/Figures.pdf) and see a video of a presentation I gave reporting my results with a discussion [here](http://www.beauwalker.com/video). 

#####Figure 1
![Figure 1](http://beauwalker.com/wp-content/uploads/2017/02/Figure1.png)

#####Figure 4
![Figure 4](http://beauwalker.com/wp-content/uploads/2017/02/Figure4.png)

#####Figure 6
![Figure 6](http://beauwalker.com/wp-content/uploads/2017/02/Figure6.png)

### REFERENCES AND RESOURCES

I've saved relevent code on [GitHub](http://www.github.com/incredibeau). 

### FUTURE RELATED PROJECTS

I'm currently in the middle of another study on lawyer use of Instagram and am also developing a ML classifier to identify attorney instagram accounts. Message me for more info. 
