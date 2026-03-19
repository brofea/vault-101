---
标签:
  - 数据结构
---
# 什么是 ST 表

> [OI Wiki - ST 表](https://oi-wiki.org/ds/sparse-table/)  

> ST 表（Sparse Table，稀疏表）是用于解决 **可重复贡献问题** 的数据结构。

ST 表用于解决大量的静态区间查询问题，例如 RMQ（区间最大最小）和区间 GCD 问题，建表耗时 $O(n\log n)$，查询耗时 $O(1)$，建表后无法修改，如果有修改需求可以选择使用线段树

除此以外，ST 表还可以处理区间按位与和区间按位或的查询

## 构建 & 查询

以区间最大值 ST 表为例，定义 `st[i][j]` 是以 $i$ 为起点，$2^j$ 为长度的区间最大值，也就是区间 $[i,i+2^j-1]$

对于查询区间 $[l,r]$ 可以将其分为两个部分，$[l,l+2^k-1]$ 和 $[r-2^k+1,r]$ 也就是长度为 $2^k$ 的头为 $l$ 和尾为 $r$ 的两个区间，也就是 `st[l][k]` 和 `st[r-(1<<k)+1][k]`

## 模板

```C++
int n, st[N][lgN + 1], lg[N + 1];

void build() {
  // 预处理所有的 ⌊log(n)⌋
  lg[1] = 0, lg[2] = 1;
  for (int i = 3; i < N; i++)
    lg[i] = lg[i / 2] + 1;
  // 构建 ST 表
  for (int j = 1; j <= lgN; j++)
    for (int i = 1; i + (1 << j) - 1 <= n; i++)
      st[i][j] = max(st[i][j - 1], st[i + (1 << (j - 1))][j - 1]);
}

// 查询区间[l, r]的最大值
inline int query(int l, int r) {
  int k = lg[r - l + 1];
  return max(st[l][k], st[r - (1 << k) + 1][k]);
}
// 读入 n 个数
for (int i = 1; i <= n; i++)
    cin >> st[i][0];
```

查询数量不多时不用预处理 $\log_2n$ 用 `s = log2(r - l + 1)` 也可以

## 模板题

> [落谷 - P3865 【模板】ST 表 && RMQ 问题](https://www.luogu.com.cn/problem/P3865)  
> 这是一道 ST 表经典题——静态区间最大值 请注意最大数据时限只有 0.  

- 数据强度很大，必须将 `endl` 换成 `‘\n’` 或者改用 scanf 和 printf

```C++
\#include <bits/stdc++.h>
using namespace std;
const int MAXN = 2000001;
const int lgN = 17;
int st[MAXN][lgN + 1], lg[MAXN + 1];
int main() {
  ios::sync_with_stdio(false);
  cin.tie(nullptr);
  int n, m;
  cin >> n >> m;
  // 读入n个数
  for (int i = 1; i <= n; i++)
    cin >> st[i][0];
  // 预处理所有的 ⌊log(n)⌋
  lg[1] = 0, lg[2] = 1;
  for (int i = 3; i < MAXN; i++)
    lg[i] = lg[i / 2] + 1;
  // 构建 ST 表
  for (int j = 1; j <= lgN; j++)
    for (int i = 1; i + (1 << j) - 1 <= n; i++)
      st[i][j] = max(st[i][j - 1], st[i + (1 << (j - 1))][j - 1]);
  // 查询[l, r]区间的最大值
  for (int i = 1; i <= m; i++) {
    int l, r;
    cin >> l >> r;
    int k = lg[r - l + 1];
    cout << max(st[l][k], st[r - (1 << k) + 1][k]) << '\n';
  }
  return 0;
}
```