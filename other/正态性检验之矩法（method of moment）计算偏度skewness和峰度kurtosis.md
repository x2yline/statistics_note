# 正态性检验
x2yline  
2017年10月18日  



## 正态性检验最好不使用直接计算法检验偏度和峰度
**SPSS默认的两个方法为Shapiro – Wilk（W 检验）和Kolmogorov – Smirnov（D 检验） **

> 参考文章：  
> https://www.yaolibio.com/2017/01/03/normality-test/  
> http://blog.sina.com.cn/s/blog_5efe47110100d28m.html  
> http://blog.sina.com.cn/s/blog_403aa80a01019ly5.html  
> 但是其中所说的正态检验水准一般设置为0.10

### 当样本含量n ≤2000时，结果以Shapiro – Wilk（W 检验）为准

```r
# faithful是R里的一个内置数据集
shapiro.test(faithful$eruptions)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  faithful$eruptions
## W = 0.84592, p-value = 9.036e-16
```
### 当样本含量n >2000 时，结果以Kolmogorov – Smirnov（D 检验）为准

```r
ks.test(faithful$eruptions, "pnorm")
```

```
## Warning in ks.test(faithful$eruptions, "pnorm"): ties should not be present
## for the Kolmogorov-Smirnov test
```

```
## 
## 	One-sample Kolmogorov-Smirnov test
## 
## data:  faithful$eruptions
## D = 0.94857, p-value < 2.2e-16
## alternative hypothesis: two-sided
```

```
Warning message:
In ks.test(faithful$eruptions, "pnorm") :
  ties should not be present for the Kolmogorov-Smirnov test
```

出现警告，Kolmogorov - Smirnov检验里不应该有相等的值，可以忽略或加上参数exact=FALSE，默认使用近似算法计算近似p值。

## 直接计算法检验（纯练习用，可忽略）

### 1. 用R语言计算faithful数据框中的eruptions的3阶中心距(center moment)

```r
e1071::moment(faithful$eruptions,
    order=3, center=TRUE)
```

