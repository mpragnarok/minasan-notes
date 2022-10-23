public:: true
title:: B: Functional programming 到底在幹嘛

- type:: [[articles]]
  tags:: Functional-Programming, FP
  date:: 
  author:: #@Me
  link::
	- Why look up?
		- sharing knowledge
		- Know why we should use FP
	- Basic description
		- 資料概念化
	- Any major takeaways?
		- 每種 Paradigm 都有其好壞，應該視使用情境去選擇
-
- > 以下為 [What's Functional Programming All About?](https://www.lihaoyi.com/post/WhatsFunctionalProgrammingAllAbout.html#what-functional-programming-is-not)的精簡版
  
  **到底 FP 跟Imperative Programming有什麼差別？**
  
  很多人會誤以為FP單純只是將雜亂無髒的code，塞進helper function而已。
  
  ![https://i.imgur.com/Fy6R7GX.jpg](https://i.imgur.com/Fy6R7GX.jpg)
  
  Imperative 命令式著重在 HOW，具體表達程式碼該做什麼才能達到目標，程式一步一步按著順序照著你給他指示執行。
  Declarative 宣告式著重在該做什麼 WHAT ，並採取抽象化流程。
- ### Imperative Recipes
  
  當我們要做一個提拉米蘇時，上網查到一個[提拉米蘇食譜](http://www.cookingforengineers.com/recipe/60/The-Classic-Tiramisu-original-recipe)，他的詳細步驟如下：
  
  1. Begin by assembling four large egg yolks, 1/2 cup sweet marsala wine, 16 ounces mascarpone cheese, 12 ounces espresso, 2 tablespoons cocoa powder, 1 cup heavy cream, 1/2 cup granulated sugar, and enough lady fingers to layer a 12x8 inch pan twice (40).
  
  2. **Stir** two tablespoons of granulated sugar into the espresso and put it in the refrigerator to chill.
  
  3. **Whisk** the egg yolks
  
  4. **Pour** in the sugar and wine and whisked briefly until it was well blended.
  
  5. **Pour** some water into a saucepan and set it over high heat until it began to boil.
  
  6. Lowering the heat to medium, place the heatproof bowl over the water and stirred as the mixture began to thicken and smooth out.
  
  7. **Whip** the heavy cream until soft peaks.
  
  8. **Beat** the mascarpone cheese until smooth and creamy.
  
  9. **Poured** the mixture onto the cheese and beat
  
  10. **Fold** in the whipped cream
  
  11. **Assemble** the tiramisu.
	- Give the each ladyfinger cookie a one second soak on each side and then arrange it on the pan
	- After the first layer of ladyfingers are done, use a spatula to spread half the cream mixture over it.
	- Cover the cream layer with another layer of soaked ladyfingers.
	- The rest of the cream is spread onto the top and cocoa powder sifted over the surface to cover the tiramisu.
	  
	  12. The tiramisu was now complete and would require a four hour **chill in the refrigerator**.
	  
	  以下是簡易版的Python版本的食譜，請忽略使用同個function去處理不同的型別的參數：
	  
	  ```python
	  def make_tiramisu(eggs, sugar1, wine, cheese, cream, fingers, espresso, sugar2, cocoa):
	   dissolve(sugar2, espresso)
	   mixture = whisk(eggs)
	   beat(mixture, sugar1, wine)
	   whisk(mixture) # over steam
	   whip(cream)
	   beat(cheese)
	   beat(mixture, cheese)
	   fold(mixture, cream)
	   assemble(mixture, fingers)
	   sift(mixture, cocoa)
	   refrigerate(mixture)
	   return mixture # it's now a tiramisu
	  ```
-
- ### Kitchen Refactoring
  
  跟所有的命令式的程式碼（imperative code）一樣，他會正常運作，但他可能會比較難深入地讀懂或難以refactor。例如，在你在料理時，你可能會有以下的問題：
- 當我有兩個人去做提拉米蘇，哪些部分我可以同時完成？
- 我的espresso還沒抵達，我可以把其他步驟提前準備，並將espresso的步驟往後移，等他到之後再做呢？
	- 如果我的蛋還沒有到呢？哪些步驟我可以在沒有蛋的情況下做？
- 在第9步，你把所有東西灑到地板上了。哪些步驟你需要重做，並且哪些材料你需要重新購買？
	- 如果是在第10步或第8步，我手滑把碗掉到地上呢？
- 在第10步之前，你忘記做第7步。你毀了哪些食材？
	- 如果是忘記第4步？或第2步？
	  
	  以上四種狀況，時常發生在廚房當中，也時常在你寫code時發生：
- 在cpu上平行化同時執行任務，讓整體的執行速度變快
- 更改程式碼的執行順序
- 處理錯誤或例外情況
- 處理bugs
  
  當然食譜只有12個步驟，仔細看後並不會很難去思考出以上的答案。
  
  但是在大型專案中，要思考出以上答案，可能要花許多時日才能找到。
  
  問題不是在要找到[方法](https://medium.com/wenchin-rolls-around/node-js-%E7%9A%84%E5%AD%90%E7%A8%8B%E5%BA%8F%E6%A8%A1%E7%B5%84-child-process-196529aacfdd)，去讓Nodejs在不同程序 (process)跑程式邏輯－而是在你不夠瞭解程式碼的情況下，去決定哪些要跑在其他程序上。
  
  要把程式碼移到不同的程序去跑，必須要了解每一段code，要選取最小dependencies的程式碼。當有的是一大堆imperative code，這將會非常難達到，原因是：
- 步驟之間有順序性，但是並不是每個步驟都需要這個順序性
	- 例如在9~11步的順序是固定以外，  其他步驟匙順序是任意的，可以將步驟2放到步驟11任何的位置之前完成，步驟7、8可以交換或更早完成，怎樣都行
- 食譜是建立在物品狀態(state of things)的變化之上
	- 例如，將東西到進去`混合物` (`mixture`)，即便混合物已經在不同步驟當中，代表不同的物質了。
	- 甚至`起司（cheese）`和`奶油（cream）`也會隨著食譜的步驟，代表不同的意義（像是`whip(cream)`），但這些意涵，都被隱藏在程式碼當中。
	  
	  總而言之，這些原因都會導致難以了解，給定一個步驟S之下，S依賴於哪些步驟，以及其他哪些步驟依賴於S。
	  
	  在16行的提拉米蘇食譜，是有可能弄清楚的，但是在1百萬行的程式碼當中，要搞清楚是極其困難的。
	  
	  那到底Functional Programming Recipes長什麼樣子？
- ### Functional Programming Recipes
  
  以下是簡化版的步驟流程圖，這便是我們要如何將食譜FP化。
  
  最左邊是食材，每一個方格代表單一的操作，將食材混合。當所有食材全部混合在一起時，提拉米蘇就完成了。等一下會證實，這張圖的架構不會與FP程式碼相差甚遠。
  
  ![https://i.imgur.com/hCkulhp.png](https://i.imgur.com/hCkulhp.png)
  
  這張圖簡化了一些imperative recipe提供的詳細訊息，像是冷卻espresso或煮沸水的步驟都被忽略了。
  
  但是必須完成提拉米蘇的簡略步驟都一一列出，並且簡略步驟後的詳細指令，都一樣有被列出。沒有將部份步驟，隱藏在這些簡略版的步驟當中。
  
  這張圖的內容，都與imperative instruction-list列的都一樣，那到底它有什麼差別？
- ### Tiramisu Diagram to Functional Programming
  
  雖然並沒有人會真的將自己的程式碼的架構，畫成這樣的2D 圖表，但是這張圖表卻表達了每個要素之間的關係：
  
  ![https://i.imgur.com/sbEKUJO.png](https://i.imgur.com/sbEKUJO.png)
  
  每個格子都會從左方接收一些Input，並且向右產出Output。可以將每個格子直接想像成functions，以下是Python寫成的：
  
  ```Python
  def make_tiramisu(eggs, sugar1, wine, cheese, cream, fingers, espresso, sugar2, cocoa):
                 
  return refrigerate(
      sift(
          assemble(
              fold(
                  beat(
                      whisk( # over steam
                          beat(beat(eggs), sugar1, wine)
                      ), 
                      beat(cheese)
                  ), 
                  whip(cream)
              ), 
              soak2seconds(fingers, dissolve(sugar2, espresso))
          ), 
          cocoa
      )
  )
  ```
  
  你可能會想說，蝦小，這段code到底哪裡像那張圖了？
  
  （同樣地，在這裡一樣先忽略一直將同個function處理不同的參數）
  
  但當我們將他的資料流畫上去時，就可以看出每個input與ouput的流向，以及他們最終都導向同一個結果，即便他的流向跟2D圖不太一樣，但在基礎上，兩個圖面是一樣的。
  
  ![https://i.imgur.com/OIwna3m.png](https://i.imgur.com/OIwna3m.png)
  
  龜派氣功的寫法，是我們不會一直想要在code base裡面看到的形式。
  
  因此我們增加了參數命名改寫了一下：
  
  ```Python
  # FP         
  def make_tiramisu(eggs, sugar1, wine, cheese, cream, fingers, espresso, sugar2, cocoa):
    beat_eggs = beat(eggs)
    mixture = beat(beat_eggs, sugar1, wine)
    whisked = whisk(mixture)
    beat_cheese = beat(cheese)
    cheese_mixture = beat(whisked, beat_cheese)
    whipped_cream = whip(cream)
    folded_mixture = fold(cheese_mixture, whipped_cream)
    sweet_espresso = dissolve(sugar2, espresso)
    wet_fingers = soak2seconds(fingers, sweet_espresso)
    assembled = assemble(folded_mixture, wet_fingers)
    complete = sift(assembled, cocoa)
    ready_tiramisu = refrigerate(complete)
    return ready_tiramisu
  ```
  
  我們來看看之前的Imperative版本
  
  ```Python
  # Imperative
  def make_tiramisu(eggs, sugar1, wine, cheese, cream, fingers, espresso, sugar2, cocoa):
    dissolve(sugar2, espresso)
    mixture = whisk(eggs)
    beat(mixture, sugar1, wine)
    whisk(mixture) # over steam
    whip(cream)
    beat(cheese)
    beat(mixture, cheese)
    fold(mixture, cream)
    soak2seconds(fingers, espresso)
    assemble(mixture, fingers)
    sift(mixture, cocoa)
    refrigerate(mixture)
    return mixture # it's now a tiramisu
  ```
- #### Imperative與FP的兩段code看起來十分相似，那他們到底有什麼差別？
- FP 的 snippet 中，可以清楚看到`beat(cheese)`一定會出現在`beat(whisked, beat_cheese)`之前，因為`beat_cheese`是來自於`beat(cheese)`。即便你不清楚`beat`, `cheese` 或 `whisked`是什麼，這段程式碼一樣很清楚地闡述他在做什麼
- Imperative 的 snippet 中，`beat(cheese)`需要被放在`beat(mixture, cheese)`之前嗎？或是相反？這時我們必須花時間回去看食譜，看這兩者之間的關係
- ### Preventing Errors with Functional Programming
  
  當我們想嘗試更改上面兩段`# FP` 與 `# Imperative` 程式碼時呢？
  
  改程式碼是我們每天在做的事情，有時候還會改錯生出蟲來。
  若是程式碼的錯誤可以更容易被看出來呢？
  當我們隨意移動FP的程式碼時，有錯誤時，linter就會馬上提醒。
  把 `beat_cheese`移動到`cheese_mixture`之下
  
  ```python
  cheese_mixture = beat(whisked, beat_cheese)
  beat_cheese = beat(cheese)
  
  ```
  
  
  但當我們移動 imperative 的程式碼，每個function並不會傳出下一個function須要使用的資訊，即便錯了也不會有提醒，通常都要到compile或是test後才會知道。
  
  ![https://i.imgur.com/IdATmPY.png](https://i.imgur.com/IdATmPY.png)
  
  當程式碼是這樣：
  
  ```Python
  def initialize():
   ... 1000 lines of messy code, no return value...
   
  def make_app():
   ... 2000 lines of messy code, no return value...
  
  def start_server():
   ... 4000 lines of messy code, no return value...
  ```
  
  每一個function之間沒有關聯性，要怎麼知道`start_server()`在`initialize()`之前執行的情況下，他到底在`make_app()`之前執行還是之後呢？
- ### Refactoring a Functional Tiramisu Recipe
  
  回到剛剛前面提到的問題
  
  >當我有兩個人去做提拉米蘇，哪些部分我可以同時完成？
  
  用剛剛前面繪製的2D流程圖看，就會變得很簡單：
  
  ![https://i.imgur.com/qDjZ0N8.png](https://i.imgur.com/qDjZ0N8.png)
  
  每一個垂直分割的方格的部分，都代表可以同時完成的工作。
  當你有三個人時，就可以分配成：
- 一個人負責蛋/糖/酒的混合物
- 一個人負責馬斯卡彭起司/奶油
- 最後一個人負責espresso/拇指餅乾
  
  另一方面，水平排列的方格，代表著要被依序地完成：
  
  ![https://i.imgur.com/8zgjX0E.png](https://i.imgur.com/8zgjX0E.png)
  
  到底能省多少時間，則是可以用關鍵路徑法（[Critical Path](https://en.wikipedia.org/wiki/Critical_path_method)）所計算出。
  
  使用「FP」，並不會縮短關鍵路徑的時長，換句話說，就是並不會減少執行時間。但卻可以讓你知道，哪些部分可以同時進行，哪些部分不能，最大化同時進行任務的管理。
  
  再來，我們要回答下一個問題：
  
  > 我的espresso還沒抵達，我可以把其他步驟提前準備，並將espresso的步驟往後移，等他到之後再做呢？
  
  ![](/img/what-fp_7.png)
  
  同樣的，用這張圖也可以很好理解，只要是跟espresso有關的工作，都需要跳過，然而其他有材料的工作，在組裝前都可以先執行。
  
  > 如果我的蛋還沒有到呢？哪些步驟我可以在沒有蛋的情況下做？
  
  ![](/img/what-fp_8.png)
  
  在沒有蛋的狀況下，也一樣先把其他不需要用到蛋的任務先完成就好。
  
  > 在第9步，你把所有東西灑到地板上了。哪些步驟你需要重做，並且哪些材料你需要重新購買？
  
  第9步，我們將馬斯卡彭起司混入蛋的混合物。
  
  ![](/img/what-fp_9.png)
  
  一看就可以馬上知道，需要重新拿取新的蛋、起司、酒、糖以及重新將他們`beat/beat/whisk/beat`。
  
  >如果是在第10步或第8步，我手滑把碗掉到地上呢？
  
  ![](/img/what-fp_10.png)
  
  第10步是將打發鮮奶油混入主要的混合物，他其實也跟在第9步打翻時要做的事情一樣，除了要再拿取新的重鮮奶油(heavy cream)。
  
  ![](/img/what-fp_11.png)
  
  如果在第8步（打馬斯卡彭起司）打翻的話，你只需要拿取新的馬斯卡彭起司就好。
  
  > 在第10步之前，你忘記做第7步。你毀了哪些食材？
  
  ![](/img/what-fp_12.png)
  
  上圖可以看到，紅色圈選的地方代表已經完成了，第10步（翻動folding打發奶油）還沒做。而第7步（打發重鮮奶油）忘記做根本沒什麼，只需要把它完成，再繼續做第10步就好。
  
  > 如果是忘記第4步？或第2步？
  
  如果你忘記第四步（將酒與糖拌入打發的蛋），你會浪費蛋/糖/酒/起司：
  
  ![](/img/what-fp_13.png)
  
  如你所見，因為缺少了酒與糖，會導致梅納化學反應無法發生，因此我們必須將上面的紅匡內的所有步驟，全部重做。
  
  如果我們忘的是第二步驟（將糖溶解至espresso），並不需要重做，因為還不需要使用到它。
  
  ![](/img/what-fp_14.png)
  
  ---
  如上面舉例的狀況，我們可以輕易的使用FP形式的2D圖表，去應付許多問題。
  
  當然，現實生活是我們並不會繪製這樣的表格，去描述我們的程式邏輯。但我們可以使用FP的概念，將問題最小化、撰寫pure functions、在function內只handle資料處理的邏輯並將資料回傳出去，讓我們可以更輕易地在IDE內，就讓linter提示你程式邏輯有誤。
- ### The Core of Functional Programming
  
  **FP的核心概念是與其思考如何控制程式碼，不如思考資料流向。** FP可以強制將你的程式碼，規範在有順序地線性資料流向，
  
  ```Python
  def make_tiramisu(eggs, sugar1, wine, cheese, cream, fingers, espresso, sugar2, cocoa):
  beat_eggs = beat(eggs)
  mixture = beat(beat_eggs, sugar1, wine)
  whisked = whisk(mixture)
  beat_cheese = beat(cheese)
  cheese_mixture = beat(whisked, beat_cheese)
  whipped_cream = whip(cream)
  folded_mixture = fold(cheese_mixture, whipped_cream)
  sweet_espresso = dissolve(sugar2, espresso)
  wet_fingers = soak2seconds(fingers, sweet_espresso)
  assembled = assemble(folded_mixture, wet_fingers)
  complete = sift(assembled, cocoa)
  ready_tiramisu = refrigerate(complete)
  return ready_tiramisu
  
  
  ```
  
  ![](/img/what-fp_15.png)
  
  ![](/img/what-fp_16.png)
  
  當在單一執行序 (Single thread）執行「Functional Program」時，我們被迫選擇線性執行每一個獨立流程，我們或許會寫出跟上面列的一樣的程式碼順序。
  但我們已經知道真正重要的是**資料流向（Data-flow）**圖，就可以任意地去重新排列程式碼的狀態與執行順序。
  並且當你有**多核心**時（或多個廚師），你也可以任意地同時執行任何一部份，而不是線性的執行所有工作程序！
  
  **Functional Programming並不是將骯髒的程式碼隱藏在helper methods當中**，並期望沒有人會看到這些程式碼；而是**將所有的程式碼之間的關係列出來**，透過資料流向的特性，看到程式碼即可了解，傳入的參數以及回傳的數值，**使每段程式碼之間的關係，變得顯而易見**。
  
  這邊講解的只是FP最基礎的概念，當然還有之前提過的比較簡單（Immutability, referential transparency,...）以及進階(monad)的概念。不管你使用的是哪種語言（Scala, Clojure, Haskell或 React.js），這最基礎的資料流概念，應該是每個接觸FP的人都需要了解的。
  
  當然，這些進階概念並不會是用在這次的範例上，且廚房食材是容易變質的且易腐爛的。
  
  其實，也有我們在使用的套件，有用到FP的概念，其實我們也不知不覺地接觸到FP。
  
  像是:
  
  Redux
  
  > Redux is inspired by functional programming, and out of the box, has no place for side effects to be executed.
  > In particular, reducer functions _must_ always be pure functions of `(state, action) => newState`.
  > [Reference](https://redux.js.org/faq/actions#how-can-i-represent-side-effects-such-as-ajax-calls-what-do-we-need-things-like-action-creators-thunks-and-middleware-to-do-async-behavior)
  
  ReactiveX
  
  > ReactiveX is a combination of the best ideas from
  the Observer pattern, the Iterator pattern, and functional programming
  [Reference](https://reactivex.io/)
  
  WhatsApp也是透過Erlang來寫的，只聘用了50個工程師，來應對9億的使用者。
- ### 我對這篇文章的看法
- FP的寫法-pure function：
	- 明確地展現referential transparency 的特性
	- data永遠是immutable的狀態，前一個function，要回傳出後一個function要使用的資料
	- function都定義成pure function，減少side effects。
- Imperative的寫法：
	- Mutability的shared data會造成bug
	- 程式碼較難理解與維護，因為data會在不同地方/時間/方法被改變
	  
	  可能會想，那我應用pure function跟referential transparency的概念在imperative的寫法上，或是我將每個執行的function都有回傳結果並將他們命名到參數上，這樣不行嗎？
	  
	  可以，但是因為是沒有規範寫法的話，要怎麼寫都可以。FP的寫法具有強制性，幫助我們寫出簡短流程的函式，也會讓重複流程較容易被發現。
	  
	  :::info
	  **Referential Transparent 引用透明**
	  
	  An expression is called referentially transparent if it can be replaced with its corresponding value (and vice-versa) without changing the program's behavior.
	  
	  引用透明是指把一個函數可以用它的輸出值取代，並且整體程式的行為不變。
	  
	  由於純函數相同的輸入總是會返回相同的結果，這也保證了引用透明性。
	  
	  ```js
	  x = 2 + (3 * 4)
	  // replace `3 * 4` with `12`
	  x = 2 + 12
	  ```
	  
	  :::
- ## 結論
  
  之前在講OOP時，有它的好處，像是他可以將資料概念化，透過不同的pattern的應用，寫出我們程式要用的的藍圖；FP也有其的好處，專注於資料流、支援並行化程式（Parallel Programming）、減少Side effects。
  
  FP的出發點是immutable，他限制開發者不能隨心所欲的改變狀態，程式碼不會有迴圈，改為宣告式的遞迴寫法，也迫使開發者分解程式碼，抽取重複的函式或方法。
  
  結論是，不需要為了宣揚FP就屏棄OOP，兩者都了解的話，可以在需要使用FP的時候就使用FP，需要使用OOP的時候就使用OOP。
  
  還要看的話，可以看：<https://docs.microsoft.com/en-us/dotnet/standard/linq/functional-vs-imperative-programming>
- ## Reference
  
  * [What is difference between functional and imperative programming languages?](https://stackoverflow.com/questions/17826380/what-is-difference-between-functional-and-imperative-programming-languages)
- [What's Functional Programming All About?](https://www.lihaoyi.com/post/WhatsFunctionalProgrammingAllAbout.html#what-functional-programming-is-not)
- [Why WhatsApp Only Needs 50 Engineers for Its 900M Users](https://www.wired.com/2015/09/whatsapp-serves-900-million-users-50-engineers/ "www.wired.com")
- [為什麼要學 Functional Programming?](https://ithelp.ithome.com.tw/articles/10233399)