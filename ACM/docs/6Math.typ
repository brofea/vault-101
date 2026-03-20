= 数学
== 质因数
=== 质数筛
埃氏筛
```cpp
// 找到0-n的所有质数
vector<bool> isPrime(n + 1, 1);
isPrime[1] = 0, isPrime[0] = 0;
int e = sqrt(n);
for (int i = 2; i <= e; i++)
  if (isPrime[i] == 1)
    for (int j = i + i; j <= n; j += i)
      isPrime[j] = 0;
```
线性筛 / 欧拉筛
```cpp
vector<int> isPrime(n + 1, 1);
vector<int> primes;
isPrime[0] = isPrime[1] = 0;
for (int i = 2; i <= n; i++) {
  if (isPrime[i])
    primes.push_back(i);
  for (int k : primes) {
    if (i * k > n)
      break;
    isPrime[i * k] = 0;
    if (i % k == 0)
      break;
  }
}
```
=== LCM & GCD
原理：$gcd(a, b) = gcd(b, a mod b)$ 特殊地 $gcd(a, 0) = a$
```cpp
int gcd(int a, int b) {
  return b ? gcd(b, a % b) : a;
}
int lcm(int a,int b){
	return (a / gcd(a, b)) * b;   // 先除再乘，避免超过数据范围
}
int gcd(int a, int b) {  // 非递归
  while (b) { int r = a % b; a = b; b = r; }
  return a;
}
```
=== 质因数分解和因数问题
```cpp
void divide(int x) {
  for (int i = 2; i <= x / i; i++)
    if (x % i == 0) {
      int s = 0;
      while (x % i == 0)
        x /= i, s++;
      cout << i << ' ' << s << endl;
    }
  if (x > 1)
    cout << x << ' ' << 1 << endl;
  cout << endl;
}
```
如果一个数质因数分解为：
$ n = p_1^(a_1) times p_2^(a_2) times p_3^(a_3) times ...... times p_k^(a_k) $
那么它的因数个数为：
$ (a_1+1)(a_2+1)(a_3+1)......(a_k+1) $
因数和为：
$ sum_(j=0)^(a_1) p_1^j times sum_(j=0)^(a_2) p_2^j times sum_(j=0)^(a_3) p_3^j times ...... times sum_(j=0)^(a_k) p_k^j  $

== 欧拉函数
=== 欧拉定理
如果一个数质因数分解为：
$ n = p_1^(a_1) times p_2^(a_2) times p_3^(a_3) times ...... times p_k^(a_k) $
欧拉函数的定义为：
$ phi (n)=n(1 - 1 / p_1)(1 - 1 / p_2)...(1 - 1 / p_k) $
欧拉函数和质因数的幂次无关
```cpp
int phi(int x)
{
  int res = x;
  for (int i = 2; i <= x / i; i ++ )
    if (x % i == 0)
    {
      res = res / i * (i - 1);
      while (x % i == 0) x /= i;
    }
  if (x > 1) res = res / x * (x - 1);

  return res;
}
```
若有质数 $p$ 则：
$  phi (p n)=p phi (n)(1- 1 / p)=(p-1) phi (n) $
欧拉函数的乘法性质：
$ phi (a dot b) = phi(a) dot phi(b) $
欧拉函数的质数性质：
$ phi (p) = p - 1 $
欧拉函数的幂性质：
$ φ(p k)=p^k−p^(k−1)=p^k (1− 1 / p​) $
使用筛法的欧拉函数
```cpp
int primes[N], cnt; // primes[]存储所有素数
int euler[N];       // 存储每个数的欧拉函数
bool st[N];         // st[x]存储x是否被筛掉

void get_eulers(int n) {
  euler[1] = 1;
  for (int i = 2; i <= n; i++) {
    if (!st[i]) {
      primes[cnt++] = i;
      euler[i] = i - 1;
    }
    for (int j = 0; primes[j] <= n / i; j++) {
      int t = primes[j] * i;
      st[t] = true;
      if (i % primes[j] == 0) {
        euler[t] = euler[i] * primes[j];
        break;
      }
      euler[t] = euler[i] * (primes[j] - 1);
    }
  }
}
```
=== 费马小定理
欧拉定理

- 若 $gcd (a,n)=1$ 则 $a^( phi(n)) equiv 1 ( mod n)$


例如 5 和 6 互质，$ phi(6)=2$，$5^2 mod 6=1$

费马小定理

- 若 $p$ 为质数且 $gcd(a,p)=1$ 则 $a^(p-1) equiv 1 ( mod p)$


- 对于任意整数 $a$，$a^p  equiv 1( mod p)$
== 快速幂和乘法逆元
```cpp
// 快速幂：求 m 的 k 次方 mod p
int qmi(int a, int k, int p) {
  int res = 1;
  while (k) {
    if (k & 1) res = (LL)res * a % p;
    a = (LL)a * a % p;
    k >>= 1;
  }
  return res;
}
```
要求 $a div b mod p$，即求 $a times b^(-1)(mod p)$
$ b^(-1) equiv b^(p-2) (mod p) $
前提条件：$p$ 为质数，$b,p$ 互质，否则需要用扩展欧几里得算法求逆元
```cpp  
// 扩展欧几里得算法求逆元
int mmi(int b, int p) {
  int x, y;
  int g = std::__gcd(b, p); // 可选的合法性判断（快速）
  if (g != 1) return -1;    // b 和 p 不互质，无逆元
  exgcd(b, p, x, y);        // 解 bx + py = 1
  x = (x % p + p) % p;      // 保证 x 为正，且 x < p
  return x;
}
// exgcd 函数如下
```

