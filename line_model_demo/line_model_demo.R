# Cairo::CairoPDF("ELISA.pdf", width=7, height=5)
# Cairo::CairoPNG("ELISA.png", width=1400, height=1000, res=200)

# raw data each data has been replicated measured twice
# the last row is the measure of sample
raw_data1 <- c(0.053, 0.057,
               0.366, 0.315,
               0.677, 0.679,
               0.764, 0.792,
               1.008, 0.824,
               0.588, 0.326)

# clean data
data_norm1 <- raw_data1[seq(1, 11, 2)]
data_norm2 <- raw_data1[seq(2, 12, 2)]
data_norm <- (data_norm1+data_norm2)/2
data_norm <- data_norm -data_norm[1]
data1 <- data.frame(conc=c(0, 12.5, 25, 50, 100), od=data_norm[-length(data_norm)])

# line model fit (the model is y=b*x)
line.model <- lm(od~0+conc, data=data1)

# rsquared
summary(line.model)$r.squared

# f statistic
f <- summary(line.model)$fstatistic

# pvalue
pf(f[1], f[2], f[3], lower.tail=F)

# the data to be fitted renamed to x and y
x = data1$conc
y = data1$od

# par(family='Sans SimHei')
# 做散点图，并把坐标轴隐藏，
plot(x, y, pch=16, xlab="浓度 (pg/ml)", ylab="490nm OD值", bty="n",
     xlim=c(min(x), max(x))+c(0, 0.2)*(max(x)-min(x))/5,
     ylim=c(min(y), max(y))+c(0, 0.2)*(max(y)-min(y))/5,
     main="ELISA 标准曲线", axes=FALSE, family = "Microsoft Yahei")

# 自定义坐标轴，at为坐标点位置，labels默认为坐标点的数值
# tck表示坐标刻度长度，pos表示坐标轴的位置
axis(2, at=round(seq(0, max(y), length=7), 2), las=2, tck=0.01, pos=0)
axis(1, at=round(seq(0, max(x), length=6), 2), las=1, tck=0.01, pos=0)

# clip限制当前作图区域的界限
clip(-2, 120, -1, 1)
# 坐标轴加箭头
arrows(100, 0, 105, 0, length=0.1)
arrows(0, max(y), 0, max(y)+0.1, length=0.1)

# 作拟合直线
clip(min(x), max(x), min(y), max(y)+(max(y)-min(y))/6)
abline(line.model, lwd=2, col="red")

# 标注直线方程和拟合系数
text1 <- paste("y = ", round(line.model$coefficients, 5),"x",sep="")
text(x=quantile(x, 0.80), y=quantile(y, .39),
     labels= substitute(paste(text1, r.squared, sep=''), list(
       text1=paste(text1, "\n"), r.squared="")),
     adj=c(0,0))
text(x=quantile(x, 0.80), y=quantile(y, .39),
     labels= substitute(paste(text1, R^2, " = ", r.squared, sep=''), list(
       text1="\n", r.squared=round(summary(line.model)$r.squared, 4))),
     adj=c(0,0))

# 标注样本点
absorb_target = data_norm[length(data_norm)]
conc_target <- absorb_target/line.model$coefficients
points(conc_target, absorb_target, pch=16, col="blue", cex=1.3)
clip(0, conc_target, 0, absorb_target*2)
abline(h=absorb_target, lty=2)
clip(0, conc_target+1, 0, absorb_target)
abline(v=conc_target, lty=2)

# 标注样本点坐标值
clip(min(x), max(x), min(y), max(y)+(max(y)-min(y))/6)
text(conc_target+16, absorb_target, 
     paste("(", round(conc_target, 3), ", ",  round(absorb_target, 3), ")", sep=""))

# dev.off()