# 打A错题本：DP

## [CF 455 A](https://codeforces.com/problemset/problem/455/A)【AI】

有 n 个数（可能重复），选了某个数 k 就不能选 k + 1 和 k - 1，问怎么选使得和最大。数的数量和范围均小于 1e5

统计数 k 的个数为 x[k]，然后令 s[k] = k * x[k]，最后 f[i] 表示选小于等于 i 的数最优解，状态转移方程如下

$$
f[i]_{i=1}^{1e5} = \max(f[i-1], f[i-2]+s[i])
$$

答案为 $f[1e5]$

## [CF 1842 C](https://codeforces.com/problemset/problem/1842/C)【Editorial】

有 n 个数的数组，可以执行任意次删除操作：选择 $a_i = a_j$ 删除数组 $[i,j]$ 所有数，问最少能剩下多少个数。数的数量和范围均小于 1e5

不好表示最少能剩下几个但可以标识最多能删除几个，令 f[i] 表示前 i 个数最多能删除多少个数，状态转移方程如下

$$
f[i]=\min(f[i-1]+1,\min\set{f[j-1]|a_j=a_i,j<i})
$$

可以维护 $m[a[i]] = \min\set{f[j-1]|a_j=a_i}$ 优化至 $O(n)$。也就是说，每次计算完 $f[i]$ 都用 $f[i-1]$ 更新当前的 $m[a[i]]$，最后答案为 $n - f[n]$

## [CF 1994 C](https://codeforces.com/contest/1994/problem/C) 【Editorial】

给定 $x$ 和 $n$ 长排列 $a[n]$，问有多少个区间 $[l,r]$ 满足：从 $a[l]$ 开始逐个求和，每当和超过 $x$ 就归零，最后的和不为 0。$n < 10^5$

令 $f[i]$ 表示以 $i$ 开头有多少个区间满足条件，状态转移方程如下

$$
f[i] = j - i + 1 + f[j + 1]~其中~\sum_{k=i}^j a[k] \le x, \sum_{k=i}^{j+1} a[k] > x
$$

由于 $f[i]$ 依赖于 $f[j+1]$，所以倒序 DP，另外 $j$ 的值可以通过二分前缀和数组得到，最后答案为 $\sum_{i=1}^n f[i]$。