## 分类资料的秩和检验

###  代码 

```R
# ordinal_data <- haven::read_sav(
#   "E:/医学统计学（第4版）/各章例题SPSS数据文件/例08-04.sav")
# colnames(ordinal_data) <- c("组别","含量", "频数")
# save(file="08-04.Rdata", list=c("ordinal_data"))

# 加载数据
load(url("https://github.com/x2yline/statistics_note/blob/master/data/08-04.Rdata?raw=true"))

# 查看数据
head(ordinal_data, 10)

# 转换数据
row2df <- function(x){
  group <- rep(as.numeric(x[1]), x[3])
  conc <- rep(as.numeric(x[2]), x[3])
  return(data.frame(group=group, conc=conc))
}

test_data <- plyr::adply(ordinal_data, .margins=1, row2df)[, c(-1, -2, -3)]

# 秩和检验
wilcox.test(conc~group, data=test_data, exact=F)
```

### 运行结果

```


    Wilcoxon rank sum test with continuity correction

data:  conc by group

W = 1137, p-value = 0.0002181

alternative hypothesis: true location shift is not equal to 0

```


