## 语系对正则表达式的影响
- LANG=C 时：0 1 2 3 4 ... A B C D ... Z a b c d ... z
- LANG=zh_TW 时：0 1 2 3 4 ... a A b B c C d D ... z Z
  - 使用[A-Z]时，会是：A a B b...
---
## 基础正则表达式
- ![](../images/2023-04-09-15-34-54.png)
- 用win长截图
---
## sed 工具