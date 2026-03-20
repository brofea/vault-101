= 动态规划

== 背包问题

*01背包*

$N$ 个物品重量 $w_i$ 价值 $v_i$ ,背包总容量 V，每个物品只能选或者不选。$f(i, j)$ 表示选前 $i$ 个物品，背包最大体积为 $j$ 的情况下储存的属性（如最大价值，最小价值，物品数量最多，以下讨论最大价值）

$ f(i,j)=max(f(i-1,j),f(i-1,j-w_i)+v_i) $

改为滚动数组，从后向前遍历：

$ f(j)=(f(j),f(j-w_i)+v_i) $

*完全背包*

每个物品可以选无限次个。$f(i, j)$ 表示选前 $i$ 个物品，背包最大体积为 $j$ 的情况下储存最大价值

$ f(i,j)=max_(k=0)^(k->+∞)(f(i-1,j-k w_i)+k v_i) $

优化至二维：

$ f(i,j)=max(f(i-1,j),f(i,j-w_i)+v_i) $

改为滚动数组，从前向后遍历：

$ f(j)=max(f(j),f(j-w_i)+v_i) $

*多重背包*

最多选 $m$ 个物品的完全背包。$f(i, j)$ 表示选前 $i$ 个物品，背包最大体积为 $j$ 的情况下储存最大价值

$ f(i,j)=max_(k=0)^(k → m) (f(i-1,j-k w_i)+k v_i) $

使用二进制分组优化可降低至 $O(n V log m)$

*分组背包*

有 $N$ 组物品，第 $i$ 组物品有 $n$ 个物品，每个物品有重量 $w_i^k$ 和价值 $v_i^k$ ，背包总容量 $V$

$ f(i,j)=max(f(i-1,j),max_(k=1)^(k→n) (f(i-1,j-w_i^k)+v_i^k)) $


== 序列问题

*最长上升子序列（LIS）*
```cpp
int n, res=0, a[N], dp[N];
int main() {
	cin >> n;
	for(int i = 0; i < n; i++)
		cin >> a[i];
	for(int i = 0; i < N; i++)
		dp[i] = 1;
	for(int i = 1; i < n; i++)
		for(int j = 0; j < i; j++)
			if(a[j] < a[i])
				dp[i] = max(dp[i], dp[j] + 1);
	for(int i = 0; i < n; i++)
		res = max(res, dp[i]);
	cout << res << endl;
}
```

*最长公共子序列（LCS）*

两个排列的 LCS 就是 LIS
```cpp
const int N = 1e5 + 10;
// amp 表示 a 序列的值在 a 序列中的位置
int n, amp[N], b[N], f[N];
int main() {
  memset(f, 0x3f, sizeof(f));
  int x;
  cin >> n;
  for (int i = 1; i <= n; i++) cin >> x, amp[x] = i;
  for (int i = 1; i <= n; i++) cin >> b[i];
  int res = 0, t;
  f[0] = 0;
  for (int i = 1; i <= n; i++) {
    if (amp[b[i]] > f[res]) {
      f[++res] = amp[b[i]];
    } else {
      t = lower_bound(f + 1, f + res + 1, amp[b[i]]) - f;
      f[t] = min(amp[b[i]], f[t]);
    }
  }
  cout << res;
}
```

*最长公共上升子序列（LICS）*

```cpp
int n;
int a[N], b[N];
int f[N][N];

int main() {
  cin >> n;
  for (int i = 1; i <= n; i++) cin >> a[i];
  for (int i = 1; i <= n; i++) cin >> b[i];

  for (int i = 1; i <= n; i++) {
    int maxv = 1;
    for (int j = 1; j <= n; j++) {
      f[i][j] = f[i - 1][j];
      if (a[i] == b[j]) f[i][j] = max(f[i][j], maxv);
      if (a[i] > b[j]) maxv = max(maxv, f[i - 1][j] + 1);
    }
  }
  int res = 0;
  for (int i = 1; i <= n; i++) res = max(res, f[n][i]);
  cout << res << endl;
}
```