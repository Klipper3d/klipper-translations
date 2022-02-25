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

   1. 提交的檔案是否為執行真實世界任務的真實世界使用者提供了 "高度影響"的好處？Reviewers need to identify, at least in their own minds, roughly "who the target audience is", a rough scale of "the size of that audience", the "benefit" they will obtain, how the "benefit is measured", and the "results of those measurement tests". In most cases this will be obvious to both the submitter and the reviewer, and it is not explicitly stated during a review.

   Submissions to the master Klipper branch are expected to have a noteworthy target audience. As a general "rule of thumb", submissions should target a user base of at least a 100 real-world users.

   If a reviewer asks for details on the "benefit" of a submission, please don't consider it criticism. Being able to understand the real-world benefits of a change is a natural part of a review.

   When discussing benefits it is preferable to discuss "facts and measurements" instead of "opinions and theories". In general, reviewers are not looking for responses of the form "this submission may improve quality because of ...", nor are they looking for responses of the form "someone may find option X useful", nor are they looking for responses of the form "this submission adds a feature that firmware X implements". Instead, it is generally preferable to discuss details on how the quality improvement was measured and what were the results of those measurements - for example, "tests on Acme X1000 printers show improved corners as seen in picture ...", or for example "print time of real-world object X on a Foomatic X900 printer went from 4 hours to 3.5 hours". It is understood that testing of this type can take significant time and effort. Some of Klipper's most notable features took years of discussion, rework, testing, and documentation prior to being merged into the master branch.

   All new modules, config options, commands, command parameters, and documents should have "high impact". We do not want to burden users with options that they can not reasonably configure nor do we want to burden them with options that don't provide a notable benefit.

   A reviewer may ask for clarification on how a user is to configure an option - an ideal response will contain details on the process - for example, "users of the MegaX500 are expected to set option X to 99.3 while users of the Elite100Y are expected to calibrate option X using procedure ...".

   If the goal of an option is to make the code more modular then prefer using code constants instead of user facing config options.

   New modules, new options, and new parameters should not provide similar functionality to existing modules - if the differences are arbitrary than it's preferable to utilize the existing system or refactor the existing code.

Klipper does not implement a strict "coding style guide", but modifications to existing code should follow the high-level code flow, code indentation style, and format of that existing code. Submissions of new modules and systems have more flexibility in coding style, but it is preferable for that new code to follow an internally consistent style and to generally follow industry wide coding norms.

It is not a goal of a review to discuss "better implementations". However, if a reviewer struggles to understand the implementation of a submission, then they may ask for changes to make the implementation more transparent. In particular, if reviewers can not convince themselves that a submission is free of defects then changes may be necessary.

As part of a review, a reviewer may create an alternate Pull Request for a topic. This may be done to avoid excessive "back and forth" on minor procedural items and thus streamline the submission process. It may also be done because the discussion inspires a reviewer to build an alternative implementation. Both situations are a normal result of a review and should not be considered criticism of the original submission.

### 協助評論

We appreciate help with reviews! It is not necessary to be a [listed reviewer](#reviewers) to perform a review. Submitters of GitHub Pull Requests are also encouraged to review their own submissions.

To help with a review, follow the steps outlined in [what to expect in a review](#what-to-expect-in-a-review) to verify the submission. After completing the review, add a comment to the GitHub Pull Request with your findings. If the submission passes the review then please state that explicitly in the comment - for example something like "I reviewed this change according to the steps in the CONTRIBUTING document and everything looks good to me". If unable to complete some steps in the review then please explicitly state which steps were reviewed and which steps were not reviewed - for example something like "I didn't check the code for defects, but I reviewed everything else in the CONTRIBUTING document and it looks good".

We also appreciate testing of submissions. If the code was tested then please add a comment to the GitHub Pull Request with the results of your test - success or failure. Please explicitly state that the code was tested and the results - for example something like "I tested this code on my Acme900Z printer with a vase print and the results were good".

### 檢閱人仕

以下為Klipper檢閱人仕:

| 項目名稱 | GitHub Id | Areas of interest |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Input shaping, resonance testing, kinematics |
| Eric Callahan | @Arksine | 列印床調平中,MCU 更新中 |
| Kevin O'Connor | @KevinOConnor | Core motion system, Micro-controller code |
| Paul McGowan | @mental405 | 配置檔案, 文件 |

Please do not "ping" any of the reviewers and please do not direct submissions at them. All of the reviewers monitor the forums and PRs, and will take on reviews when they have time to.

The Klipper "maintainers" are:

| 項目名稱 | GitHub項目名稱 |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## Format of commit messages

Each commit should have a commit message formatted similar to the following:

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

In the above example, `module` should be the name of a file or directory in the repository (without a file extension). For example, `clocksync: Fix typo in pause() call at connect time`. The purpose of specifying a module name in the commit message is to help provide context for the commit comments.

在每個提交上必須有一個 "Signed-off-by "行--它證明你同意[開發者起源證書](developer-certificate-of-origin)。它必須包含你的真實姓名（對不起，沒有假名或匿名的貢獻）和一個可用的電子郵件地址。

## 為 Klipper 翻譯做出貢獻

[Klipper翻譯專案](https://github.com/Klipper3d/klipper-translations)是一個致力於將Klipper翻譯成不同語言的專案。[Weblate](https://hosted.weblate.org/projects/klipper/) 託管所有 Gettext 字串以進行翻譯和審查。一旦符合以下要求，本地化可以被合併到 Klipper 專案中：

- [ ] 75% 總覆蓋率
- [ ] 涵蓋所有大標題（H1）
- [ ] 在klipper-translations 中提供一個更新導航層次的 PR。

導航層級在`docs\_klipper3d\mkdocs.yml`中。

爲了減少翻譯特定領域術語的疑惑，並讓更多人瞭解正在進行的翻譯，你可以提交一個修改[Klipper-translations 專案](https://github.com/Klipper3d/klipper-translations) `readme.md` 檔案的PR。一旦翻譯完成，也可以對 Klipper 專案進行相應的修改。

如果一個已經存在於 Klipper 程式碼庫中的翻譯不再符合上述的檢查清單，那麼在一個月沒有更新后，它將被標記為過期。

請按以下格式編寫 `mkdocs.yml` 的導航層次結構：

```yml
nav:
  - existing hierachy
  - <language>:
    - locales/<language code>/md file
```

注意：目前，還沒有翻譯圖片中文字的方法。
