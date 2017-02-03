# law firm social media analysis, complete

# read in ocba data
ocba = read.csv("ocba.csv", header = T, stringsAsFactors = F)
str(ocba)

# n = 5445

# categorize each law firm

tag = NULL
tomatch = c(" law", "offices", "office", "firm", "LLP", "L.L.P.","P.C","PC","PLC","&","APLC","APC","A.P.L.C","jones","latham","associates","et al","hart king","smiley", "berger","matkins","darnell","shapiro","mitchell","ALC","attorney","legal","roberts","group")
ocba$law = grepl(paste(tomatch,collapse="|"), ocba$Company, ignore.case = T)

head(ocba, 100)
tail(ocba,100)
ocba[3000:3100,]
ocba[1500:1600,]
ocba[4500:4600,]

summary(ocba$law)
# non-law firm: 1046
# law firm: 4399
# total: 5445


# filter out non law firms

lawfirms = ocba[which(ocba$law == TRUE),]
str(lawfirms)

# n = 4399

## now I can extract the email addresses

lawfirms$web = sub(".*@", "", lawfirms$E.mail.Address)
lawfirms$web = tolower(lawfirms$web)

str(lawfirms)

# tag common emails

common = c("aol.com", "att.net", "comcast.net", "facebook.com", "gmail.com", "gmx.com", "googlemail.com", "google.com", "hotmail.com", "hotmail.co.uk", "mac.com", "me.com", "mail.com", "msn.com", "live.com", "sbcglobal.net", "verizon.net", "yahoo.com", "yahoo.co.uk", "email.com", "games.com", "gmx.net", "hush.com", "hushmail.com", "icloud.com", "inbox.com", "lavabit.com", "love.com", "outlook.com", "pobox.com", "rocketmail.com", "safe-mail.net", "wow.com", "ygm.com", "ymail.com", "zoho.com", "fastmail.fm","bellsouth.net", "charter.net", "comcast.net", "cox.net", "earthlink.net", "juno.com", "btinternet.com", "virginmedia.com", "blueyonder.co.uk", "freeserve.co.uk", "live.co.uk", "ntlworld.com", "o2.co.uk", "orange.net", "sky.com", "talktalk.co.uk", "tiscali.co.uk", "virgin.net", "wanadoo.co.uk", "bt.com", "sina.com", "qq.com", "naver.com", "hanmail.net", "daum.net", "nate.com", "yahoo.co.jp", "yahoo.co.kr", "yahoo.co.id", "yahoo.co.in", "yahoo.com.sg", "yahoo.com.ph", "hotmail.fr", "live.fr", "laposte.net", "yahoo.fr", "wanadoo.fr", "orange.fr", "gmx.fr", "sfr.fr", "neuf.fr", "free.fr","gmx.de", "hotmail.de", "live.de", "online.de", "t-online.de", "web.de", "yahoo.de", "mail.ru", "rambler.ru", "yandex.ru", "ya.ru", "list.ru","hotmail.be", "live.be", "skynet.be", "voo.be", "tvcablenet.be", "telenet.be","hotmail.com.ar", "live.com.ar", "yahoo.com.ar", "fibertel.com.ar", "speedy.com.ar", "arnet.com.ar","hotmail.com", "gmail.com", "yahoo.com.mx", "live.com.mx", "yahoo.com", "hotmail.es", "live.com", "hotmail.com.mx", "prodigy.net.mx", "msn.com")


lawfirms$common = grepl(paste(common,collapse="|"), lawfirms$web, ignore.case = T)

head(lawfirms,100)
tail(lawfirms, 100)

summary(lawfirms$common)
# not common = 3675, common = 724

# remove common addresses

firms = lawfirms[which(lawfirms$common == FALSE),]
str(firms)

# n = 3675

# just extract list of firms

firms = firms$web
# 32 blank
firms = firms[which(firms != "")]
str(firms)
# n = 3643
# count by number
firms = data.frame(table(firms))

# read in top 400 law firms

top = read.csv("top400urls.csv", header = T, stringsAsFactors = F)
str(top)

# tag the URLS as top 400

		
firms$size = as.factor(ifelse(grepl(paste(top[,1],collapse="|"), as.character(firms[,1]), ignore.case = T)==TRUE, "top400",
	ifelse(firms[,2]==1, "solo", ifelse(firms[,2]<11,"small","mid"))))

