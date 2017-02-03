
#download survey data
survey = read.csv("survey.csv", header = T)


library(rpart)
library(rpart.plot)

# inspect data fram
str(survey)

#subset data frames
solo = survey[which(survey$size == "Solo"),]
small = survey[which(survey$size == "Small"),]
mid = survey[which(survey$size == "Mid"),]
large = survey[which(survey$size == "Large"),]

survey = rbind(solo,small,mid,top400)

str(survey)

### create tree for predictors of ALL

p.f = sum(survey$Facebook == TRUE) / nrow(survey)
p.l = sum(survey$LinkedIn == TRUE) / nrow(survey)
p.t = sum(survey$Twitter == TRUE) / nrow(survey)
p.i = sum(survey$Instagram == TRUE) / nrow(survey)

o.f = p.f/(1-p.f)
o.l = p.l/(1-p.l)
o.t = p.t/(1-p.t)
o.i = p.i/(1-p.i)

o.l/o.f #= 1.6 times more likely to use linkedin vs. facebook
o.l/o.t #= 3.8 times more likely to use linkedin vs. twitter
o.f/o.t #= 2.4 times more likely to use facebook than twitter
o.f/o.i # = 21.0 times more likely to use facebook vs. instagram

o.l/o.t #= 3.9 times more likely to use linkedin vs twitter
o.l/o.i #=34.2 times more likely

colnames(survey)

tree1 = rpart(use_SM ~ size+bus_lit+work_comp+trust+tort+tax+social+real_estate+labor+international+ip+insurance+immigration+health+family+environment+entertainment+elder+construct+conservator+commercial+business+bankruptcy+banking+appellate+ADR, data = survey, method = "class")
prp(tree1, type = 3, extra = 109, main = "Use SM", under = T, fallen.leaves= T, digits = 4)



###### solo

str(solo)

p.f = sum(solo$Facebook == TRUE) / nrow(solo)
p.l = sum(solo$LinkedIn == TRUE) / nrow(solo)
p.t = sum(solo$Twitter == TRUE) / nrow(solo)
p.i = sum(solo$Instagram == TRUE) / nrow(solo)

o.f = p.f/(1-p.f)
o.l = p.l/(1-p.l)
o.t = p.t/(1-p.t)
o.i = p.i/(1-p.i)

o.l/o.f #= 1.2 times more likely to use linkedin vs. facebook
o.l/o.t #= 2.7 times more likely to linkedin vs. twitter
o.f / o.t #= 2.2 times more likely to use facebook vs. twitter
o.f / o.i #= 9 times more likely to use facebook than instagram


table(solo$use_SM)

60 / (60+52) # 53.6% don't use social media

solotree1 = rpart(use_SM ~ bus_lit+work_comp+trust+tort+tax+social+real_estate+labor+international+ip+insurance+immigration+health+family+environment+entertainment+elder+construct+conservator+commercial+business+bankruptcy+banking+appellate+ADR, data = solo, method = "class")
solotree1 = prune(solotree1, solotree1$cptable[which.min(solotree1$cptable[,"xerror"]),"CP"])
prp(solotree1, type = 3, extra = 109, main = "Solo: Use SM", under = T, fallen.leaves= T, digits = 4)

# do co-occurance of practice types for solo

library(cooccur)

s_keep = c("bus_lit", "work_comp", "trust", "tort", "tax", "social", "real_estate", "labor", "international", "ip", "insurance", "immigration", "health", "family", "environment", "entertainment", "elder", "construct", "conservator", "commercial", "business", "bankruptcy", "banking", "appellate", "ADR")

test = solo[s_keep]
dat <- as.data.frame(sapply(test, as.numeric))
co_solo = t(dat)

cooccur.solo <- cooccur(mat=co_solo, type="spp_site", thresh=TRUE,spp_names=TRUE)
plot(cooccur.solo)

### mid

p.f = sum(small$Facebook == TRUE) / nrow(small)
p.l = sum(small$LinkedIn == TRUE) / nrow(small)
p.t = sum(small$Twitter == TRUE) / nrow(small)
p.i = sum(small$Instagram == TRUE) / nrow(small)

o.f = p.f/(1-p.f)
o.l = p.l/(1-p.l)
o.t = p.t/(1-p.t)
o.i = p.i/(1-p.i)

