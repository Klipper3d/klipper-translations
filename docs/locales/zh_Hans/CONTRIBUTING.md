# 为 Klipper 做贡献

感谢您对Klipper的贡献！本文档介绍向 Klipper 贡献改进的流程。

请参阅[联系页面](Contact.md)来了解报告问题的信息或联系开发人员的方法。

## 贡献流程概述

对Klipper的贡献通常遵循一个高水平的流程：

1. 当提交的内容准备好进行广泛的部署时，提交者要先先创建一个[GitHub 拉取请求(Pull Request)](https://github.com/Klipper3d/klipper/pulls)。
1. 当 [审核者](#reviewers)可以 [审核](#what-to-expect-in-a-review)提交时，他们将把自己分配给 GitHub 上的拉取请求。审核的目的是寻找缺陷并检查提交是否遵循记录在案的准则。
1. 审核完成后，审核者会在GitHub上"批准审查"，然后由[维护者](#reviewers)将修改提交到Klipper的master分支。

在改进Klipper时，请考虑在[Klipper Discourse](Contact.md)上打开（或参与）一个主题。论坛上正在进行的讨论可以提高开发工作的可见性，并可能吸引对测试新工作感兴趣的其他人。

## 审核中的预期内容

对 Klipper 的贡献在合并前会被审核。审核过程的主要目的是检查缺陷，并检查提交的内容是否符合 Klipper 文档中规定的准则。

有许多方法可以实现一个功能；审核的目的不是寻找"最佳 "的实现。在可能的情况下，审查讨论最好是集中在事实和测试结果上。

大多数的提交都会得到至少一个审核。准备好获得反馈，提供更多的细节，并在需要时更新提交的代码。

审核员通常会检查这些：


   1. 提交是否没有缺陷，是否准备好广泛部署？提交者应在提交之前测试其更改。审核员会查找提交中的错误，但通常不会测试提交的实际内容。接受的提交通常会在被接受后的几周内部署到数千台打印机。因此，提交的质量极为重要。

   主[Klipper3d/klipper](https://github.com/Klipper3d/klipper) GitHub仓库不接受实验性代码。提交者应该在他们自己的仓库中进行实验、调试和测试。[Klipper Discourse](Contact.md)论坛可以帮助你找到其他有兴趣的开发者和可以提供真实世界反馈的用户，或者让更多人了解你的工作。

   提交必须通过所有[回归测试用例](Debugging.md)。

   代码提交不应包含过多的调试代码、调试选项，也不应包含运行时调试日志。

   代码提交中的注释应侧重于增强代码的可维护性。提交不应包含"注释掉的代码"，不应包含描述过去实现的过多注释，也不应包含过多的"待办事项"。

   对文件的更新不应该声明它们是一项正在进行的工作。

   1. 提交的文件是否为执行真实世界任务的用户提供了 "高影响力"的改进？评审员需要确定，至少在他们自己的脑海中，大致的"目标受众"，"受众的规模"，受众将获得的"利益"，“如何衡量利益"，以及”这些测试的结果“。在大多数情况下，这对提交者和评审者来说都是显而易见的，而且在评审过程不需要明确的说明。

   提交到Klipper主分支的代码应该有足够的目标受众。作为一般的经验法则，提交的内容应该针对至少100个用户的用户群体。

   如果审稿人询问有关提交可以带来的“好处”的细节，请不要将其视为批评。能够理解更改带来的实际好处是审查的一个自然部分。

   When discussing benefits it is preferable to discuss "facts and measurements". In general, reviewers are not looking for responses of the form "someone may find option X useful", nor are they looking for responses of the form "this submission adds a feature that firmware X implements". Instead, it is generally preferable to discuss details on how the quality improvement was measured and what were the results of those measurements - for example, "tests on Acme X1000 printers show improved corners as seen in picture ...", or for example "print time of real-world object X on a Foomatic X900 printer went from 4 hours to 3.5 hours". It is understood that testing of this type can take significant time and effort. Some of Klipper's most notable features took months of discussion, rework, testing, and documentation prior to being merged into the master branch.

   All new modules, config options, commands, command parameters, and documents should have "high impact". We do not want to burden users with options that they can not reasonably configure nor do we want to burden them with options that don't provide a notable benefit.

   评审员可能会要求解释用户该如何配置一个选项，一个理想的答复将包含过程的细节，例如："MegaX500的用户应将选项 X 设置为99.3，而Elite100Y的用户应使用程序校准选项X..." 。

   如果一个选项的目标是使代码更加模块化，那么最好使用代码常量而不是向用户开放的配置选项。

   New modules, new options, and new parameters should not provide similar functionality to existing modules - if the differences are arbitrary than it's preferable to utilize the existing system or refactor the existing code.

   1. 提交的版权是否清晰、无偿、兼容？新的 C 文件和 Python 文件应该有一个明确的版权声明。请看现有文件以了解推荐格式。不推荐在对现有文件进行小的修改时对该文件进行版权声明。

   从第三方来源获取的代码必须与 Klipper 的许可证（GNU GPLv3）兼容。大型的第三方代码添加应被添加到`lib/`目录中（并遵循 <../lib/README>中描述的格式）。

   提交者必须提供一个[Signed-off-by 行](#format-of-commit-messages)，使用他们的真实全名。它表明提交者同意[开发者源头证书](developer-certificate-of-origin)。

   1. 提交的文件是否遵循 Klipper 文件中规定的准则？特别是，代码应遵循 <Code_Overview.md> 中的准则，配置文件应遵循 <Example_Configs.md> 中的准则。

   1. Klipper 文档是否已更新以反映新的更改？至少，参考文件必须随着代码的相应变化而更新：

   * 所有命令和命令参数必须在 <G-Code.md> 中被描述。
   * 所有面向用户的模块及其配置参数必须在<Config_Reference.md>中记录。
   * 所有输出的 "状态变量 "必须在<Status_Reference.md>中进行描述。
   * 所有新的 "webhooks "及其参数必须在<API_Server.md>中描述。
   * 任何对命令或配置文件设置导致无法向后兼容的改变，都必须在<Config_Changes.md>中进行说明。

新的文件应该被添加到<Overview.md>中，并被添加到网站索引[docs/_klipper3d/mkdocs.yml](../docs/_klipper3d/mkdocs.yml)。


   1. 提交的内容是否完整，每次提交只涉及一个主题，并且是独立的？提交信息应遵循[首选格式](#format-of-commit-messages)。

   提交的内容不能有合并冲突。对 Klipper 主分支的新添加总是通过 "rebase "或 "squash and rebase "完成。一般来说，提交者没有必要在每次更新Klipper主库的时候重新合并他们的提交。然而，如果有合并冲突，建议提交者使用`git rebase`来解决冲突。

   每一次提交都应该解决一个高层的变化。大的改动应该被分解成多个独立的提交。每个提交都应该 "自成一体"，这样才能让`git bisect`和`git revert`等工具可靠地工作。

   空格的修改不应该与功能修改混在一起。一般来说，无意义的空格修改是不被接受的，除非是来自被修改代码的既定 "所有者"。

Klipper does not implement a strict "coding style guide", but modifications to existing code should follow the high-level code flow, code indentation style, and format of that existing code. Submissions of new modules and systems have more flexibility in coding style, but it is preferable for that new code to follow an internally consistent style and to generally follow industry wide coding norms.

It is not a goal of a review to discuss "better implementations". However, if a reviewer struggles to understand the implementation of a submission, then they may ask for changes to make the implementation more transparent. In particular, if reviewers can not convince themselves that a submission is free of defects then changes may be necessary.

As part of a review, a reviewer may create an alternate Pull Request for a topic. This may be done to avoid excessive "back and forth" on minor procedural items and thus streamline the submission process. It may also be done because the discussion inspires a reviewer to build an alternative implementation. Both situations are a normal result of a review and should not be considered criticism of the original submission.

### Helping with reviews

We appreciate help with reviews! It is not necessary to be a [listed reviewer](#reviewers) to perform a review. Submitters of GitHub Pull Requests are also encouraged to review their own submissions.

To help with a review, follow the steps outlined in [what to expect in a review](#what-to-expect-in-a-review) to verify the submission. After completing the review, add a comment to the GitHub Pull Request with your findings. If the submission passes the review then please state that explicitly in the comment - for example something like "I reviewed this change according to the steps in the CONTRIBUTING document and everything looks good to me". If unable to complete some steps in the review then please explicitly state which steps were reviewed and which steps were not reviewed - for example something like "I didn't check the code for defects, but I reviewed everything else in the CONTRIBUTING document and it looks good".

We also appreciate testing of submissions. If the code was tested then please add a comment to the GitHub Pull Request with the results of your test - success or failure. Please explicitly state that the code was tested and the results - for example something like "I tested this code on my Acme900Z printer with a vase print and the results were good".

### Reviewers

The Klipper "reviewers" are:

| Name | GitHub Id | Areas of interest |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Input shaping, resonance testing, kinematics |
| Eric Callahan | @Arksine | Bed leveling, MCU flashing |
| Kevin O'Connor | @KevinOConnor | Core motion system, Micro-controller code |
| Paul McGowan | @mental405 | Configuration files, documentation |

Please do not "ping" any of the reviewers and please do not direct submissions at them. All of the reviewers monitor the forums and PRs, and will take on reviews when they have time to.

The Klipper "maintainers" are:

| Name | GitHub name |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## Format of commit messages

Each commit should have a commit message formatted similar to the following:

```
模块名: 大写、简短的摘要（50个字符或更少）

在必要情况下提供更详细的解释性文本。 分割行为
每行75字符左右。 在某些情景下，第一行被视为
电子邮件的主题，其余的部分作为主体。 在摘要与
主体之间的分隔用空行至关重要（除非您完全忽略了
主体），一些工具例如变基(rebase)可能会在无空行时
混淆。

可以在空白行之后写更多段落。

Signed-off-by: 姓名< myemail@example.org >
```

In the above example, `module` should be the name of a file or directory in the repository (without a file extension). For example, `clocksync: Fix typo in pause() call at connect time`. The purpose of specifying a module name in the commit message is to help provide context for the commit comments.

在每个提交上必须有一个 "Signed-off-by "行--它证明你同意[开发者起源证书](developer-certificate-of-origin)。它必须包含你的真实姓名（对不起，没有假名或匿名的贡献）和一个可用的电子邮件地址。

## 为 Klipper 翻译做出贡献

[Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) is a project dedicated to translating Klipper to different languages. [Weblate](https://hosted.weblate.org/projects/klipper/) hosts all the Gettext strings for translating and reviewing. Locales can be displayed on [klipper3d.org](https://www.klipper3d.org) once they satisfy the following requirements:

- [ ] 75% 总覆盖率
- [ ] All titles (H1) are translated
- [ ] klipper-translations 中提供一个更新导航层次的 PR。

为了减少翻译特定领域术语的疑惑，并让更多人了解正在进行的翻译，你可以提交一个修改[Klipper-translations 项目](https://github.com/Klipper3d/klipper-translations) `readme.md` 文件的PR。一旦翻译完成，也可以对 Klipper 项目进行相应的修改。

如果一个已经存在于 Klipper 代码库中的翻译不再符合上述的检查清单，那么在一个月没有更新后，它将被标记为过期。

Once the requirements are met, you need to:

1. update klipper-tranlations repository [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations)
1. Optional: add a manual-index.md file in klipper-translations repository's `docs\locals\<lang>` folder to replace the language specific index.md (generated index.md does not render correctly).

Known Issues:

1. Currently, there isn't a method for correctly translating pictures in the documentation
1. It is impossible to translate titles in mkdocs.yml.