str(firms)
head(firms,100)
tail(firms,100)
firms$Freq = as.numeric(firms$Freq)

table(firms$size)
# mid: 24 small: 398 solo: 947 top400:73

aggregate(Freq~size, data = firms, sum)
# mid: 481 small: 1331 solo: 947 top400: 884

### now take these firms and categorize them. 
# get html from each site and save

count = data.frame(firms$firms)
count$url = paste0("http://www.",as.character(firms$firms))
str(count)


# library(rvest)
# library(XML)
# html=NULL
# write = NULL
# for (i in 965:nrow(count)){
# html = tryCatch(html(as.character(count[i,2])), error=function(e) NULL)
# tryCatch(saveXML(html, file=paste0("/Users/incredibeau/Dropbox/law\ school/Independant\ Study/sites2/",count[i,1],".html")), error=function(e) NULL)
# write = c(write,count[i,1])
# html=NULL
# }

#### 
# now analyize and categorize
# i'm using a combined approach

files <- list.files(path="sites3", pattern="*.html", full.names=T, recursive=FALSE)

library(RCurl)
library(XML)
library(rvest)

final = NULL

for (i in 1:length(files)) {

url = NULL
test = NULL
html = NULL
test2 = NULL
df = NULL

facebook = F
linkedin = F
twitter = F
instagram = F
email = F
pinterest = F
vimeo = F
rss = F
avvo = F
martindale = F
findlaw = F
contact = F




df = data.frame(xpathSApply(html(files[[i]]), "//a/@href", simplify = T))

if (length(df) > 0) {
# i don't want the specific links here so I'm commenting this out
# for (q in 1:nrow(df)) {
# if (grepl("facebook",df[q,1]) == T) {facebook <- as.character(df[q,1])}
# if (grepl("linkedin",df[q,1]) == T) {linkedin <- as.character(df[q,1])}
# if (grepl("twitter",df[q,1]) == T) {twitter <- as.character(df[q,1])}
# if (grepl("instagram",df[q,1]) == T) {instagram <- as.character(df[q,1])}
# if (grepl("mailto",df[q,1]) == T) {email <- as.character(df[q,1])}
# if (grepl("vimeo",df[q,1]) == T) {vimeo <- as.character(df[q,1])}
# if (grepl("rss",df[q,1]) == T) {rss <- as.character(df[q,1])}
# if (grepl("pinterest",df[q,1]) == T) {pinterest <- as.character(df[q,1])}
# if (grepl("avvo",df[q,1]) == T) {avvo <- as.character(df[q,1])}
# if (grepl("martindale",df[q,1]) == T) {martindale <- as.character(df[q,1])}
# if (grepl("findlaw",df[q,1]) == T) {findlaw <- as.character(df[q,1])}
# if (grepl("contact",df[q,1]) == T) {contact <- as.character(df[q,1])}
	# }
	for (q in 1:nrow(df)) {
if (grepl("facebook",df[q,1]) == T) {facebook <- T}
if (grepl("linkedin",df[q,1]) == T) {linkedin <- T}
if (grepl("twitter",df[q,1]) == T) {twitter <- T}
if (grepl("instagram",df[q,1]) == T) {instagram <- T}
if (grepl("mailto",df[q,1]) == T) {email <- T}
if (grepl("vimeo",df[q,1]) == T) {vimeo <- T}
if (grepl("rss",df[q,1]) == T) {rss <- T}
if (grepl("pinterest",df[q,1]) == T) {pinterest <- T}
if (grepl("avvo",df[q,1]) == T) {avvo <- T}
if (grepl("martindale",df[q,1]) == T) {martindale <- T}
if (grepl("findlaw",df[q,1]) == T) {findlaw <- T}
if (grepl("contact",df[q,1]) == T) {contact <- T}
	}
}

add = data.frame(cbind(facebook, linkedin, twitter, instagram, email, vimeo, rss, pinterest, avvo, martindale, findlaw, contact), stringsAsFactors = F)
colnames(add) =c("facebook","linkedin","twitter","instagram","email","vimeo", "rss", "pinterest", "avvo", "martindale", "findlaw", "contact")
final = rbind(final, add)

}

