public:: true

- ## 百分位數（Percentile）是什麼？
- 不是有平均值（average）嘛？為什麼要看百分位數（Percentile）?
- 平均值大家都知道，是將所有需要計算的值相加後，除上值的數量。
- ![回應時間的常態分佈](https://marvel-b1-cdn.bc0a.com/f00000000236551/dt-cdn.net/wp-content/uploads/migration/bellcurve1-600x298.png)
- 資料來源：[Why averages suck and percentiles are great](https://www.dynatrace.com/news/blog/why-averages-suck-and-percentiles-are-great/)
- 在常態分佈(The bell curve)當中，平均值和中位數（Median）是相同的。換句話說，觀察到的效能代表著一半或一半以上的事務(transaction)。
- #+BEGIN_NOTE
  **中位數（Median）**
  將一組數值資料由小到大排列，最中間的數值即為中位數
  #+END_NOTE
- 長尾分佈的平均值會被影響，變得比中位數還高。
- 但在現實當中，大部分的軟體都有著少數非常極端的異常值(outlier)，也就是資料的分佈會從常態分佈變成長尾分佈（Long-tail curve)。長尾分佈不是暗喻著有很多很慢的事務(transaction)，而是代表的有少數的事務與一般事務相比，是極度緩慢的。
- ![回應時間的長尾分佈](https://marvel-b1-cdn.bc0a.com/f00000000236551/dt-cdn.net/wp-content/uploads/migration/Distribution1-600x380.png)
- 資料來源：[Why averages suck and percentiles are great](https://www.dynatrace.com/news/blog/why-averages-suck-and-percentiles-are-great/)
- 因此，中位數（Median)相對於平均值，可以告訴我們更真實的狀況。
- 而[百分位數](https://zh.wikipedia.org/wiki/%E7%99%BE%E5%88%86%E4%BD%8D%E6%95%B0)則是與中位數類似，將一組數據從小到大排序，計算相應的累計百分點，則某百分點所對應數據的值，就稱為這百分點的百分位數，以Pk表示第k百分位數。百分位數是用來比較個體在群體中的相對地位量數。
- 他不會受到極端值的影響，因此可以作為設定閾值的目標，可以自由地調整百分位數的大小，來界定是否要包含極端值。