== 扩展欧几里得算法
```cpp
// 求 ax + by = gcd(a, b) 的整数解
int exgcd(int a, int b, int &x, int &y) {
  if (!b) {
    x = 1; y = 0;
    return a;
  }
  int d = exgcd(b, a % b, y, x);
  y -= (a/b) * x;
  return d;
}
// 解线性同余方程 ax ≡ b (mod m)
// 返回最小非负整数解 x（模 m/d），如果无解返回 -1
int solve_mod_linear(int a, int b, int m) {
  int x, y;
  int d = std::gcd(a, m);      // 等价于你用 exgcd 求 d
  if (b % d != 0) return -1;   // 无解

  exgcd(a, m, x, y);           // 解 ax + my = d
  x = x * (b / d);             // 得到 ax = b 的特解
  int mod = m / d;
  x = (x % mod + mod) % mod;   // 化成最小非负解
  return x;
}
```
== 中国剩余定理
给定一组两两互质的数：$m_1,m_2,m_3 dots m_k$，有一组数 $a_1,a_2,a_3 dots a_k$ 
满足 $x equiv a_i ( mod m_i),i in [1,k]$ 这个方程组的公式解为：
$ x=sum_(i=1)^(k)(a_i dot M_i dot M_i^(-1)) $
```cpp
// 中国剩余定理, 求解 x ≡ a[i] (mod m[i])
ll CRT(ll a[], ll m[], int n) {
  ll PM = 1, Mi, MiR, tmp, res = 0;
  for (int i = 1; i <= n; ++i)
    PM *= m[i];
  for (int i = 1; i <= n; ++i) {
    Mi = PM / m[i];
    MiR = mmi(Mi, m[i]);   // 扩展欧几里得求逆元
    tmp = a[i] * Mi * MiR % PM;
    res = (res + tmp) % PM;
  }
  return res;
}
```
== 线性代数
=== 高斯消元
求解线性方程组 $A_x=b$，其中 $A$ 是 $n times n$ 的系数矩阵，$b$ 是 $n times 1$ 的常数向量，增广矩阵为 $[A|b]$。
```cpp
// a[N][N]是增广矩阵
int gauss() {
  int c, r;
  for (c = 0, r = 0; c < n; c ++ ) {
    int t = r;
    for (int i = r; i < n; i ++ )   // 找到绝对值最大的行
      if (fabs(a[i][c]) > fabs(a[t][c]))
        t = i;

    if (fabs(a[t][c]) < eps) continue;

    // 将绝对值最大的行换到最顶端
    for (int i = c; i <= n; i ++ ) swap(a[t][i], a[r][i]);
    // 将当前行的首位变成1      
    for (int i = n; i >= c; i -- ) a[r][i] /= a[r][c];  
    // 用当前行将下面所有的列消成0
    for (int i = r + 1; i < n; i ++ )       
      if (fabs(a[i][c]) > eps)
        for (int j = n; j >= c; j -- )
          a[i][j] -= a[r][j] * a[i][c];
    r ++ ;
  }
  if (r < n) {
    for (int i = r; i < n; i ++ )
      if (fabs(a[i][n]) > eps)
        return 2; // 无解
    return 1; // 有无穷多组解
  }
  for (int i = n - 1; i >= 0; i -- )
    for (int j = i + 1; j < n; j ++ )
      a[i][n] -= a[i][j] * a[j][n];
  return 0; // 有唯一解
}
```
== 组合数学
$ A_a^b=a(a-1)(a-2) dots (a-b+1)=(a!) / (a-b)! $
$ C_a^b=(a(a-1)(a-2)\cdots(a-b+1)) / (1 times 2 times 3 dots times  b)=(a!) / (b!(a-b)!)=(A_a^b) / (b!) $
组合数算法：
- 递推法：$n lt.eq 10^5,1  lt.eq b  lt.eq a  lt.eq 2000,O(n^2)$
- 预处理：$n lt.eq 10^5,1  lt.eq b  lt.eq a  lt.eq 10^5,O(n log n)$
- Lucas：$n lt.eq 20,1  lt.eq b  lt.eq a  lt.eq 10^18,1  lt.eq p  lt.eq 10^5,O(p log n  log p)$
- 分解质因数：$1  lt.eq b  lt.eq a  lt.eq 5000$, 不取模
=== 递推法
$ C_a^b=C_(a-1)^b+C_(a-1)^(b-1) $
```cpp
// c[a][b] 表示从 a 个中选 b 个的方案数
int c[N][N]={0};
for (int i = 0; i < N; i ++ )
    for (int j = 0; j <= i; j ++ )
        if (!j) c[i][j] = 1;
        else c[i][j] = (c[i - 1][j] + c[i - 1][j - 1]) % mod;
```
=== 预处理法
```cpp
// 预处理阶乘的余数和阶乘逆元的余数
fact[0] = infact[0] = 1;
for (int i = 1; i < N; i ++ )
{
    fact[i] = (LL)fact[i - 1] * i % mod;
    infact[i] = (LL)infact[i - 1] * qmi(i, mod - 2, mod) % mod;
}
int C(int n, int m) {
    if (m < 0 || m > n) return 0;
    return (LL)fact[n] * infact[m] % mod * infact[n - m] % mod;
}
```
=== Lucas 定理
```cpp
int qmi(int a, int k, int p); // 如上
// 通过定理求组合数C(a, b)
int C(int a, int b, int p) {
  if (a < b) return 0;
  LL x = 1, y = 1;  // x是分子，y是分母
  for (int i = a, j = 1; j <= b; i--, j++ )
    x = (LL)x * i % p,
    y = (LL) y * j % p;

  return x * (LL)qmi(y, p - 2, p) % p;
}
int lucas(LL a, LL b, int p) {
  if (a < p && b < p) return C(a, b, p);
  return (LL)C(a % p, b % p, p) * lucas(a / p, b / p, p) % p;
}
```
=== 分解质因数
```cpp
int primes[N], cnt;     // 存储所有质数
int sum[N];     // 存储每个质数的次数
bool st[N];     // 存储每个数是否已被筛掉
// 线性筛
void get_primes(int n) {
  for (int i = 2; i <= n; i ++ ) {
    if (!st[i]) primes[cnt ++ ] = i;
    for (int j = 0; primes[j] <= n / i; j ++ ) {
      st[primes[j] * i] = true;
      if (i % primes[j] == 0) break;
    }
  }
}
// 求n！中的次数
int get(int n, int p) {
  int res = 0;
  while (n) {
    res += n / p;
    n /= p;
  }
  return res;
}
// 高精度乘低精度
vector<int> mul(vector<int> a, int b) {
  vector<int> c;
  int t = 0;
  for (int i = 0; i < a.size(); i ++ ) {
    t += a[i] * b;
    c.push_back(t % 10);
    t /= 10;
  }
  while (t) {
    c.push_back(t % 10);
    t /= 10;
  }
  return c;
}

get_primes(a);  // 预处理范围内的所有质数
// 求每个质因数的次数
for (int i = 0; i < cnt; i ++ ) {
  int p = primes[i];
  sum[i] = get(a, p) - get(b, p) - get(a - b, p);
}
vector<int> res;
res.push_back(1);
for (int i = 0; i < cnt; i ++ )     // 用高精度乘法将所有质因子相乘
  for (int j = 0; j < sum[i]; j ++ )
    res = mul(res, primes[i]);
```
== 卡特兰数
$H_0$到$H_9$的卡特兰数为：

