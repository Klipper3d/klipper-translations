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

## Contributing to Klipper Translations

[Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) is a project dedicated to translating Klipper to different languages. [Weblate](https://hosted.weblate.org/projects/klipper/) hosts all the Gettext strings for translating and reviewing. Locales can merge into the Klipper project once they satisfy the following requirements:

- [ ] 75% Total coverage
- [ ] All titles (H1) are covered
- [ ] An updated navigation hierarchy PR in klipper-translations.

The navigation hierarchy is in `docs\_klipper3d\mkdocs.yml`.

To reduce the frustration of translating domain-specific terms and gain awareness of the ongoing translations, you can submit a PR modifying the [Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) `readme.md`. Once a translation is ready, the corresponding modification to the Klipper project can be made.

If a translation already exists in the Klipper repository and no longer meets the checklist above, it will be marked out-of-date after a month without updates.

Please follow the following format for `mkdocs.yml` navigation hierarchy:

```yml
nav:
  - existing hierachy
  - <language>:
    - locales/<language code>/md file
```

Note: Currently, there isn't a method for correctly translating pictures in the documentation.