head(final)

# get names
names = data.frame(gsub(".html","",gsub("sites3/","",files,ignore.case = T)))
total = cbind(names,final)

# categorize them

adr = c("alternative dispute resolution", "ADR", "dispute resolution", "mediation")
health = c("health", "medical", "health care")
appellate = c("appellate")
immigration = c("immigration")
bank = c("bank", "banking", "lend","lending")
insurance = c("insurance")
business = c("business law", "corporate law", "mergers", "acquisitions", "contract", "contracts")
corp_lit = c("business litigation", "corporate litigation", "commercial litigation")
bankruptcy = c("bankruptcy")
IP = c("intellectual property", "patent", "trademark", "copyright", "trade secret", "trade dress")
labor = c("labor", "employment")
real_estate = c("real estate","housing")
family = c("family law", "divorce", "adoption","children", "child", "juvenile","domestic violence")
tort = c("tort", "trial lawyer", "trial attorney", "product liability", "plaintiff","personal injury", "accident")
tax = c("tax", "IRS")
environment = c("environmental", "environment")
trusts = c("trusts", "estate", "wills")
workers = c("workers", "workers’")
elder = c("elder")
entertainment = c("entertainment", "sports", "marketing")
social = c("social security")
international = c("international law", "multinational law", "international")
criminal = c("criminal", "defense", "crime", "white-collar", "white collar","prisoner")
administrative = c("administrative")
litigation = c("litigation")
transaction = c("transactional", "transaction")
prosecution = c("prosecution","procure")
legal = c("legal", "lawyer", "attorney", "esquire", "esq")

classification = NULL

for (z in 1:length(files)){
	
site = data.frame(tolower(html_text(html_nodes(html(files[[z]]), "body"))), stringsAsFactors = F)
	
a.dr = unique(grepl(paste(adr,collapse="|"), site, ignore.case = T))
a.ppellate = unique(grepl(paste(appellate,collapse="|"), site, ignore.case = T))
b.ank = unique(grepl(paste(bank,collapse="|"), site, ignore.case = T))
b.usiness = unique(grepl(paste(business,collapse="|"), site, ignore.case = T))
c.orp_lit = unique(grepl(paste(corp_lit,collapse="|"), site, ignore.case = T))
b.ankruptcy = unique(grepl(paste(bankruptcy,collapse="|"), site, ignore.case = T))
e.lder = unique(grepl(paste(elder,collapse="|"), site, ignore.case = T))
e.ntertainment = unique(grepl(paste(entertainment,collapse="|"), site, ignore.case = T))
e.nvironment = unique(grepl(paste(environment,collapse="|"), site, ignore.case = T))
f.amily = unique(grepl(paste(family,collapse="|"), site, ignore.case = T))
w.orkers = unique(grepl(paste(workers,collapse="|"), site, ignore.case = T))
t.rusts = unique(grepl(paste(trusts,collapse="|"), site, ignore.case = T))
t.ort = unique(grepl(paste(tort,collapse="|"), site, ignore.case = T))
t.ax = unique(grepl(paste(tax,collapse="|"), site, ignore.case = T))
s.ocial = unique(grepl(paste(social,collapse="|"), site, ignore.case = T))
r.eal_estate = unique(grepl(paste(real_estate,collapse="|"), site, ignore.case = T))
l.abor = unique(grepl(paste(labor,collapse="|"), site, ignore.case = T))
i.nternational = unique(grepl(paste(international,collapse="|"), site, ignore.case = T))
i.nsurance = unique(grepl(paste(insurance,collapse="|"), site, ignore.case = T))
i.mmigration = unique(grepl(paste(immigration,collapse="|"), site, ignore.case = T))
h.ealth = unique(grepl(paste(health,collapse="|"), site, ignore.case = T))
I.P = unique(grepl(paste(IP,collapse="|"), site, ignore.case = T))
c.riminal = unique(grepl(paste(criminal,collapse="|"), site, ignore.case = T))
a.dministrative = unique(grepl(paste(administrative,collapse="|"), site, ignore.case = T))
l.itigation = unique(grepl(paste(litigation,collapse="|"), site, ignore.case = T))
t.ransaction = unique(grepl(paste(transaction,collapse="|"), site, ignore.case = T))
p.rosecution = unique(grepl(paste(prosecution,collapse="|"), site, ignore.case = T))
l.egal = unique(grepl(paste(legal,collapse="|"), site, ignore.case = T))

a.dd = cbind(a.dr,
a.ppellate,
b.ank,
b.usiness,
c.orp_lit,
b.ankruptcy,
e.lder,
e.ntertainment,
e.nvironment,
f.amily,
w.orkers,
t.rusts,
t.ort,
t.ax,
s.ocial,
r.eal_estate,
l.abor,
i.nternational,
i.nsurance,
i.mmigration,
h.ealth,
I.P,
c.riminal,
a.dministrative,
l.itigation,
t.ransaction,
p.rosecution, 
l.egal)

colnames(a.dd) = c("adr",
"appellate",
"bank",
"business",
"corp_lit",
"bankruptcy",
"elder",
"entertainment",
"environment",
"family",
"workers",
"trusts",
"tort",
"tax",
"social",
"real_estate",
"labor",
"international",
"insurance",
"immigration",
"health",
"IP",
"criminal",
"administrative",
"litigation",
"transaction",
"prosecution", 
"legal")
classification = rbind(classification, a.dd)
}

