## 1. 简单实现qq图
输入为一个vector，我们以a <- seq(1, 250, 1)做为示例数据
```r
a <- seq(1, 250, 1)
```
利用qqnorm函数直接绘制出了如下正态检验qq图
```r
qqnorm(a)
```
![image](http://wx2.sinaimg.cn/large/005MmbhLgy1fjy91hluq7j30b40b4q35.jpg)

还可以进一步使用qqline命令在qq图上加上标准直线
```r
qqline(a, col=2, lwd=2)  # 设置为红色加粗
```
**注：qqline的默认算法为向量a上四分位数和下四分位数对应两个点的连线**  
> By default qqline draws a line through the first and third quartiles[[1]](https://stackoverflow.com/questions/15449760/qqline-does-not-give-the-line-that-i-expected).


## 2. 了解基本原理，手动实现qq plot
**Step 1：** 首先我们算出vector中每一个数对应的百分位数  
&emsp;&emsp;在向量a中，数字1对应的累积比例（即小于等于数字1的频率）为1/length(a) = 0.04，数字250对应的累积比例为250/length(a) = 100%  
```r
t <- rank(a)/length(a)
```
> rank()函数作用是计算出某数在该向量中从小到大排列的序号  

&emsp;&emsp;   
**Step 2：** 根据累积比例数计算出正态分布对应的百分位数值
```r
q <- qnorm(t)
```
&emsp;&emsp;直接绘制点图即为qqplot图
```r
plot(q, a)
```
&emsp;&emsp;

**Step 3：** 可以查看一下q值发现，最后的q值为Inf  
&emsp;&emsp;这是因为百分位100%对应的正态分布数值为无穷大，所以最后得出的图与R自带的qqnorm的稍微有一点点区别，这是因为在内置的qqnorm函数中对累积百分数进行了调整，为了避免inf的出现，使用 **t <- (rank(a) -0.5)/length(a)** 调整后得出的结果与qqnorm的结果图就完全一致了。

> tips：qnorm可以随不同待检验的分布而调整（如qt,qf...)

&emsp;  
**Step 4：** 绘制标准直线  
&emsp;&emsp;如果是依据标准正态分布做的qq图，则标准直线截距为mean(a)，斜率为sd(a)
```r
a <- seq(1, 250, 1)
t <- (rank(a) -0.5)/length(a)
q <- qnorm(t)
plot(q, a)
abline(mean(a), sd(a), col=2, lwd=2)
```
![](http://wx3.sinaimg.cn/mw690/005MmbhLgy1fjyaovlsmdj30b40b4mxg.jpg)
&emsp;&emsp;如果是依据(mean(a), var(a))正态分布做的qq图，则标准直线为y=x 
```r
a <- seq(1, 250, 1)
t <- (rank(a) -0.5)/length(a)
q <- qnorm(t, mean=mean(a), sd=sd(a))
plot(q, a)
abline(0, 1, col=2, lwd=2)
```
![](http://wx3.sinaimg.cn/mw690/005MmbhLgy1fjyap23d8gj30b40b4q34.jpg)

## 3. pp plot绘制原理
pp plot横轴为实际累积概率，即上文qq plot中的变量t  
纵轴为期望累积的概率，标准直线为 y=x
```r
a <- seq(1, 250, 1)
plot((rank(a)-0.5)/length(a), pnorm(mean=mean(a), sd=sd(a), a), main="PP plot")
# abline(0, 1)
```
![ppplot1](http://wx2.sinaimg.cn/large/005MmbhLgy1fjyap2sdyuj30b40b4glu.jpg)

## 总结：
#### 1. qqnorm()可以直接绘制正态分布检验的qqplot  
```r
set.seed(100)
qqnorm(rnorm(200)) 
```
![](http://wx4.sinaimg.cn/large/005MmbhLgy1fjyap3err5j30b40b40sw.jpg)

结果大致呈一条直线则说明大致服从正态分布

#### 2. 手动实现  
```r
set.seed(100)
a <- rnorm(200)
t <- (rank(a)-0.5)/length(a)
plot(qnorm(t), a)
```

快速计算累积百分数的方法：  
```r
t <- ppoints(length(a))
plot(qnorm(t), sort(a)) #或者直接使用qqplot(qnorm(t), a)
abline(mean(a), sd(a), lwd=2, col="red")
```

![](http://wx3.sinaimg.cn/mw690/005MmbhLgy1fjyato0yh6j30b40b4wen.jpg)

参考：  
https://wenku.baidu.com/view/c661ebb365ce050876321319.html
http://data.library.virginia.edu/understanding-q-q-plots/
http://www.cnblogs.com/xianghang123/archive/2012/08/08/2628623.html
https://d.cosx.org/d/18521-18521