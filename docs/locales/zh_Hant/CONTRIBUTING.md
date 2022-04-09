# 為 Klipper 做貢獻

感謝您對Klipper的貢獻！本文件介紹向 Klipper 貢獻改進的流程。

請參閱[聯繫頁面](Contact.md)來了解報告問題的資訊或聯繫開發人員的方法。

## 貢獻流程概述

對Klipper的貢獻通常遵循一個高水平的流程：

1. 當提交的內容準備好進行廣泛的部署時，提交者要先先建立一個[GitHub 拉取請求(Pull Request)](https://github.com/Klipper3d/klipper/pulls)。
1. 當 [審覈者](#reviewers)可以 [審覈](#what-to-expect-in-a-review)提交時，他們將把自己分配給 GitHub 上的拉取請求。審覈的目的是尋找缺陷並檢查提交是否遵循記錄在案的準則。
1. 審覈完成後，審覈者會在GitHub上"批準審查"，然後由[維護者](#reviewers)將修改提交到Klipper的master分支。

在改進Klipper時，請考慮在[Klipper Discourse](Contact.md)上打開（或參與）一個主題。論壇上正在進行的討論可以提高開發工作的可見性，並可能吸引對測試新工作感興趣的其他人。

## 審覈中的預期內容

對 Klipper 的貢獻在合併前會被審覈。審覈過程的主要目的是檢查缺陷，並檢查提交的內容是否符合 Klipper 文件中規定的準則。

有許多方法可以實現一個功能；審覈的目的不是尋找"最佳 "的實現。在可能的情況下，審查討論最好是集中在事實和測試結果上。

大多數的提交都會得到至少一個審覈。準備好獲得反饋，提供更多的細節，並在需要時更新提交的程式碼。

審覈員通常會檢查這些：


   1. 提交是否沒有缺陷，是否準備好廣泛部署？提交者應在提交之前測試其更改。審覈員會查詢提交中的錯誤，但通常不會測試提交的實際內容。接受的提交通常會在被接受后的幾周內部署到數千臺印表機。因此，提交的質量極為重要。

   主[Klipper3d/klipper](https://github.com/Klipper3d/klipper) GitHub倉庫不接受實驗性程式碼。提交者應該在他們自己的倉庫中進行實驗、除錯和測試。[Klipper Discourse](Contact.md)論壇可以幫助你找到其他有興趣的開發者和可以提供真實世界反饋的使用者，或者讓更多人瞭解你的工作。

   提交必須通過所有[迴歸測試用例](Debugging.md)。

   程式碼提交不應包含過多的除錯程式碼、除錯選項，也不應包含執行時除錯日誌。

   程式碼提交中的註釋應側重於增強程式碼的可維護性。提交不應包含"註釋掉的程式碼"，不應包含描述過去實現的過多註釋，也不應包含過多的"待辦事項"。

   對檔案的更新不應該聲明它們是一項正在進行的工作。

   1. 提交的檔案是否為執行真實世界任務的真實世界使用者提供了 "高度影響"的好處？審閱人仕需要至少在自己的腦海中確定大致的“目標受眾是誰”、“受眾規模”的粗略尺度、他們將獲得的“好處”、“好處是如何衡量的”，以及“這些測量測試的結果”。在大多數情況下，這對於提交者和審閱者來說都是顯而易見的，並且在審閱期間沒有明確說明。

   向 Klipper 主分支提交的內容預計會有值得注意的目標受眾。作為一般的“經驗法則”，提交內容應針對至少 100 個真實用戶的用戶群。

   If a reviewer asks for details on the "benefit" of a submission, please don't consider it criticism. Being able to understand the real-world benefits of a change is a natural part of a review.

   When discussing benefits it is preferable to discuss "facts and measurements". In general, reviewers are not looking for responses of the form "someone may find option X useful", nor are they looking for responses of the form "this submission adds a feature that firmware X implements". Instead, it is generally preferable to discuss details on how the quality improvement was measured and what were the results of those measurements - for example, "tests on Acme X1000 printers show improved corners as seen in picture ...", or for example "print time of real-world object X on a Foomatic X900 printer went from 4 hours to 3.5 hours". It is understood that testing of this type can take significant time and effort. Some of Klipper's most notable features took months of discussion, rework, testing, and documentation prior to being merged into the master branch.

   所有新模塊、配置選項、命令、命令參數和文檔都應該具有“高影響”。我們不想讓用戶負擔他們無法合理配置的選項，也不想讓他們負擔不提供顯著好處的選項。

   審閱者可能會要求澄清用戶如何配置選項 - 理想的回復將包含有關過程的詳細信息 - 例如，“MegaX500 的用戶預計將選項 X 設置為 99.3，而 Elite100Y 的用戶預計將使用程序校準選項 X ..."。

   如果選項的目標是使代碼更加模塊化，那麼更喜歡使用代碼常量而不是面向用戶的配置選項。

   新模塊、新選項和新參數不應提供與現有模塊類似的功能 - 如果差異是任意的，則最好利用現有系統或重構現有代碼。

   1. 提交的版權是否清晰、無償、相容？新的 C 檔案和 Python 檔案應該有一個明確的版權聲明。請看現有檔案以瞭解推薦格式。不推薦在對現有檔案進行小的修改時對該檔案進行版權聲明。

   從第三方來源獲取的程式碼必須與 Klipper 的許可證（GNU GPLv3）相容。大型的第三方程式碼新增應被新增到`lib/`目錄中（並遵循 <../lib/README>中描述的格式）。

   提交者必須提供一個[Signed-off-by 行](#format-of-commit-messages)，使用他們的真實全名。它表明提交者同意[開發者源頭證書](developer-certificate-of-origin)。

   1. 提交的檔案是否遵循 Klipper 檔案中規定的準則？特別是，程式碼應遵循 <Code_Overview.md> 中的準則，配置檔案應遵循 <Example_Configs.md> 中的準則。

   1. Klipper 文件是否已更新以反映新的更改？至少，參考檔案必須隨著程式碼的相應變化而更新：

   * 所有命令和命令參數必須在 <G-Code.md> 中被描述。
   * 所有面向用戶的模組及其配置參數必須在<Config_Reference.md>中記錄。
   * 所有輸出的 "狀態變數 "必須在<Status_Reference.md>中進行描述。
   * 所有新的 "webhooks "及其參數必須在<API_Server.md>中描述。
   * 任何對命令或配置檔案設定導致無法向後相容的改變，都必須在<Config_Changes.md>中進行說明。

新的檔案應該被新增到<Overview.md>中，並被新增到網站索引[docs/_klipper3d/mkdocs.yml](../docs/_klipper3d/mkdocs.yml)。


   1. 提交的內容是否完整，每次提交只涉及一個主題，並且是獨立的？提交資訊應遵循[首選格式](#format-of-commit-messages)。

   提交的內容不能有合併衝突。對 Klipper 主分支的新新增總是通過 "rebase "或 "squash and rebase "完成。一般來說，提交者沒有必要在每次更新Klipper主庫的時候重新合併他們的提交。然而，如果有合併衝突，建議提交者使用`git rebase`來解決衝突。

   每一次提交都應該解決一個高層的變化。大的改動應該被分解成多個獨立的提交。每個提交都應該 "自成一體"，這樣才能讓`git bisect`和`git revert`等工具可靠地工作。

   空格的修改不應該與功能修改混在一起。一般來說，無意義的空格修改是不被接受的，除非是來自被修改程式碼的既定 "所有者"。

Klipper 沒有實現嚴格的“編碼風格指南”，但對現有代碼的修改應該遵循現有代碼的高級代碼流、代碼縮進風格和格式。新模塊和系統的提交在編碼風格上具有更大的靈活性，但新代碼最好遵循內部一致的風格並通常遵循行業範圍的編碼規範。

討論“更好的實現”不是審查的目標。但是，如果審閱者難以理解提交的實施，那麼他們可能會要求進行更改以使實施更加透明。特別是，如果審閱者無法說服自己提交的內容沒有缺陷，則可能需要進行更改。

作為審查的一部分，審查者可以為一個主題創建一個備用的拉取請求。這樣做可以避免在次要程序項目上過度“來回”，從而簡化提交過程。也可以這樣做，因為討論激發了審閱者構建替代實現。這兩種情況都是審查的正常結果，不應被視為對原始提交的批評。

### 協助評論

我們感謝評論方面的幫助！無需成為 [列出的審閱者](#reviewers) 即可進行審閱。還鼓勵 GitHub 拉取請求的提交者審查他們自己的提交。

為了幫助進行審核，請按照 [審核中的預期內容](#what-to-expect-in-a-review) 中概述的步驟來驗證提交。完成審查後，在 GitHub 拉取請求中添加評論以及您的發現。如果提交通過了審核，請在評論中明確說明 - 例如“我根據 CONTRIBUTING 文檔中的步驟審核了此更改，並且對我來說一切都很好”。如果無法完成審查中的某些步驟，請明確說明哪些步驟已審查，哪些步驟未審查 - 例如“我沒有檢查代碼是否存在缺陷，但我審查了 CONTRIBUTING 文檔中的所有其他內容，並且它看起來不錯”。

我們也感謝對提交的測試。如果代碼已經過測試，請在 GitHub 拉取請求中添加評論，並附上您的測試結果 - 成功或失敗。請明確說明代碼已經過測試和結果——例如“我在 Acme900Z 打印機上用花瓶打印測試了這段代碼，結果很好”。

### 檢閱人仕

以下為Klipper檢閱人仕:

| 項目名稱 | GitHub Id | 興趣範圍 |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | 輸入整形、共振測試、運動學 |
| Eric Callahan | @Arksine | 列印床調平中,MCU 更新中 |
| Kevin O'Connor | @KevinOConnor | 核心運動系統，微控制器代碼 |
| Paul McGowan | @mental405 | 配置檔案, 文件 |

請不要“ping”任何審閱人仕，也不要直接向他們投稿。所有審閱人仕都會監控論壇和 PR，並會在有時間時進行審閱。

Klipper 的“維護者”是：

| 項目名稱 | GitHub項目名稱 |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## 提交消息的格式

每個提交都應該有一個類似於以下格式的提交消息：

```
模組名: 大寫、簡短的摘要（50個字元或更少）

在必要情況下提供更詳細的解釋性文字。 分割行為
每行75字元左右。 在某些情景下，第一行被視為
電子郵件的主題，其餘的部分作為主體。 在摘要與
主體之間的分隔用空行至關重要（除非您完全忽略了
主體），一些工具例如變基(rebase)可能會在無空行時
混淆。

可以在空白行之後寫更多段落。

Signed-off-by: 姓名< myemail@example.org >
```

在上面的示例中，`module` 應該是存儲庫中文件或目錄的名稱（沒有文件擴展名）。例如，`clocksync：修復連接時 pause() 調用中的拼寫錯誤`。在提交消息中指定模塊名稱的目的是幫助為提交註釋提供上下文。

在每個提交上必須有一個 "Signed-off-by "行--它證明你同意[開發者起源證書](developer-certificate-of-origin)。它必須包含你的真實姓名（對不起，沒有假名或匿名的貢獻）和一個可用的電子郵件地址。

## 為 Klipper 翻譯做出貢獻

[Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) is a project dedicated to translating Klipper to different languages. [Weblate](https://hosted.weblate.org/projects/klipper/) hosts all the Gettext strings for translating and reviewing. Locales can be displayed on [klipper3d.org](https://www.klipper3d.org) once they satisfy the following requirements:

- [ ] 75% 總覆蓋率
- [ ] All titles (H1) are translated
- [ ] 在klipper-translations 中提供一個更新導航層次的 PR。

爲了減少翻譯特定領域術語的疑惑，並讓更多人瞭解正在進行的翻譯，你可以提交一個修改[Klipper-translations 專案](https://github.com/Klipper3d/klipper-translations) `readme.md` 檔案的PR。一旦翻譯完成，也可以對 Klipper 專案進行相應的修改。

如果一個已經存在於 Klipper 程式碼庫中的翻譯不再符合上述的檢查清單，那麼在一個月沒有更新后，它將被標記為過期。

Once the requirements are met, you need to:

1. update klipper-tranlations repository [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations)
1. Optional: add a manual-index.md file in klipper-translations repository's `docs\locals\<lang>` folder to replace the language specific index.md (generated index.md does not render correctly).

Known Issues:

1. Currently, there isn't a method for correctly translating pictures in the documentation
1. It is impossible to translate titles in mkdocs.yml.
