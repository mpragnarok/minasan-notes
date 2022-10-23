public:: true
type:: [[blogs]] 
assignee:: 
tags::
date:: [[Jun 7th, 2022]]
name::
hackmd:: https://hackmd.io/@minasan/prom-instrument-app

- ## 了解指標的意義在哪？可以用在哪？
	- ### Online service - RED method (Request, Errors, Duration)
		- > ((629cb50a-a921-485e-93a3-99bb6d43cb0a))
		- 不只可以用在 server side, 也可以用在 client side
		- 若 client 的延遲比 server 多，你或許遇到了網路問題或是客戶端過載
			- [查了一下](https://blog.carlosnunez.me/post/how-to-sre-ify-your-react-app-with-prometheus/)，前端也要instrument的話，需起 express server，本次要介紹的是 server side 的監控
	- ### Offline service - USE method (Utilisation, Saturation and Errors)
		- 離線服務，通常是批次處理工作，並且在 pipeline 有多個階段，如日誌處理系統（log processing system）。
			- Utilisation: 使用率，代表服務有多滿
			- Saturation：飽和度，代表排隊工作的數量
			- Errors：就是錯誤
		- 每個階段應該要有指標去紀錄：
			- 有多少排隊的工作
			- 多少的工作在處理中
			- 花多少時間消化工作
			- 發生的錯誤
	- ### 批次工作
		- 暫時性的服務，無法一直暴露 `/metrics` 給 prometheus
		- 需要push metrics 資料給 **Pushgateway** 讓 Prometheus 去爬
		- 需要紀錄
			- 花多少時間執行
			- 每個階段花多少時間消耗工作
			- 上個工作最後成功的時間
	- TODO keep reading ((629eb175-b7fb-4fb8-a24b-f382b0726b1d)) #work #here
- ## Instrumentation
  id:: 62923338-41a2-4b56-8ac1-b422fec24841
	- [小專案](https://github.com/mpragnarok/observability-start-up/tree/main/node-prom-metric)
		- 跑連接本地端 app 的儀表板 `cd observability-local-kit && make local-up`
		- 跑 instrumented server `cd node-prom-metric && npm start`
	- ### 如何在 application 暴露 metrics?
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
		    }),
		  );
		  // application endpoints
		  app.get("/", (req, res) =>
		    res.json({
		      "GET /": "All Routes",
		      "GET /hello": "{foo:bar}",
		      "GET /metrics": "Metrics data",
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
		  
		  // hello world rest endpoint
		  app.get("/foo", (req, res) => res.json({ foo: "bar" }));
		  
		  app.listen(8080, function () {
		    console.log("Listening at http://localhost:8080");
		  });
		  
		  ```
		- ![metrics exposed on port localhost:9090/metrics](https://i.imgur.com/HotKSts.png)
		- 到[http://localhost:9091/targets](http://localhost:9091/targets) 可以看到 prometheus 已經連接的 targets
			- ![https://i.imgur.com/6FBs7v4.png](https://i.imgur.com/6FBs7v4.png)
	- ### 指標類型
		- Counter: 累加(increment)
		- Gauge: 增加或遞減(increase and decrease)
		- Histogram: buckets
		- Summary: time windows
	- {{embed ((628a5bcb-5bc9-444e-af45-0eb42ac3d376))}}
	- ### Process level
		- 包含 CPU usage, Heap Usage, Memory Leak 等等的資訊
		- Instrumentation
			- 偷懶的做法-裝 [prom-client](https://www.npmjs.com/package/prom-client)：已經有 `process_cpu_***`、`nodejs_heap_space_size_***`、`nodejs_heap_size_***`等指標可以使用
			- 你也可以任性不用別人做好的，自己寫個 [Prometheus exporter](https://prometheus.io/docs/instrumenting/writing_exporters/) 😲
				- 或使用 [Node exporter](https://github.com/prometheus/node_exporter) 去監測硬體與 Kernel 的指標
	- ### Application level
		- 會想知道在不同的 API endpoint 的 HTTP request duration，上面也有好幾個關於 Application Level 的範例
		- Instrumentation
			- 偷懶的做法-裝 [express prometheus bundle](https://www.npmjs.com/package/express-prom-bundle) 直接幫你包好做完
			- 自己寫: [prom-client](https://www.npmjs.com/package/prom-client) + [response-time](https://www.npmjs.com/package/response-time)
	- ### 結論
		- 484 覺得很麻煩？不需要自己寫基本的 RED method instrumentation! 👉👉👉**安裝並使用 [ms-go-kit](https://gitlab.smart-aging.tech/devops/ms-go-kit) & [ms-node-kit](https://gitlab.smart-aging.tech/devops/ms-js-kit) 就對了！**
		-
