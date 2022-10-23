public:: true

- ## [Performance Golden Rule](https://www.stevesouders.com/blog/2012/02/10/the-performance-golden-rule)
	- 80-90% of the end-user response time is spent on the **frontend**
	- backend time might grow exponentially with the rise of **concurrent users**
	- If you’re worried about availability and scalability, focus on the **backend**
-
- ## 如何開始Load testing
	- 在所有的測試開始之前，要先使用[Smoke testing](https://k6.io/docs/test-types/smoke-testing/)。
	- 目的是確保：
		- 1. 你的測試程式沒有任何的錯誤
		- 2. 你要測試的系統，在最小的負載情況下，不會有任何問題
	- Load testing有分4種，可在[k6官網](https://k6.io/docs/test-types/)了解。
	- 在這邊使用的是**Load testing**，測試系統在一般情況與尖峰情況的效能反應。
	- 可以定義測試的一般與巔峰情況如：
		- **一般情況**：會去跑系統數個模組的主要回傳大量資料的API
		- **尖峰狀況**：系統中模組進行大量的資料介接上傳時。
	- 如果你的系統在負載測試之下出錯了，這代表你的附載測試變成了[壓力測試(Stress Testing)](https://k6.io/docs/test-types/stress-testing)。
	- ### 可接受的負載層級(Acceptable Load Level)
		- 在開始前會先了解要測試的系統，平均或是巔峰情況下的使用量，可以從Grafana近7天[http_request_in_flight指標](https://github.com/grafana/grafana/blob/main/pkg/middleware/request_metrics.go#L27-L33)了解。
		- ![Grafana近7天http_request_in_flight指標](https://i.imgur.com/VtZiYs0.png)
		- Grafana Dashboard裡面的圖表，都是用來設定**效能閾值**（Performance thresholds)的要素。
		- #### 虛擬用戶
		- 虛擬用戶(Virtual Users,VUs)的定義需要利用上述的 Grafana近7天 [http_request_in_flight指標](https://github.com/grafana/grafana/blob/main/pkg/middleware/request_metrics.go#L27-L33) 去定義
		- NIS 在某些不知名的原因會有 500 多個 concurrent user（極端狀況，待查證），一般時候的concurrent user，大多都在25左右，尖峰時期則約50。
		- #### 閾值（[Thresholds](https://k6.io/docs/using-k6/thresholds/))
		- 測試中，系統必須要通過/失敗的效能準則，也可以自定義要測試的指標。
		- 例如：
			- 系統不能產生 1% 以上的錯誤
			- 95% 請求的回應時間應該要在 200ms 內
		- 那到底要如何決定指標的數字呢？
		- > 忽略無意義的異常值，關切有意義的峰值。
		- 在這邊測試定義一些比較基準的指標：
			- 1. http 錯誤應該要低於 1%
			- 2. 99% 的 http 請求響應時間應該要低於 5 秒
			- 3. 95% 的 http 請求響應時間應該要低於 3 秒（NIS API 回應的平均時間）
		- 另外需要從 Grafana 去觀察系統：
			- 1. CPU Usage 是否超過 50%： 根據儀表板的監測與使用者反應，50%以上的CPU Usage會開始讓使用者體驗開始變差
			- 2. Heap Memory Usage沒有逐漸上升：代表有 [Memory leak](https://en.wikipedia.org/wiki/Memory_leak#:~:text=In%20computer%20science%2C%20a%20memory,accessed%20by%20the%20running%20code.)
		- #### 期間 （Duration）
			- **期間**是每個階段的測試時間長短。
			- 要定義出期間，k6提供很方便的方法，使用[k6 Chrome插件](https://chrome.google.com/webstore/detail/k6-browser-recorder/phjdhndljphphehjpgbmpocddnnmdbda?hl=en)，實際去系統上走一回要跑的 User flow，參考其中 Duration 測試參數及分鐘數。
		- #### 定義測試階段([Stages](https://k6.io/docs/using-k6/options/#stages))
			- 了解了以上兩個名詞後，可以設定此次的Load testing階段的數值。
			- Stage的定義是在特定的時間內，使用指定的VU數量去緩慢地增加或減少，來進行測試。
			- > A list of VU ·{ target: ..., duration: ... }· objects that specify the target number of VUs to ramp up or down to for a specific period.
			- | Stage/Value  | Stage 1 | Stage 2 | Stage 3 |
			  |------------|---------|---------|---------|
			  | VU           | 50      | 50      | 0       |
			  | Duration     | 1min    | 3m30s   | 1min    |
			- Stage 1: 花費1分鐘從 0 VU --> 50 VU
			- Stage 2: 花費3分半保持在 50 VU
			- Stage 3: 花費1分鐘從 50 VU --> 0 VU
	- ## Q&A
		- 以下是一些在看測試script或是寫報告時產生的疑問，邊寫邊被鞭，才發現報告其實並沒有想像中簡單😅
		- ### `sleep()`
			- 使用方式如：
			- ```js
			  sleep(1)
			  ```
			- #### why `sleep`?
				- `sleep`是[k6建議](https://k6.io/docs/using-k6/test-life-cycle/#the-default-function-life-cycle)的，是在模擬使用者在瀏覽該頁面的時間，也**避免測試變得太具攻擊性**。
			- #### 那要設定幾秒呢？
				- 可以用[k6的瀏覽器套件](https://chrome.google.com/webstore/detail/k6-browser-recorder/phjdhndljphphehjpgbmpocddnnmdbda?hl=en)錄製我的瀏覽路徑，並實際去切換各個模組，來看它自動錄製的script幫我設定sleep多少秒
			- #### 會影響response time的統計結果嗎？
				- > sleep(2) 摳了 5 次，會影響 response time 的統計結果嗎?
					- [sleep 不會影響到他的testing script的執行時間](https://community.k6.io/t/how-sleep-impacts-overall-duration-of-the-test/404/2)，而是會影響每個`VU`在`iteration`內，總共會發出`request`的次數（因為`sleep`了）。
					- [response time等同於request time](https://app.k6.io/runs/public/5437f8d7f6c743c2ba3307d173f9003e)，在[文件中](https://k6.io/docs/javascript-api/k6-http/response/)（`Response.timings.duration`）則是定義為發出請求的`送出、等待、收到`的時間加總
			- 使用簡單的script在cloud上面實驗，有sleep反而response time比較短，應該是因為server沒超級頻繁的req被打爆（？）。
				- [no sleep](https://app.k6.io/runs/public/1e860cde7c3444e9869ba7f087b6de1b)
				- [sleep(1)](https://app.k6.io/runs/public/5437f8d7f6c743c2ba3307d173f9003e)
		- ### 百分位數（Percentile）是什麼？
		  id:: d30a2198-257a-4b35-9f68-c95fc8705b0d
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
		- ### 如何擷取某個持續VU時段的資料？
			- 為了讓我們可以在`k6`的儀表板上面擷取某個VU的持續時段，k6有提供已經定義好的情境（scenarios）執行引擎（executors），因此使用[ramping vus](https://k6.io/docs/using-k6/scenarios/executors/ramping-vus/)。
			- #+BEGIN_NOTE
			  **ramping VUs**
			  A variable number of VUs execute as many iterations as possible for a specified amount of time
			  #+END_NOTE
			- 在`options`內加上`scenarios`以及`executor: "ramping-vus"`就可以使用該執行引擎。
			- ```js
			  export const options = {
			    scenarios: {
			      nisLoadTesting: { // name of scenario
			        executor: "ramping-vus", // add this
			        startVUs: 0,
			        stages: [
			          { duration: "1m", target: targetVUs }, // simulate ramp-up of traffic from 1 to 50 users over 1 minutes.
			          { duration: "3m30s", target: targetVUs }, // stay at 50 users for 5 minutes
			          { duration: "1m", target: 0 }, // ramp-down to 0 users
			        ],
			      },
			    },
			  };
			  ```
			- ![scenario 內可以選取時間區段](https://i.imgur.com/fnb1Z9G.png)
			- 在 k6 儀表版中，就可以在 scenario 內可以選取時間區段，來計算出該時段的數值。
		- ### Response time 可以 grouping 嗎？
			- response time[使用 tree view 去看](https://app.k6.io/runs/public/b34ee5641e664d9a9250a9f24e845a60?viewType=tree)，就可以看到 grouping 後的統計結果。
- ## Reference*
- [Analysis of Load Test Results](https://www.ecanarys.com/Blogs/ArticleID/242/Analysis-of-Load-Test-Results)
- [How to interpret your load test results](https://k6.io/blog/how-to-interpret-your-load-test-results/#:~:text=By%20definition%20VU%20Load%20Time,probably%20get%20results%20in%20milliseconds.)
- [Why averages suck and percentiles are great](https://www.dynatrace.com/news/blog/why-averages-suck-and-percentiles-are-great/)