$ 1,1,2,5,14,42,132,429,1430,4862 $

递推公式：

$ H_n={H_{n-1}(4n-2)} / {n+1} $

$ H_n=C_{2n}^{n}-C_{2n}^{n-1} $

$ H_n=sum_{i=1}^n H_{i-1}H_{n-i} $

封闭形式：

$ H_n={C_{2n}^n} / {n+1} $

上述公式中 $n gt.eq ,n in N_+,H_0=1,H_1=1$

应用于以下问题：

- 有 $2n$ 个人排成一行进入剧场。入场费 5 元。其中只有 $n$ 个人有一张 5 元钞票，另外 $n$ 人只有 10 元钞票，剧院无其它钞票，问有多少种方法使得只要有 10 元的人买票，售票处就有 5 元的钞票找零？
- 有一个大小为 $n times n$ 的方格图左下角为 $(0,0)$ 右上角为 $(n,n)$，从左下角开始每次都只能向右或者向上走一单位，不走到对角线 $y=x$ 上方（但可以触碰）的情况下到达右上角有多少可能的路径？
- 在圆上选择 的$2n$ 个点，将这些点成对连接起来使得所得到的 $n$ 条线段不相交的方法数？
- 对角线不相交的情况下，将一个凸多边形区域分成三角形区域的方法数？
- 一个栈（无穷大）的进栈序列为 $1,2,3, dots,n$ 有多少个不同的出栈序列？
- $n$ 个结点可构造多少个不同的二叉树？
- 由 $n$ 个 $+1$ 和 $n$ 个 $-1$ 组成的 $2n$ 个数 $a_1,a_2,  dots,a_{2n}$，其部分和满足 $a_1+a_2+ dots+a_k gt.eq 0 (k=1,2,3, dots,2n)$，有多少个满足条件的数列？

== 简单博弈论

=== Nim 游戏

有 $n$ 堆重量为 $a_1,a_2,a_3, dots,a_n$ 的石子，两名玩家轮流从一堆石子中取出任意个石子，最后没石子可取的人判输

如果 $a_1 xor a_2 xor a_3 xor dots xor a_n$ 为 $0$，则先手必败，如果不为零，则先手必胜