o.l/o.f #= 1.3 times more likely to use linkedin vs. facebook
o.l/o.t #= 4.4 times more likely to linkedin vs. twitter
o.f / o.t #= 3.3 times more likely to use facebook vs. twitter
o.f / o.i #= 20 times more likely to use facebook than instagram


table(small$use_SM)

71 / (71+98) # 42% don't use social media

smalltree1 = rpart(use_SM ~ bus_lit+work_comp+trust+tort+tax+social+real_estate+labor+international+ip+insurance+immigration+health+family+environment+entertainment+elder+construct+conservator+commercial+business+bankruptcy+banking+appellate+ADR, data = small, method = "class")
#smalltree1 = prune(smalltree1, smalltree1$cptable[which.min(smalltree1$cptable[,"xerror"]),"CP"])
prp(smalltree1, type = 3, extra = 109, main = "Small: Use SM", under = T, fallen.leaves= T, digits = 4)

test = small[s_keep]
dat <- as.data.frame(sapply(test, as.numeric))
co_small = t(dat)

cooccur.small <- cooccur(mat=co_small, type="spp_site", thresh=TRUE,spp_names=TRUE)
plot(cooccur.small)

### mid

p.f = sum(mid$Facebook == TRUE) / nrow(mid)
p.l = sum(mid$LinkedIn == TRUE) / nrow(mid)
p.t = sum(mid$Twitter == TRUE) / nrow(mid)
p.i = sum(mid$Instagram == TRUE) / nrow(mid)

o.f = p.f/(1-p.f)
o.l = p.l/(1-p.l)
o.t = p.t/(1-p.t)
o.i = p.i/(1-p.i)

o.l/o.f #= 2.2 times more likely to use linkedin vs. facebook
o.l/o.t #= 6.7 times more likely to linkedin vs. twitter
o.f / o.t #= 3.0 times more likely to use facebook vs. twitter
o.f / o.i #= 92 times more likely to use facebook than instagram


table(mid$use_SM)

20 / (20+65) # 23.5% don't use social media

midtree1 = rpart(use_SM ~ bus_lit+work_comp+trust+tort+tax+social+real_estate+labor+international+ip+insurance+immigration+health+family+environment+entertainment+elder+construct+conservator+commercial+business+bankruptcy+banking+appellate+ADR, data = mid, method = "class")
#midtree1 = prune(midtree1, midtree1$cptable[which.min(midtree1$cptable[,"xerror"]),"CP"])
prp(midtree1, type = 3, extra = 109, main = "Mid: Use SM", under = T, fallen.leaves= T, digits = 4)

test = mid[s_keep]
dat <- as.data.frame(sapply(test, as.numeric))
co_mid = t(dat)

cooccur.mid <- cooccur(mat=co_mid, type="spp_site", thresh=TRUE,spp_names=TRUE)
plot(cooccur.mid)

### large

p.f = sum(large$Facebook == TRUE) / nrow(large)
p.l = sum(large$LinkedIn == TRUE) / nrow(large)
p.t = sum(large$Twitter == TRUE) / nrow(large)
p.i = sum(large$Instagram == TRUE) / nrow(large)

o.f = p.f/(1-p.f)
o.l = p.l/(1-p.l)
o.t = p.t/(1-p.t)
o.i = p.i/(1-p.i)

o.l/o.f #= 3.6 times more likely to use linkedin vs. facebook
o.l/o.t #= 4.5 times more likely to linkedin vs. twitter
o.f / o.t #= 1.3 times more likely to use facebook vs. twitter
o.f / o.i #= 30.5 times more likely to use facebook than instagram


table(large$use_SM)

10 / (10+72) # 12% don't use social media

largetree1 = rpart(use_SM ~ bus_lit+work_comp+trust+tort+tax+social+real_estate+labor+international+ip+insurance+immigration+health+family+environment+entertainment+elder+construct+conservator+commercial+business+bankruptcy+banking+appellate+ADR, data = large, method = "class")
#largetree1 = prune(largetree1, largetree1$cptable[which.min(largetree1$cptable[,"xerror"]),"CP"])
prp(largetree1, type = 3, extra = 109, main = "Large: Use SM", under = T, fallen.leaves= T, digits = 4)

test = large[s_keep]
dat <- as.data.frame(sapply(test, as.numeric))
co_large = t(dat)

cooccur.large <- cooccur(mat=co_large, type="spp_site", thresh=TRUE,spp_names=TRUE)
plot(cooccur.large)

######