head(classification)



total = cbind(total,classification)
str(total)

colnames(total)[1] = "firms"


#########################

# need to combine in the other data I have with these. 

head(firms)
firms$firms = gsub("\\..*","",firms$firms)

# read in old data 

old = read.csv("ocfirmscomplete-01b.csv", header = T, stringsAsFactors = F)
str(old)
old = old[,1:3]
colnames(old) = c("firms","Freq","size")
old$firms = gsub("http://www.","",old$firms)
old$firms = gsub("\\..*","",old$firms)
old$size = tolower(old$size)
old$Freq = as.numeric(old$Freq)
str(old)

firms$firms = as.character(firms$firms)
str(firms)

all = subset(rbind(firms,old), !duplicated(firms))
str(all)

#### combine all data 

all$firms = as.factor(all$firms)
str(all)

complete = merge(all, total, by ="firms")
str(complete)

#save out complete dataset

write.csv(complete, "2015-12-3_complete.csv")


complete = read.csv("2015-12-3_complete.csv", header = T)
str(complete)
#######

# now I can create my graphs and charts!

# plot # x firm size
#   mid  small   solo top400 
#    25    386    948     70
pdf("1.pdf", useDingbats = F)
barplot(table(complete$size), main = "# by firm size")
dev.off()

# plot attorneys x firm size
two = aggregate(Freq~size, data = complete, sum)
# mid:498 ; small:1266; solo:948; top400:895
pdf("2.pdf", useDingbats = F)
barplot((two$Freq), main = "attorneys by firm size", names.arg = two$size)
dev.off()

# plot firm type
colnames(complete)[16]
colnames(complete)[39]
str(complete)
pdf("3.pdf", useDingbats = F)
barplot(as.matrix(complete[,16:39]), las = 2, main = "practice areas")
dev.off()

#types by firm size
solo = complete[which(complete$size == "solo"),]
small = complete[which(complete$size == "small"),]
mid = complete[which(complete$size == "mid"),]
top400 = complete[which(complete$size == "top400"),]
pdf("4.pdf", useDingbats = F)
par(mfrow=c(2,2))
barplot(as.matrix(solo[,16:39]), las = 2, main = "solo practice areas", horiz = F, col = "blue", density = NULL, border = NULL, ylim = c(0,nrow(solo)))
barplot(as.matrix(small[,16:39]), las = 2, main = "small practice areas", horiz = F, col = "blue", ylim = c(0,nrow(small)))
barplot(as.matrix(mid[,16:39]), las = 2, main = "mid practice areas", horiz = F, col = "blue", ylim = c(0, nrow(mid)))
barplot(as.matrix(top400[,16:39]), las = 2, main = "top400 practice areas", horiz = F, col = "blue", ylim = c(0, nrow(top400)))
dev.off()

# solo data
colnames(solo)[17]
yes = data.frame(c("TRUE","FALSE"))
colnames(yes)[1] = "x"