```
## [1] -0.6149059
```
### 2. 用R语言计算偏度，偏度计算公式为
![](http://upload-images.jianshu.io/upload_images/3947437-8b20424d8b61bbfc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  
 μ2 和 μ3 为二阶和三阶中心距，用moment计算中心距时，其除数为n而不是n-1，这里需要注意一下  
R语言验证:

```r
u3 <- e1071::moment(faithful$eruptions, order=3, center=TRUE)
u2 <- e1071::moment(faithful$eruptions, order=2, center=TRUE)
u3 <- mean((faithful$eruptions - mean(faithful$eruptions))^3)
u3/(u2)^(3/2)
```

```
## [1] -0.415841
```

```r
u3/(u2*nrow(faithful)/(nrow(faithful)-1))^1.5
```

```
## [1] -0.4135498
```

```r
e1071::skewness(faithful$eruptions)
```

```
## [1] -0.4135498
```

```r
agricolae::skewness(faithful$eruptions)
```

```
## [1] -0.4181505
```

```r
moments::skewness(faithful$eruptions)
```

```
## [1] -0.415841
```

```r
propagate::skewness(faithful$eruptions)
```

```
## [1] -0.415841
```

```r
skew <- agricolae::skewness(faithful$eruptions)
```

> propagate、moments、e1071包和agricolae的包计算结果的差异是由于e1071算的三阶中心距是有偏的估计，而propagate和moments的三阶和二阶距估计都是有偏的，所以agricolae的结果更为准确

![](http://upload-images.jianshu.io/upload_images/3947437-a22336bbb35ba027.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  

**偏度小于0说明均值小于中位数，呈左偏分布（负偏分布）  
PS: 教材的第39页公式似乎更加精确**

### 3. 用R语言计算峰度
![](http://upload-images.jianshu.io/upload_images/3947437-2c4d40e6e1105c62.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  

```r
u4 <- e1071::moment(faithful$eruptions, order=4, center=TRUE)
u2 <- e1071::moment(faithful$eruptions, order=2, center=TRUE)
u4/u2^2 -3
```

```
## [1] -1.5006
```

```r
u4/var(faithful$eruptions)^2 - 3
```

```
## [1] -1.511605
```

```r
e1071::kurtosis(faithful$eruptions)
```

```
## [1] -1.511605
```

```r
agricolae::kurtosis(faithful$eruptions)
```

```
## [1] -1.506167
```

```r
moments::kurtosis(faithful$eruptions)
```

```
## [1] 1.4994
```

```r
moments::kurtosis(faithful$eruptions)-3
```

```
## [1] -1.5006
```

```r
propagate::kurtosis(faithful$eruptions)
```

```
## [1] -1.5006
```

```r
kurt <- agricolae::kurtosis(faithful$eruptions)
```
> propagate、moments、e1071包和agricolae的包计算结果的差异是由于e1071算的四中心距是有偏的估计，而propagate和moments的都是有偏估计，所以agricolae的结果更为准确  

**峰度等于0说明标准化后的分布与正态分布的峰同样尖锐，大于0说明更加尖锐，尾部更粗；小于0说明更加平坦，尾部更细。   
PS: 教材的第39页公式似乎更加精确**

### 4. 偏度和峰度的假设检验
H0：skew = 0, krut = 0，即总体服从正态分布  
H1：skew ！= 0或（和）krut！= 0，即总体不服从正态分布  
计算出峰度和偏度以后，还能计算出峰度和偏度的标准误  
* 峰度和偏度标准误

```r
ses <- sqrt(6 / length(faithful$eruptions))
sek <- sqrt(24/length(faithful$eruptions))
```
* 检验统计量

```r
totests <- 	skew/ses
totestk <- kurt/sek
```

* 计算p值

```r
pvals <- pt(totests, (length(faithful$eruptions) - 1))
pvalk <- pt(totestk, (length(faithful$eruptions) - 1))
pvals
```

```
## [1] 0.002614556
```

```r
pvalk
```

```
## [1] 3.68164e-07
```
所以按0.01水平，拒绝H0，接受H1，这些样本不服从正态分布


## 其他正态性检验R包nortest和normtest
> R自带的stats包里有Kolmogorov-Smirnov检验和Shapiro-Wilk检验，同时nortest包里的Lilliefor检验、Anderson-Darling检验···和tseries包中的Jarque-Bera检验也能进行检验


```r
# Anderson-Darling test for normality
nortest::ad.test(faithful$eruptions)
```

```
## 
## 	Anderson-Darling normality test
## 
## data:  faithful$eruptions
## A = 17.305, p-value < 2.2e-16
```

```r
# Lilliefors (Kolmogorov-Smirnov) test for normality
# Although the test statistic obtained from lillie.test(x) is the same as that obtained from
# ks.test(x, "pnorm", mean(x), sd(x)), it is not correct to use the p-value from the latter for
# the composite hypothesis of normality (mean and variance unknown), since the distribution of the
# test statistic is different when the parameters are estimated.
nortest::lillie.test(faithful$eruptions)
```

```
## 
## 	Lilliefors (Kolmogorov-Smirnov) normality test
## 
## data:  faithful$eruptions
## D = 0.18135, p-value < 2.2e-16
```

```r
# jarque.bera.test: This test is a joint statistic using skewness and kurtosis coefficients.
tseries::jarque.bera.test(faithful$eruptions)
```

```
## 
## 	Jarque Bera Test
## 
## data:  faithful$eruptions
## X-squared = 33.36, df = 2, p-value = 5.702e-08
```

```r
normtest::skewness.norm.test(faithful$eruptions)
```

```
## 
## 	Skewness test for normality
## 
## data:  faithful$eruptions
## T = -0.41584, p-value = 0.006
```

```r
normtest::kurtosis.norm.test(faithful$eruptions)
```

```
## 
## 	Kurtosis test for normality
## 
## data:  faithful$eruptions
## T = 1.4994, p-value = 0.001
```
https://cran.r-project.org/web/packages/nortest/nortest.pdf   
https://cran.r-project.org/web/packages/normtest/normtest.pdf     
https://stats.stackexchange.com/questions/3136/how-to-perform-a-test-using-r-to-see-if-data-follows-normal-distribution    
https://cran.r-project.org/web/packages/tseries/tseries.pdf  

参考：  
http://www.r-tutor.com/elementary-statistics/numerical-measures/variance  
http://www.r-tutor.com/elementary-statistics/numerical-measures/moment  
https://stat.ethz.ch/pipermail/r-help/1999-July/004529.html  
http://www.r-tutor.com/elementary-statistics/numerical-measures/skewness  
http://www.r-tutor.com/elementary-statistics/numerical-measures/kurtosis  
https://artax.karlin.mff.cuni.cz/r-help/library/agricolae/html/skewness.html  
https://artax.karlin.mff.cuni.cz/r-help/library/agricolae/html/kurtosis.html  
https://www.researchgate.net/post/Could_anyone_tell_me_how_to_calculate_skewness_and_kurtosis_of_a_numeric_variable_in_R