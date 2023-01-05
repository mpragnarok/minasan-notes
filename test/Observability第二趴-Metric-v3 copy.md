public:: true
title:: Observability第二趴-Metric-v3

- type:: [[blogs]] 
  assignee:: 
  tags:: observability
  date:: [[May 28th, 2022]]
  name:: Observability第二趴-Metric_v2
  hackmd:: https://hackmd.io/@minasan/HJoX_Jbdc
- #+BEGIN_PRIVATE
- 前半部概念性講一下為什麼需要，及我們目前採納的 tack stack 長怎樣 (architecture view)
  loki arch
  prom arch
  jaeger arch
- 後半部針對 metrics，demo 實際上要在程式碼裡動什麼手腳 (instrumenting)
  針對 process level 的 metrics 我們怎麼做 (埋梗動手造輪會怎麼做、或直接講使用 prom-client 包好直接 call)
  針對 application level 我們可能關心的是什麼、怎麼量測 (demo 一個簡單地 HTTP request time 怎量)
  收尾可收在大部分的基本需求已經被實作在 ms-go-kit & ms-node-kit 裡，但我們未來仍然等針對特殊的業務需求去客製化 metrics
- #+END_PRIVATE
- ## 可觀測性 Observability {{renderer :wordcount_bvsifik}}
	- ![3 pillars of Observability](https://i.imgur.com/Zlmx7Bu.png)
		- [3 pillars of Observability](https://www.oreilly.com/library/view/distributed-systems-observability/9781492033431/ch04.html#:~:text=Logs%2C%20metrics%2C%20and%20traces%20are,ability%20to%20build%20better%20systems.)
	- 為什麼需要可觀測性？
		- 當我們的服務越來越多時，Debug 也越來越難，服務之間的溝通發生問題要如何找到？即便程式寫的好棒棒，也可能發生：
			- 某個 pod 掛掉
			- 網路連線 timeout
			- 溝通的服務出事啦~~（中衛外包的介接上傳系統...?）~~
			- 或是程式真的有 bug
		- 發生以上這些問題時，要在影響客戶、公司名譽或系統效能之前 ASAP 地修正它，但這些過去發生的事情要怎麼找起？
		- 所以，需要了解發生問題時/前，你的系統出了什麼事
	- 一個好的觀測系統需要可以解釋以下的問題
		- 為什麼 `y` 壞了？
		- 當發佈了 `x` 版本時，什麼東西出錯了？
		- 為什麼系統效能在過去幾個月越來越差了？
		- Issue 影響了部分還是全部的使用者？
	- 可觀測性包含
		- ((aef28170-0b76-405f-a62a-9b43cb4663ff))
		  collapsed:: true
			- ((1f21c33c-fef6-4f10-b0d9-a08505e974e5))
		- ((86d79d00-9f0a-407b-bdf2-6f1e5c12b678))
		  collapsed:: true
			- ((f3eac3f7-1fb3-46a8-b3a1-1def92a7c9a6))
		- ((83bf0e06-45e9-4221-910a-6f3c67669ce3))
		  collapsed:: true
			- ((fbbd2168-02c2-427f-8caa-159b362b7a88))
	- 那 Jubo 的 Observability tech stack 是什麼？
		- ![https://i.imgur.com/iMXuBvn.png](https://i.imgur.com/iMXuBvn.png)
		  collapsed:: true
			- Loki
			- Prometheus
			- Jaeger
	- {{embed ((62923341-90b4-4a59-a508-f8425f68afc3))}}
	-
	- {{embed ((628a5bcb-1aeb-4e86-b4ed-825a2c23b69b))}}
	- ### Jaeger architecture
		- https://www.jaegertracing.io/docs/1.34/architecture/#:~:text=The%20Jaeger%20agent%20is%20a,collectors%20away%20from%20the%20client.
		- #### 專有名詞
		  collapsed:: true
			- ((7756d2ab-7bb2-4464-8f5f-6c7220736b26))
			- {{embed ((db8c13c5-65db-41eb-af73-13295a3bda24))}}
			- ![https://i.imgur.com/Fsl3awo.png](https://i.imgur.com/Fsl3awo.png)
		- {{embed ((d8fa0319-eb2b-41ca-bd7e-649601d9de49))}}
	- #### [Components](https://www.jaegertracing.io/docs/1.34/architecture/#components)
		- 兩種 Deployment options
		- ![https://i.imgur.com/6sFFDjP.png](https://i.imgur.com/6sFFDjP.png)
		  collapsed:: true
			- [source](https://www.jaegertracing.io/docs/1.34/architecture/#components)
		- **Jaeger-client**
			- 有各種語言的 libraries ，功能是創立 span
			- Jaeger 未來會採用 OpenTelemetry，官網目前有 [experimental 版本](https://www.jaegertracing.io/docs/1.21/opentelemetry/)
				- OpenTelemetry是一個開源專案，可以讓你蒐集與輸出 traces, logs 以及 metrics
				- 好像很酷，都是 Tracing 的部分已經完成，但 Logs, Metrics 在 Alpha 或 Roadmap 狀態，之後可以玩玩看，有 [js](https://opentelemetry.io/docs/instrumentation/js/) 與 [Golang](https://opentelemetry.io/docs/instrumentation/go/) 版本
			- ![context propagation](https://i.imgur.com/ADgYYiV.png)
				- [source](https://www.jaegertracing.io/docs/1.34/architecture/#jaeger-client-libraries)
			- 那要怎麼神奇地做到建立 span 呢？
				- [Istio 好棒棒](https://istio.io/latest/about/faq/distributed-tracing/#how-to-support-tracing)，裡面使用的 Envoy 都幫你做好了，列舉我們有用到的，包含
					- `x-request-id`
					- `x-b3-traceid`
					- `x-b3-spanid`
				- 加上 [`response-time` package](https://www.npmjs.com/package/response-time) 計算 http request duration
			- 為了減少資源的使用，影響到程式的效能，會有抽樣（[Sampling](https://www.jaegertracing.io/docs/1.34/sampling/)）的行為去產生 trace span
				- [istio default](https://istio.io/v1.0/docs/tasks/telemetry/distributed-tracing/#trace-sampling) 是 **1 %**:  100 requests 會產生 1 筆 trace span
				- [Jaeger client](https://www.jaegertracing.io/docs/1.34/architecture/#jaeger-client-libraries) 則是 **0.1 %**:  1000 requests 會產生 1 筆 trace span
		- **Jaeger-agent**
			- Jaeger agent 是網路進程（Network Daemon），監聽來自 spans 以 UDP 的方式傳送的資料，並將資料批次傳送給 Jaeger collector
				- Daemon 是在背景運行的特殊進程，服務的提供都需要背景程式的運作，而 daemon 就是那隻程式。如：會執行定期排程服務的程式 `crond`（by [鳥哥](https://linux.vbird.org/linux_basic/centos7/0560daemons.php)）
		- **Jaeger-collector**
			- Jaeger collector 接收來自 agents 傳送的 traces，並在 processing pipeline 中處理
				- 驗證 validate
				- 加上索引 index
				- 轉換 transformations
				- 儲存store
			- Storage支援
				- Cassandra
				- Elastisearch
				- Kafka
		- **Jaeger-query**
			- 從 storage 取得 traces 並在 host UI 上顯示
- {{embed ((62923338-41a2-4b56-8ac1-b422fec24841))}}
-
- ## Related
	- [[如何在觀測本地部署的 application (Grafana, Prometheus, Loki)]]: 其實是 [[Observability第二趴-Metric-v2]] 的前身
	- [[Observability第二趴-Metric-v2]]
-