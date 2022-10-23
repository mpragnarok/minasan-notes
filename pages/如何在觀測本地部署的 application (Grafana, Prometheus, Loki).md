public:: true
type:: [[blogs]] 
assignee:: 
tags:: grafana, prometheus, lok
date:: [[May 14th, 2022]]
name:: 如何在觀測本地部署的 application (Grafana, Prometheus, loki)

- ## Why
	- 為了實作與了解 Prometheus, Loki 的機制
- ## Prerequisite
	- Docker compose
	- Application with Prometheus client, logging tool
		- Nodejs with
			- [prom-client](https://github.com/siimon/prom-client)
			- [winston](https://www.npmjs.com/package/winston)
		- Golang with
			- [zap](https://github.com/uber-go/zap)
			- [OpenCensus Go Prometheus Exporter](https://pkg.go.dev/contrib.go.opencensus.io/exporter/prometheus@v0.3.0#section-readme)
			  collapsed:: true
				- Export Prometheus metric
- ## Localhost Endpoints
	- 實在是太多東西糾結在一起了，在這邊先為大家整理一下
	- [Grafana](htttp://localhost:3000)
	- NIS 主系統
		- [前端](http://localhost:8000)
		- [後端](http://localhost:8000/api)
	- SDK/package
		- [prom-client](http://localhost:9090/metrics)：NIS 專案中 node-microservice-kit 加上去的
	- [Prometheus](http://localhost:9091)
	- Prometheus Exporter
		- [cadvisor](http://localhost:8081/metrics)
		- [Node_exporter](http://localhost:9100/metrics): 要在本地電腦裝才有
	- [Loki](http://localhost:3100)
- ## Prometheus {{renderer :wordcount_jxmrhzb}}
	- ### Prometheus 普羅米修斯是什麼？
	  id:: 628a5bcb-ae95-4f65-a0a4-4a665d0270eb
		-
		- > Prometheus 是一個事件監控與警報的開源軟體，使用 HTTP Pull model 在 Time series database （TSDB）中記錄了實時的指標，並且也有彈性好用的查詢以及 實時警報
		- HTTP
			- Pull (Default)
				- ![https://i.imgur.com/YwS0dt6.png](https://i.imgur.com/YwS0dt6.png){:height 325, :width 556}
			- Push (Pushgateway)
				- ![https://i.imgur.com/TDioVNh.png](https://i.imgur.com/TDioVNh.png)
	- ### Prometheus Architecture
	  id:: 628a5bcb-1aeb-4e86-b4ed-825a2c23b69b
		- ![https://i.imgur.com/zTfNCrg.png](https://i.imgur.com/zTfNCrg.png)
			- source: [Prometheus](https://prometheus.io/docs/introduction/overview/)
		- #### [Components](https://prometheus.io/docs/introduction/overview/#components)
			- Prometheus server
				- Retrieval: 定義了 Promethues 需要從哪些地方 Pull metrics，甚至是從 k8s
				- TSDB: Time series database 儲存至本地的 HDD/SSD
				- HTTP server: 建立本身的 Prometheus server exposes query endpoints，用於外界對 PromQL 發送撈資料的請求
			- **[Client libraries](https://prometheus.io/docs/instrumenting/clientlibs/)**
				- 在你的程式中透過 HTTP endpoint 定義並暴露內部的 metrics
			- **Pushgateway**
				- 目的：處理 short-lived job
					- 因為這些 job 的存在時長不足以去讓 Prometheus 去抓，因此 short-lived job 會將他們的 metrics 結果 push 至 **Pushgateway**
					- 可以只用 shell scripts 就好了，或是 client library，官方有列出 [Pushing metrics 的工具](https://prometheus.io/docs/instrumenting/pushing/#pushing-metrics)
					- Pushgateway 會再暴露這些 metrics 給 Prometheus
				- [什麼時候用 Pushgateway?](https://prometheus.io/docs/practices/pushing/)
					- 抓取服務層級（service-level）的批次工作的結果
						- 上次成功的時間
						- 執行時間
					- Read  more [PushgGateway Best practices - Batch jobs](https://prometheus.io/docs/practices/instrumentation/#batch-jobs)
				- **⚠️ 官方提醒使用 Push gateway 的痛點**
					- 多個 instances 對一個 Push gateway， Pushgateway 會變成 **Single point of failure** 以及 潛在的瓶頸
					- 損失 Prometheus 的自動檢查 instances 的  `up` metric
					- Pushgateway 不會去忘記任何 push 給他的 metric，當 instances 來來去去，過期的 instances 舊的 metric 會被保留在 Push gateway，並也會保存在 Prometheus
						- 為了要同步，必須使用 API 將 Pushgateway 中的過期 metrics 刪除
			- **特殊目的的 Exporter**
				- > **Exporter** 是導出 metrics 的第三方二進程的程式，用於暴露 Prometheus的指標，將非 Prometheus 支援的格式轉換成支援的格式
				- 目前我們系統有用到
					- ==[Kafka exporter](https://github.com/danielqsj/kafka_exporter)==: Event Center service 使用 Strimz 部署的 Kafka 就有[包含 Prometheus metrics](https://strimzi.io/docs/operators/latest/deploying.html#proc-metrics-kafka-deploy-options-str)
					- ==[Node Exporter](https://prometheus.io/docs/guides/node-exporter/)==: ((628a5bcb-d3ff-4ed2-bda2-514f3143e808))
					- ==[Cadvisor](https://prometheus.io/docs/guides/cadvisor/)==: ((628a5bcb-1826-4ea5-bdb5-69e3e16985a1))
				- 其他 DB 相關
					- [MongoDB exporter](https://github.com/dcu/mongodb_exporter)
					- [MongoDB query exporter](https://github.com/raffis/mongodb-query-exporter)
					- [PostgreSQL exporter](https://github.com/prometheus-community/postgres_exporter)
					- [Redis exporter](https://github.com/oliver006/redis_exporter)
					- [RabbitMQ exporter](https://github.com/kbudde/rabbitmq_exporter)
					- [RabbitMQ Management Plugin exporter](https://github.com/deadtrickster/prometheus_rabbitmq_exporter)
			- **AlertManager**
				- 接收來至 Prometheus Server 的 Alert event，並依據定義的 Notification 組態發送警報
					- ex: E-mail 與 Webhook 等等
					- 目前我們的系統是使用 Grafana 的 Notification channels 發送 alert 到 Slack
	- ### DONE [#A] Instrumented app example #here #work
	  :LOGBOOK:
	  CLOCK: [2022-05-28 Sat 17:10:51]--[2022-06-09 Thu 10:02:52] =>  280:52:01
	  :END:
		-
	- ### Metrics type 定義  {{renderer :wordcount_zhqjbssb}}
	  id:: 628a5bcb-5bc9-444e-af45-0eb42ac3d376
		- **累加指標 Counter**
			- id:: 629c088e-179b-49dc-a32b-222bce5f7ce5
			  > Counter 只能往上疊加或重置，有助於統計事件發生的次數
			- 可以用於追蹤某段特定程式碼路徑的執行頻率，如 API request 的統計、任務的完成次數、錯誤的次數等等
			- client lib
				- ```js
				  const express = require("express");
				  const app = express();
				  const metricServer = express();
				  const prom = require("prom-client");
				  const responseTime = require("response-time");
				  const Registry = prom.Registry;
				  const register = new Registry();
				  // register prometheus metrics
				  prom.collectDefaultMetrics({ register });
				  
				  // customized prometheus metrics
				  const foo_sales_total = new prom.Counter({
				    name: "foo_sales_twd_total",
				    help: "TWD made serving Foo service",
				  });
				  
				  register.registerMetric(foo_sales_total);
				  
				  // Setup server to Prometheus scrapes
				  metricServer.get("/metrics", async (req, res) => {
				    try {
				      res.set("Content-Type", register.contentType);
				      res.end(await register.metrics());
				    } catch (err) {
				      res.status(500).end(err);
				    }
				  });
				  // Set metric server
				  metricServer.listen(9090, function () {
				    console.log("Metric exposed at http://localhost:9090/metrics");
				  });
				  
				  //  foo endpoint
				  app.get("/foo", (req, res) => {
				    
				    foo_sales_total.inc(Math.random()); // increase counter
				    return res.json({ foo: "bar" });
				  });
				  
				  app.listen(8080, function () {
				    console.log("Listening at http://localhost:8080");
				  });
				  
				  ```
			- 可以加負數嗎？ Counter 加上負數時，會被認為是程式碼的使用錯誤，會拋出 error exception `Error: It is not possible to decrease a counter`。對 PromQL 來說，Counter 只能增加是很重要的。因為使用`rate()` 時，才不會將減少 (decrease) 誤會成重置。
			- Query Example
				- 在本地端 [Grafana 的 Prometheus 儀表板](http://localhost:3000/explore?orgId=1&left=%7B%22datasource%22:%22Prometheus%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22expr%22:%22rate(foo_sales_twd_total%7Bjob%3D%5C%22nis%5C%22%7D%5B1m%5D)%22,%22range%22:true,%22exemplar%22:true%7D%5D,%22range%22:%7B%22from%22:%22now-1h%22,%22to%22:%22now%22%7D%7D)中，可以使用 `rate(foo_sales_twd_total[1m])` 去看foo 每秒銷售額（台幣）
		- **測量指標 Gauge**
			- > Gauge 可以將數值上下加減，用於表現狀態的現況，
			- 用於呈現的範例
				- 並發的請求數量
				- 記憶體的使用情況
				- 排隊的數量
				- 活動的線程數（number of active threads）
				- 某紀錄上次被處理的時間
			- ![https://i.imgur.com/EOMlqDM.png](https://i.imgur.com/EOMlqDM.png)
				- [reference](https://grafana.com/docs/grafana/latest/visualizations/gauge-panel/)
			- 不應該將`rate()`與 `increase()` 搭配 Gauge 使用 ，原因是這兩個 function 是基於數值是持續上升的假設去計算的
			- Client lib
				- ```js
				  const express = require("express");
				  const app = express();
				  const metricServer = express();
				  const prom = require("prom-client");
				  const responseTime = require("response-time");
				  const Registry = prom.Registry;
				  const register = new Registry();
				  // register prometheus metrics
				  prom.collectDefaultMetrics({ register });
				  
				  // customized prometheus metrics
				  const queueSizeTotal = new prom.Gauge({
				    name: "queue_size_total",
				    help: "Jobs waiting to be processed in queue",
				    labelNames: ["queueName"],
				  });
				  register.registerMetric(httpRequestDuration);
				  register.registerMetric(fooSalesTotal);
				  register.registerMetric(queueSizeTotal);
				  
				  // Setup server to Prometheus scrapes
				  metricServer.get("/metrics", async (req, res) => {
				    try {
				      res.set("Content-Type", register.contentType);
				      res.end(await register.metrics());
				    } catch (err) {
				      res.status(500).end(err);
				    }
				  });
				  
				  // Set metric server
				  metricServer.listen(9090, function () {
				    console.log("Metric exposed at http://localhost:9090/metrics");
				  });
				  
				  app.get("/queue", (req, res) => {
				    const queueA = new Array(genRandomInteger(100)).fill("jobA");
				    const queueB = new Array(genRandomInteger(50)).fill("jobB");
				    const queueASize = queueA?.length;
				    const queueBSize = queueB?.length;
				    // jobs waiting in queue
				    queueSizeTotal.labels({ queueName: "a" }).set(queueASize);
				    queueSizeTotal.labels({ queueName: "b" }).set(queueBSize);
				    return res.json({ queueASize, queueBSize });
				  });
				  
				  app.listen(8080, function () {
				    console.log("Listening at http://localhost:8080");
				  });
				  
				  ```
			- [Query Example](http://localhost:3000/explore?orgId=1&left=%7B%22datasource%22:%22Prometheus%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22instant%22:true,%22range%22:false,%22exemplar%22:false,%22expr%22:%22queue_size_total%7Bjob%3D%5C%22nis%5C%22,queueName%3D%5C%22a%5C%22%7D%5B2m%5D%22%7D%5D,%22range%22:%7B%22from%22:%22now-1h%22,%22to%22:%22now%22%7D%7D)
				- ```
				  # 過去兩分鐘每秒平均 queue A 的 size 
				  queue_size_total{job="nis",queueName:"a"}[2m]
				  ```
		- **[直方圖 Histogram](https://prometheus.io/docs/concepts/metric_types/#histogram)**
			- > 對觀察結果進行抽樣（通常是請求時間或回覆size），並計入在可調整的 bucket 中
			- 會加上 label `le`（為該 bucket 的最大大小）
				- 每個 buket 都紀錄了該 bucket `le`之下的統計數據（包含了前一個數據中的樣本），也提供了所有觀察數值的總和(`le='Inf`)
			- 提供所有觀察值的總和
			- 用於請求或響應的持續時間、響應的大小(Response sizes)
			- ![直方圖與長條圖的差異](https://i.imgur.com/mVuypSP.png)
				- [source](https://medium.com/marketingdatascience/%E5%A6%82%E4%BD%95%E5%88%86%E8%BE%A8%E9%95%B7%E7%9B%B8%E8%BF%91%E4%BC%BC%E7%9A%84%E5%AD%BF%E7%94%9F%E5%85%84%E5%BC%9F-%E7%9B%B4%E6%96%B9%E5%9C%96-histogram-%E8%88%87%E9%95%B7%E6%A2%9D%E5%9C%96-bar-chart-%E4%B9%8B%E5%B7%AE%E7%95%B0-154602ac0ba6)
			- ![https://i.imgur.com/jQp3vBq.png](https://i.imgur.com/jQp3vBq.png)
				- [source](https://bryce.fisher-fleig.org/prometheus-histograms/#:~:text=Prometheus%20stores%20histograms%20internally%20in,value%20for%20a%20given%20timestamp.)
			- 在 Prometheus server side 處理
			- Prometheus 的直方圖是累計直方圖的數據
			- 命名為基本指標名稱 `<basename>` 加上後贅詞`_xxx`
				- 以累進長條圖來看，bucket 就是每一條長條圖的
				- **total sum**: 所有觀察數值的總數， 暴露為 `<basename>_sum`
				- **count**: 被觀察事件的數量，暴露為`<basename>_count`（與`basename>_bucket{le="+Inf"} ` 相同)
			- Client Lib
				- ```js
				  const express = require("express");
				  const app = express();
				  const metricServer = express();
				  const prom = require("prom-client");
				  const responseTime = require("response-time");
				  const { genRandomInteger } = require("./tools");
				  const Registry = prom.Registry;
				  const register = new Registry();
				  // register prometheus metrics
				  prom.collectDefaultMetrics({ register });
				  
				  // customized prometheus metrics
				  
				  
				  const httpRequestDuration = new prom.Histogram({
				    name: "http_request_duration_seconds",
				    help: "The http request duration in seconds",
				    buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
				    labelNames: ["route", "method", "statusCode"],
				  });
				  
				  register.registerMetric(httpRequestDuration);
				  app.use(
				    responseTime(function (req, res, time) {
				      const { statusCode } = res;
				      const { method, originalUrl } = req;
				      const duration = Math.round(time) / 1000;
				      httpRequestDuration.observe({ method, route: originalUrl, statusCode }, duration);
				      httpRequestDurationSummary.observe({ method, route: originalUrl, statusCode }, duration);
				    }),
				  );
				  // application endpoints
				  app.get("/", (req, res) =>
				    res.json({
				      "GET /": "All Routes",
				    }),
				  );
				  
				  // Setup server to Prometheus scrapes
				  metricServer.get("/metrics", async (req, res) => {
				    try {
				      res.set("Content-Type", register.contentType);
				      res.end(await register.metrics());
				    } catch (err) {
				      res.status(500).end(err);
				    }
				  });
				  // Set metric server
				  metricServer.listen(9090, function () {
				    console.log("Metric exposed at http://localhost:9090/metrics");
				  });
				  
				  // rest endpoints below...
				  
				  app.listen(8080, function () {
				    console.log("Listening at http://localhost:8080");
				  });
				  
				  ```
			- 使用 `histogram_quantile()` 函式去計算分位數（[quantiles](https://prometheus.io/docs/practices/histograms/#quantiles)）或聚合直方圖
				- 計算過去 10 分鐘內請求時間的第 90 個百分位（[percentile](((d30a2198-257a-4b35-9f68-c95fc8705b0d)))）：`histogram_quantile(0.9, rate(http_request_duration_seconds_bucket[10m]))`
				- ![一般直方圖與聚合直方圖](https://i.imgur.com/kuoscWv.png)
				- [NIS 儀表板有計算 r99 的 histogram 範例](https://release-grafana-nis.jubo.health/explore?left=%5B%22now-1h%22,%22now%22,%22Prometheus%22,%7B%22expr%22:%22histogram_quantile(%5Cn%20%200.99,%20%5Cn%20%20sum(%5Cn%20%20%20%20rate(http_request_duration_seconds_bucket%7Bapp%3D%5C%22nis%5C%22,%20route%3D~%5C%22%2Fapi%2F.*%5C%22%7D%5B5m%5D)%5Cn%20%20)%20by%20(le,%20route)%5Cn)%22,%22interval%22:%22%22,%22exemplar%22:false,%22datasource%22:%22Prometheus%22%7D%5D&orgId=1)
					- ```PromQL
					  histogram_quantile(
					    0.99, # 顯示 99 百分位
					    sum( # 蝦小?????
					      rate(http_request_duration_seconds_bucket{app="nis", route=~"/api/.*"}[5m])
					    ) by (le, route)
					  )
					  ```
					- 拆解來看
						- [平均五分鐘內的 HTTP 請求秒數 在 "nis" app 與 route 具有 `/api` 前綴的資料](https://release-grafana-nis.jubo.health/explore?orgId=1&left=%5B%22now-1h%22,%22now%22,%22Prometheus%22,%7B%22exemplar%22:true,%22expr%22:%22rate(http_request_duration_seconds_bucket%7Bapp%3D%5C%22nis%5C%22,%20route%3D~%5C%22%2Fapi%2F.*%5C%22%7D%5B5m%5D)%22%7D%5D)
						- ```promql
						  rate(http_request_duration_seconds_bucket{app="nis", route=~"/api/.*"}[5m])
						  ```
							- ![https://i.imgur.com/ia8EpHV.png](https://i.imgur.com/ia8EpHV.png){:height 136, :width 444}
						- [全部一起看就會是](https://release-grafana-nis.jubo.health/explore?left=%5B%22now-1h%22,%22now%22,%22Prometheus%22,%7B%22expr%22:%22histogram_quantile(%5Cn%20%200.99,%20%5Cn%20%20sum(%5Cn%20%20%20%20rate(http_request_duration_seconds_bucket%7Bapp%3D%5C%22nis%5C%22,%20route%3D~%5C%22%2Fapi%2F.*%5C%22%7D%5B5m%5D)%5Cn%20%20)%20by%20(le,%20route)%5Cn)%22,%22interval%22:%22%22,%22exemplar%22:false,%22datasource%22:%22Prometheus%22%7D%5D&orgId=1): 我們 nis 主系統的 api （只看 `/api/xxx`） 在 99 百分位內 的資料中，過去 5 分鐘每秒平均的 HTTP 請求秒數
						- ```PromQL
						  histogram_quantile(
						    0.99, # 顯示 99 百分位
						    sum( # 將上述資料加總，並 group by `le` 與 `route` 
						      rate(http_request_duration_seconds_bucket{app="nis", route=~"/api/.*"}[5m])
						    ) by (le, route)
						  )
						  ```
							- ![https://i.imgur.com/GJtz5ZC.png](https://i.imgur.com/GJtz5ZC.png)
		- **[Summary](https://prometheus.io/docs/concepts/metric_types/#summary)**
			- > 對觀察結果進行抽樣，並提供總計數和所有觀察值的總和，並計算出滑動時間窗口上，可設置的分位數
			- 用於總值很重要的值上，並且不需要像 histogram 一樣預先設定 bucket 數值，如 payload sizes、latencies （95% 百分位數的延遲）等等
			- 在 client-side 計算，意味著可能會影響到客戶的體驗，會被加上 label `quartile`（percentile，介於 0~1 之間）
			- 可以立刻使用`summary_http_response_duration_seconds{quartile="0.99"}` 去取得 P99 資料，但不能 apply functions，因為這些百分位數值是事先計算好的
			- 使用 summary 計算 average 的數值使用效能較少，因為已經事先計算好了，不需要額外的 aggregation。但相對地，要新增 `quartile`，也需要更改程式碼
				- Average: `_sum` / `_count`
				- ```promQL
				  rate(summary_http_request_duration_seconds_sum[5m]) / rate(summary_http_request_duration_seconds_count[5m])
				  ```
			- ![https://i.imgur.com/LfOAgGz.png](https://i.imgur.com/LfOAgGz.png)
				- [source](https://bryce.fisher-fleig.org/prometheus-histograms/#:~:text=Prometheus%20stores%20histograms%20internally%20in,value%20for%20a%20given%20timestamp.)
			- Client lib
				- ```js
				  const express = require("express");
				  const app = express();
				  const metricServer = express();
				  const prom = require("prom-client");
				  const responseTime = require("response-time");
				  const { genRandomInteger, delay } = require("./tools");
				  const Registry = prom.Registry;
				  const register = new Registry();
				  // register prometheus metrics
				  prom.collectDefaultMetrics({ register });
				  
				  // customized prometheus metrics
				  const fooSalesTotal = new prom.Counter({
				    name: "foo_sales_twd_total",
				    help: "TWD made serving Foo service",
				  });
				  
				  const queueSizeTotal = new prom.Gauge({
				    name: "queue_size_total",
				    help: "Jobs waiting to be processed in queue",
				    labelNames: ["queueName"],
				  });
				  
				  const httpRequestDuration = new prom.Histogram({
				    name: "http_request_duration_seconds",
				    help: "The http request duration in seconds",
				    buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
				    labelNames: ["route", "method", "statusCode"],
				  });
				  
				  // register summary metric
				  const httpRequestDurationSummary = new prom.Summary({
				    name: "summary_http_request_duration_seconds",
				    help: "The Summary of http request duration in seconds",
				    percentiles: [0.01, 0.1, 0.9, 0.99],
				    labelNames: ["route", "method", "statusCode"],
				  });
				  register.registerMetric(httpRequestDuration);
				  register.registerMetric(httpRequestDurationSummary);
				  register.registerMetric(fooSalesTotal);
				  register.registerMetric(queueSizeTotal);
				  app.use(
				    responseTime(function (req, res, time) {
				      const { statusCode } = res;
				      const { method, originalUrl } = req;
				      const duration = Math.round(time) / 1000;
				  
				      httpRequestDuration.observe({ method, route: originalUrl, statusCode }, duration);
				      httpRequestDurationSummary.observe({ method, route: originalUrl, statusCode }, duration);
				    }),
				  );
				  // application endpoints
				  app.get("/", (req, res) =>
				    res.json({
				      "GET /": "All Routes",
				    }),
				  );
				  
				  // Setup server to Prometheus scrapes
				  metricServer.get("/metrics", async (req, res) => {
				    try {
				      res.set("Content-Type", register.contentType);
				      res.end(await register.metrics());
				    } catch (err) {
				      res.status(500).end(err);
				    }
				  });
				  // Set metric server
				  metricServer.listen(9090, function () {
				    console.log("Metric exposed at http://localhost:9090/metrics");
				  });
				  
				  // rest endpoints below
				  app.get("/foo", async (req, res) => {
				    const ms = genRandomInteger(3) * 1000;
				    fooSalesTotal.inc(Math.random());
				    await delay(ms);
				    return res.json({ foo: "bar" });
				  });
				  app.get("/queue", (req, res) => {
				    const queueA = new Array(genRandomInteger(100)).fill("jobA");
				    const queueB = new Array(genRandomInteger(50)).fill("jobB");
				    const queueASize = queueA?.length;
				    const queueBSize = queueB?.length;
				    // jobs waiting in queue
				    queueSizeTotal.labels({ queueName: "a" }).set(queueASize);
				    queueSizeTotal.labels({ queueName: "b" }).set(queueBSize);
				    return res.json({ queueASize, queueBSize });
				  });
				  app.listen(8080, function () {
				    console.log("Listening at http://localhost:8080");
				  });
				  
				  ```
			- Query example
				- [過去五分鐘每秒平均 http request duration 秒數](http://localhost:3000/d/H83B0997k/playground?orgId=1&viewPanel=6)
					- ```PromQL
					  rate(summary_http_request_duration_seconds_sum[5m]) / rate(summary_http_request_duration_seconds_count[5m])
					  ```
				- [P99 http request duration](http://localhost:3000/d/H83B0997k/playground?orgId=1&viewPanel=10)
					- ```promQL
					  summary_http_request_duration_seconds{quantile="0.99"}
					  ```
		- [Summary vs Histogram](https://prometheus.io/docs/practices/histograms/#histograms-and-summaries)
			- 訊息量太多了，有興趣的可以去[官網](https://prometheus.io/docs/practices/histograms/#histograms-and-summaries)查看，直接列個總結
			- Summary 比 Histogram 還先出來的，官方目前都推薦Histogram
			- 使用 Histogram
				- 需要聚合（Aggregation）
				- 知道觀察值範圍和分佈
			- 使用 Summary
				- 無論值的範圍和分佈，需要**準確**的分位數
			- ![https://i.imgur.com/YO5JwXn.png](https://i.imgur.com/YO5JwXn.png)
				- [reference](https://www.timescale.com/blog/four-types-prometheus-metrics-to-collect/)
	- ### Prometheus Exporter
	  id:: 628a5bcb-8a80-4628-a94c-614f2ccc01d7
	  collapsed:: true
		- #### Node exporter
			- 監測 Server 硬體與 Kernel 的指標(server metric)，我們的 [on-premise 版本](https://gitlab.smart-aging.tech/sa/manifests/blob/98dc94fa82b9899cf87be747d5add6c460ab0957/on-premise/scripts/monitoring_tool_setup.sh) 裡面有裝
			  id:: 628a5bcb-d3ff-4ed2-bda2-514f3143e808
			- [官方安裝指南，不推薦使用 docker run 去裝它](https://prometheus.io/docs/guides/node-exporter/)
			- Node exporter在macOS 裝來玩看看，因為 m1 chip arm based 的關係，還去[搜尋了一下](https://github.com/prometheus/node_exporter/issues/2120#issuecomment-903853066)是不是可以裝來玩玩看
				- Brew install in M1 chip
					- ``` zsh
					  > brew install node_exporter
					  > brew services start node_exporter
					  > brew services
					  > brew services
					  Name          Status  User      File
					  mysql         none              
					  node_exporter started minahuang ~/Library/LaunchAgents/homebrew.mxcl.node_exporter.plist
					  postgresql    started minahuang ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
					  redis         started minahuang ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
					  ```
				- 在 terminal `curl http://localhost:9100/metrics` 就會看到他產生的 metrics
				- ``` zsh
				  > curl http://localhost:9100/metrics
				  # HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
				  # TYPE go_gc_duration_seconds summary
				  go_gc_duration_seconds{quantile="0"} 0
				  go_gc_duration_seconds{quantile="0.25"} 0
				  go_gc_duration_seconds{quantile="0.5"} 0
				  go_gc_duration_seconds{quantile="0.75"} 0
				  go_gc_duration_seconds{quantile="1"} 0
				  go_gc_duration_seconds_sum 0
				  go_gc_duration_seconds_count 0
				  //... more metrics
				  ```
				- 不想玩的話記得 `brew services stop node_exporter`
			- `prometheus.yml` 加上 `scrape_configs`
				- ``` yml
				  			  global:
				  			    scrape_interval: 15s
				  			  
				  			  scrape_configs:
				  			    - job_name: "nis"
				  			  
				  			      # Override global settings
				  			      scrape_interval: 5s
				  			  
				  			      static_configs:
				  			        - targets: ["host.docker.internal:9090"]
				  			    - job_name: node #node exporter
				  			      static_configs:
				  			        - targets: ['host.docker.internal:9100']
				  			  
				  ```
			- 替換掉原本 NIS 上面的
				- Process CPU Usage metrics query（來自 k8s）
					- ```
					  				  # USER CPU
					  				  (avg by (instance) (irate(node_cpu_seconds_total{mode="user"}[2m])) * 100)
					  				  # System PCU
					  				  (avg by (instance) (irate(node_cpu_seconds_total{mode="system"}[2m])) * 100)
					  ```
				- CPU Usage
					- ```
					  				  100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
					  ```
		- #### Cadvisor
			- 用於分析與公開運行資源的效能與資源的使用率(container metric)
			  id:: 628a5bcb-1826-4ea5-bdb5-69e3e16985a1
			- ⚠️  ~~萬惡的~~ **m1 chip**  使用[官方版本](https://prometheus.io/docs/guides/cadvisor/)會出現，[issue 內找到](https://github.com/oijkn/Docker-Raspberry-PI-Monitoring/issues/2#issuecomment-945070375)有人推薦 [zcube/cadvisor](https://github.com/ZCube/cadvisor-docker) ，經歷了一段迷惘的過程，終於在本地端成功跑起來了
			- ~~amd 版本應該不會有什麼問題，我也沒有 amd based CPU 的電腦所以就不管囉~~
			- ```
			  		  # 使用 label `name` 去 query
			  		  rate(container_cpu_usage_seconds_total{name="nis"}[5m])
			  ```
			- 到 [http://localhost:8081/docker/nis](http://localhost:8081/docker/nis) 可以看到 docker container 的狀態，`http://localhost:8081/docker/{name}` `name` 可以替換掉
			- [http://localhost:8081/metrics](http://localhost:8081/metrics) 可以看到暴露的 metrics，預設是 8080 port
- ## Provisioning
	- > Provisioning 讓你在啟動 Grafana 時，就會自動載入在 provisioning 中的資源，可以是 Dashboard, Datasource 或是 Notifier
	- ### Folder structure
		- ```zsh
		  provisioning
		  ├── dashboards
		  │   ├── NIS-localhost-template.json
		  │   ├── dashboard.yaml
		  │   └── node-app-template-job.json
		  ├── datasources
		  │   └── datasource.yaml
		  └── notifiers
		      └── slack.yaml
		  
		  3 directories, 5 files
		  ```
	- ### [Dashboard](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards) templates
		- 共用 templates [grafana-template](https://gitlab.smart-aging.tech/devops/grafana-template/-/tree/master/)
		- 可以移除 template 內的 `uid`，載入時會幫你新增
		- ```yaml
		  # dashboard.yaml
		  apiVersion: 1
		  
		  providers:
		  - name: 'Prometheus'
		    orgId: 1
		    folder: ''
		    type: file
		    disableDeletion: false
		    editable: true
		    options:
		      path: /etc/grafana/provisioning/dashboards
		  ```
	- ### [Datasource](https://grafana.com/docs/grafana/latest/administration/provisioning/#data-sources)
		- ```yaml
		  # datasources.yaml
		  apiVersion: 1
		  
		  # list of datasources that should be deleted from the database
		  deleteDatasources:
		    - name: Prometheus
		      orgId: 1
		  
		  # list of datasources to insert/update depending
		  # whats available in the database
		  datasources:
		    # <string, required> name of the datasource. Required
		  - name: Prometheus
		      # <string, required> datasource type. Required
		    type: prometheus
		      # <string, required> access mode. proxy or direct (Server or Browser in the UI). Required
		    access: proxy
		    # <int> org id. will default to orgId 1 if not specified
		    orgId: 1
		    # <string> url
		    url: http://prometheus:9090
		    # <bool> mark as default datasource. Max one per org
		    isDefault: true
		    version: 1
		    # <bool> allow users to edit datasources from the UI.
		    editable: true
		  ```
	- ### [Notifier](https://grafana.com/docs/grafana/latest/administration/provisioning/#alert-notification-channels)
		- Notifier 可以自訂 `uid`，在 Dashboard 的 `notifications` 可以直接指定該 `uid`，並啟動時會自動讀入
		- ```yaml
		  # slack.yaml # https://grafana.com/docs/grafana/latest/administration/provisioning/#alert-notification-channels
		  notifiers:
		    - name: local-pager
		      type: slack
		      uid: local-pager
		      org_id: 1
		      secure_settings:
		        url: https://hooks.slack.com/services/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
		  
		  delete_notifiers:
		    - name: local-pager
		      uid: local-pager
		      org_id: 1
		  
		  ```
- ## Loki #WIP 太...太多了
  collapsed:: true
	- Grafana Loki 是一個  Log 聚合工具且為功能俱全的日誌堆棧（logging stack）
	- #here
	- TODO [#C] Keep Writing Loki content from [here](https://grafana.com/docs/loki/latest/fundamentals/overview/ ) #work
	- ### Loki Architecture
	  id:: 62923341-90b4-4a59-a508-f8425f68afc3
		- ![https://i.imgur.com/Y9gdwqC.jpg](https://i.imgur.com/Y9gdwqC.jpg)
			- Promtail: logs collectors, 會在送給 Loki 之前將蒐集到的 logs 先做預處理（labeling, transforming and filtering logs）
			- Loki: Like Prometheus, but for logs
			- Grafana：用來作為 Loki 的 UI 展示
		- ####  Components
			- ![https://i.imgur.com/xumvjqm.png](https://i.imgur.com/xumvjqm.png)
			- ![https://i.imgur.com/EyUsouA.png](https://i.imgur.com/EyUsouA.png)
				- [source](https://grafana.com/docs/loki/latest/fundamentals/architecture/components/?src=blog&camp=timeshift_53)
			- **分配者 Distributor**
				- 有 Load balancer
				- 客戶端的資料使用 stream 的方式傳入，驗證後的 chunks，會被批次且並行化地傳至多個 Ingester
				- 驗證是否有 labels（像 Prometheus 一樣）
			- **消化者 Ingester**
				- Ingester 服務將 log data 寫入長期儲存的後端，目前 Loki改用 [Single Store](https://grafana.com/docs/loki/latest/fundamentals/architecture/#single-store) Loki ([boltdb-shipper](https://grafana.com/docs/loki/latest/operations/storage/boltdb-shipper/#single-store-loki-boltdb-shipper-index-type))，將 index 資料儲存在指定地方的 local  BoltDB 的 files 中，會將 index 資訊同步到指定的 shared object store，不再依賴 S3、Cassandra、BigTable 等 NoSQL 雲服務，讓未來橫向擴充更容易
				- 我們 Loki 安裝是使用 [Loki helm charts](https://github.com/grafana/helm-charts/blob/main/charts/loki/values.yaml)，會自動去建立 PersistentVolume，將 chunks 資料都存在 filesystem，index 則是 boltdb-shipper 在處理，並傳送到指定的 object store -  filesystem
			- **查詢器 Querier**
				- 使用 LogQL query language
				- 從 Ingesters 或 long-term storage 查詢 logs
				- 會先抓 ingester 裡面的 in-memory data，找不到才會去抓 backend store 裡的資料
				-
			- **Query Frontend**
				- 是個 optional 服務，提供查詢器的 API endpoint，可以加速讀取路徑
				- 將大的 queriers 分成較小的 queries，平行化地分開執行，並將取得結果拼接起來
				- 也支援 cache metric query，並在後續查詢結果中重複使用
				-
	- ### Docker-compose setup
		- ### TODO Loki config
		- ### TODO Promtail config
		- DONE setup loki following the [tutorial](https://www.youtube.com/watch?v=h_GGd7HfKQ8&feature=youtu.be&ab_channel=TechnoTim)
		- ### [Docker driver](https://grafana.com/docs/loki/latest/clients/docker-driver/#docker-driver-client) plugin
			- 使 Docker 可以 send logs 給 Loki
			- Installation
				- ```
				  # amd
				  > docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
				  # arm
				  > docker plugin install grafana/loki-docker-driver:arm-v7 --alias loki --grant-all-permissions
				  
				  ```
			- [Configure logging driver](https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/)，在這邊已經在 `docker-compose.yml` 裡面設置好 `logging`
				- ```yaml
				  # docker-compose.yml
				  nis:
				      image: gcr.io/jubo-pro/nis/nis:develop-d58e8bf7
				      container_name: nis
				      ports:
				        - 8000:8000
				        - 8080:8080
				        - 9090:9090
				      # 加上 logging  
				      logging:
				        driver: loki
				        options:
				          loki-url: "http://localhost:3100/loki/api/v1/push"
				      networks:
				        - grafana
				  ```
		- ### Query
			- 除了是 `container_name` 去 query app 以外，**LogQL** 語法可以參考[官方](https://grafana.com/docs/loki/latest/logql/)或 [NIS 雲端 logs 查詢教學 (Grafana Loki Logs)](https://docs.google.com/document/d/1Lz0B-A4yN3jjxi0Q1x_LTf8T_0p5E2b07_DUsgL-x8w/edit#)
			- ```LogQL
			  {container_name="nis"} | json | level = "info"
			  ```
- ## TODOs
	- DONE [#B] Add Loki in `tutorial-environment` docker-compose #work
	- LATER [#B] Add push gateway app implementation, [ref](https://eltonminetto.dev/en/post/2020-03-13-golang-prometheus/) #work
		- [ref2](https://github.com/evnsio/prom-stack)
	- TODO [#C] Research Loki and add into document #work
	- LATER  [#C] Research Jaeger and add into document #work #[[Obserability- 第三趴 Logging]]
	- DONE ~~count(count(container_memory_usage_bytes{app=“nis", }) by (pod_name)) to count deployed replicas~~
		- Not what I want
- ## Reference
	- [Prometheus pushgateway](https://kubedex.com/resource/prometheus-pushgateway/)
	- [Prometheus 官方文件](https://prometheus.io/docs/)
	- [官方 get started](https://grafana.com/docs/loki/latest/getting-started/)
	- [官方 github](https://github.com/grafana/loki)
	- [官方 webinar](https://grafana.com/go/webinar/getting-started-with-logging-and-grafana-loki/?pg=oss-loki&plcmt=quick-links)
	- [Introduction](https://blog.min.io/logging-grafana-loki-and-minio/)
	- [docker compose tutorial]( https://blog.min.io/how-to-grafana-loki-minio/)