for(j in 17:37){
a = count(solo[,j])
colnames(a)[2]=colnames(solo)[j]
yes = merge(yes,a, by = "x")
}
rownames(yes) = yes[,1]
n_solo = data.frame(t(yes[,2:length(yes)]))
n_solo$size = "solo"
n_solo$category = rownames(n_solo)
n_solo$prop = n_solo[,2] / (n_solo[,1] + n_solo[,2])

barplot(n_solo$prop, names.arg = n_solo$category, las = 2, ylim = c(0,1))

#small data

yes = data.frame(c("TRUE","FALSE"))
colnames(yes)[1] = "x"

for(j in 17:37){
a = count(small[,j])
colnames(a)[2]=colnames(small)[j]
yes = merge(yes,a, by = "x")
}
rownames(yes) = yes[,1]
n_small = data.frame(t(yes[,2:length(yes)]))
n_small$size = "small"
n_small$category = rownames(n_small)
n_small$prop = n_small[,2] / (n_small[,1] + n_small[,2])

barplot(n_small$prop, names.arg = n_small$category, las = 2, ylim = c(0,1))

#mid data

yes = data.frame(c("TRUE","FALSE"))
colnames(yes)[1] = "x"

for(j in 17:37){
a = count(mid[,j])
colnames(a)[2]=colnames(mid)[j]
yes = merge(yes,a, by = "x", all = T)
}
yes[is.na(yes)] = 0
rownames(yes) = yes[,1]
n_mid = data.frame(t(yes[,2:length(yes)]))
n_mid$size = "mid"
n_mid$category = rownames(n_mid)
n_mid$prop = n_mid[,2] / (n_mid[,1] + n_mid[,2])

barplot(n_mid$prop, names.arg = n_mid$category, las = 2, ylim = c(0,1))

#top data

yes = data.frame(c("TRUE","FALSE"))
colnames(yes)[1] = "x"

for(j in 17:37){
a = count(top400[,j])
colnames(a)[2]=colnames(top400)[j]
yes = merge(yes,a, by = "x", all = T)
}
yes[is.na(yes)] = 0
n_top = data.frame(t(yes[,2:length(yes)]))
n_top$size = "mid"
n_top$category = rownames(n_top)
n_top$prop = n_top[,2] / (n_top[,1] + n_top[,2])

barplot(n_top$prop, names.arg = n_top$category, las = 2, ylim = c(0,1))


pdf("4.pdf", useDingbats = F)
par(mfrow=c(2,2))
barplot(n_solo$prop, names.arg = n_solo$category, las = 2, ylim = c(0,1), main = "solo practice areas", horiz = F, col = "blue", density = NULL, border = NULL)
barplot(n_small$prop, names.arg = n_small$category, las = 2, main = "small practice areas", horiz = F, col = "blue", ylim = c(0,1))
barplot(n_mid$prop, names.arg = n_mid$category, las = 2, main = "mid practice areas", horiz = F, col = "blue", ylim = c(0, 1))
barplot(n_top$prop, names.arg = n_top$category, las = 2, main = "top400 practice areas", horiz = F, col = "blue", ylim = c(0, 1))
dev.off()



# social media use in general
str(complete)
colnames(complete)[4]
colnames(complete)[15]
pdf("5.pdf", useDingbats = F)
barplot(as.matrix(complete[,4:7]), las = 2, main = "all social media use")
dev.off()

# social media by each
pdf("6.pdf", useDingbats = F)
par(mfrow=c(2,2))
barplot(as.matrix(solo[,4:7]), las = 2, main = "solo social media use")
barplot(as.matrix(small[,4:7]), las = 2, main = "small social media use")
barplot(as.matrix(mid[,4:7]), las = 2, main = "mid social media use")
barplot(as.matrix(top400[,4:7]), las = 2, main = "top400 social media use")
dev.off()


# social media by firm types. 

library(randomForest)
str(complete)
p1 = randomForest(complete[,4:16])
MDSplot(p1, complete$size) # no separation
MDSplot(p1, complete$facebook, k=2)


p2 = randomForest(complete[,17:37])
MDSplot(p2, numlinks)


numlinks = NULL
for(m in 1:nrow(complete)){
bb = length(grep(TRUE,complete[m,4:16]))
numlinks = rbind(numlinks,bb)
}
str(numlinks)
complete$numlinks = (numlinks[,1])
str(complete )

