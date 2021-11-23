# 为 Klipper 做贡献

感谢你对 Klipper 的贡献！请花一点时间阅读本文档。

## 创建一个新的议题

请参阅[联系页面](Contact.md)，来了解如何创建议题。

## 提交拉取请求（PR）

代码和文档的贡献是通过github 拉取请求（PR）管理的。每个提交都应该有一个提交信息，其格式类似于以下内容：

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

在每个提交上必须有一个 "Signed-off-by "行--它证明你同意[开发者起源证书](developer-certificate-of-origin)。它必须包含你的真实姓名（对不起，没有假名或匿名的贡献）和一个可用的电子邮件地址。

## 为 Klipper 翻译做出贡献

[Klipper翻译项目](https://github.com/Klipper3d/klipper-translations)是一个致力于将Klipper翻译成不同语言的项目。[Weblate](https://hosted.weblate.org/projects/klipper/) 托管所有 Gettext 字符串以进行翻译和审查。一旦符合以下要求，本地化可以被合并到 Klipper 项目中：

- [ ] 75% 总覆盖率
- [ ] 涵盖所有大标题（H1）
- [ ] klipper-translations 中提供一个更新导航层次的 PR。

导航层级在`docs\_klipper3d\mkdocs.yml`中。

为了减少翻译特定领域术语的疑惑，并让更多人了解正在进行的翻译，你可以提交一个修改[Klipper-translations 项目](https://github.com/Klipper3d/klipper-translations) `readme.md` 文件的PR。一旦翻译完成，也可以对 Klipper 项目进行相应的修改。

如果一个已经存在于 Klipper 代码库中的翻译不再符合上述的检查清单，那么在一个月没有更新后，它将被标记为过期。

请按以下格式编写 `mkdocs.yml` 的导航层次结构：

```yml
nav:
  - existing hierachy
  - <language>:
    - locales/<language code>/md file
```

注意：目前，还没有翻译图片中文字的方法。
