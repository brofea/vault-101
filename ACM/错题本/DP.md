# 打A错题本：DP

## [CF 455 A](https://codeforces.com/problemset/problem/455/A)【AI】

有 n 个数（可能重复），选了某个数 k 就不能选 k + 1 和 k - 1，问怎么选使得和最大。数的数量和数的范围均为 1e5

统计数 k 的个数为 x[k]，然后令 s[k] = k * x[k]，最后 f[i] 表示选小于等于 i 的数最优解，状态转移方程如下

$$
f[i]_{i=1}^{1e5} = \max(f[i-1], f[i-2]+s[i])
$$