p2.1 = randomForest(complete[,c(4,17:37)])
MDSplot(p2.1, complete[,4],)
legend("topright", legend=levels(complete[,4]))


p3 = randomForest(complete[,c(4,17:37)],complete$numlinks)
importance(p3)
varImpPlot(p3) # tax, health, real estate, size, family

p4 = randomForest(complete[,c(4,17:37)],complete$facebook)
importance(p4)
varImpPlot(p4) # tax, health, real estate

p5 = randomForest(complete[,c(4,17:37)],complete$linkedin)
importance(p5)
varImpPlot(p5) # tax, health, real estate

p6 = randomForest(complete[,c(4,17:37)],complete$twitter)
importance(p6)
varImpPlot(p6) # size, health, tax, real-estate

###### try variable selection 

library(leaps)
library(MASS)

paste(colnames(complete[,c(4,17:37)]), collapse = " + ")

reg1 = regsubsets(facebook ~ size + adr + appellate + bank + business + corp_lit + bankruptcy + elder + entertainment + environment + family + workers + trusts + tort + tax + social + real_estate + labor + international + insurance + immigration + health, data = complete, nvmax = 5)
summary(reg1)
plot(reg1) # tax, health, family, entertainment

reg2 = regsubsets(linkedin ~ size + adr + appellate + bank + business + corp_lit + bankruptcy + elder + entertainment + environment + family + workers + trusts + tort + tax + social + real_estate + labor + international + insurance + immigration + health, data = complete, nvmax = 5)
summary(reg2)
plot(reg2) # tax, health, bank, top400, real estate

reg3 = regsubsets(twitter ~ size + adr + appellate + bank + business + corp_lit + bankruptcy + elder + entertainment + environment + family + workers + trusts + tort + tax + social + real_estate + labor + international + insurance + immigration + health, data = complete, nvmax = 5)
summary(reg3)
plot(reg3) # health, tax, top400, bank, entertainment

reg4 = regsubsets(instagram ~ size + adr + appellate + bank + business + corp_lit + bankruptcy + elder + entertainment + environment + family + workers + trusts + tort + tax + social + real_estate + labor + international + insurance + immigration + health, data = complete, nvmax = 5)
summary(reg4)
plot(reg4) # bank, bankruptcy, entertainment, international, business

reg5 = regsubsets(numlinks ~ size + adr + appellate + bank + business + corp_lit + bankruptcy + elder + entertainment + environment + family + workers + trusts + tort + tax + social + real_estate + labor + international + insurance + immigration + health, data = complete, nvmax = 5)
summary(reg5)
plot(reg5) # tax, real estate, health, family, bank

colnames(complete)
keep = (c("facebook","size","tax","health","family","entertainment"))
fb1 = complete[,keep]
pfb1 = prop.table(table(fb1))
plot(pfb1)

library(ca)

ca(table(complete$facebook,complete$size))

####### some plots

sizeXfacebook = (t(table(complete$facebook,complete$size)))
str(sizeXfacebook)
plot(sizeXfacebook)
barplot(sizeXfacebook)

sizeXlinkedin = (t(table(complete$linkedin,complete$size)))
str(sizeXlinkedin)
plot(sizeXlinkedin)

sizeXtwitter = (t(table(complete$twitter,complete$size)))
str(sizeXtwitter)
plot(sizeXtwitter)

sizeXavvo = (t(table(complete$avvo,complete$size)))
str(sizeXavvo)
plot(sizeXavvo)

sizeXfindlaw = (t(table(complete$findlaw,complete$size)))
str(sizeXfindlaw)
plot(sizeXfindlaw)

sizeXmartindale = (t(table(complete$findlaw,complete$size)))
str(sizeXmartindale)
plot(sizeXmartindale)

healthXfacebook = (t(table(complete$facebook,complete$health)))
str(healthXfacebook)
plot(healthXfacebook)

healthXnumlinks = (t(table(complete$numlinks,complete$health)))
str(healthXnumlinks)
barplot(healthXnumlinks)

taxXsize = (t(table(complete$size,complete$tax)))
str(taxXsize)
plot(taxXsize)
barplot(taxXsize)

