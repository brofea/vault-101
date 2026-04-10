= 数据结构
== 并查集
```cpp
int p[N]; //存储每个点的祖宗节点

// 返回x的祖宗节点
int find(int x) {
  if (p[x] != x) p[x] = find(p[x]); // 路径压缩
  return p[x];
}
// 初始化，假定节点编号是1~n
for (int i = 1; i <= n; i ++ ) p[i] = i;

// 合并a和b所在的两个集合：
p[find(a)] = find(b);
```
== ST 表
如果需要区间 GCD 就把两个 max 改成 gcd
```cpp
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
== 堆
```cpp
int h[N];  // 存储堆中的值, h[1]是堆顶，x的左儿子是2x, 右儿子是2x + 1
int ph[N]; // 存储第k个插入的点在堆中的位置
int hp[N]; // 存储堆中下标是i的点是第几个插入的
int hsize, idx = 0;
void heap_swap(int a, int b) {  // 交换两个点
  swap(ph[hp[a]], ph[hp[b]]);
  swap(hp[a], hp[b]);
  swap(h[a], h[b]);
}
void down(int u) {
  int t = u;
  if (u * 2 <= hsize && h[u * 2] < h[t])
    t = u * 2;
  if (u * 2 + 1 <= hsize && h[u * 2 + 1] < h[t])
    t = u * 2 + 1;
  if (u != t) {
    heap_swap(u, t);
    down(t);
  }
}
void up(int u) {
  while (u / 2 && h[u] < h[u / 2]) {
    heap_swap(u, u / 2);
    u >>= 1;
  }
}
void build() {  // 原地建堆O(n)
  cin >> hsize;
  idx = hsize;
  for (int i = 1; i <= hsize; i++)
    cin >> h[i], ph[i] = i, hp[i] = i;
  for (int i = hsize / 2; i; i--)
    down(i);
} 
void push(int x) {
  hsize++;
  idx++;
  ph[idx] = hsize;
  hp[hsize] = idx;
  h[hsize] = x;
  up(hsize);
}
void remove(int k) {  // 删除第 k 个插入的元素
  int pos = ph[k];
  heap_swap(pos, hsize); // 交换到堆尾
  hsize--; // 删除
  down(pos);up(pos);
}
void change(int k, int x) { // 修改第 k 个插入的元素为 x
  int pos = ph[k];
  h[pos] = x;      // 修改值
  down(pos);up(pos);
}
remove(hp[1]);    // 弹出堆顶，记得判断hsize是否为0
h[1];             // 堆顶，记得判断hsize是否为0
```
== 树状数组
单点改区间查
```cpp
int n, tr[N];     // 数据个数、树状数组
int a[N];
int lowbit(int x) { return x & -x; }
// 将x位置加上c
void update(int x, int c) {
  for (int i = x; i <= n; i += lowbit(i))
    tr[i] += c;
}
// 查询[1,x]的和
int query(int x) {
  int res = 0;
  for (int i = x; i; i -= lowbit(i))
    res += tr[i];
  return res;
}
// 快速初始化(区间和)
int pre[N];  // 前缀和数组
for (int i = 1; i <= n; i++)
  cin >> a[i], pre[i] = pre[i - 1] + a[i];
for (int i = 1; i <= n; i++)
  tr[i] = pre[i] - pre[i - lowbit(i)];
// 初始化(通用)
for (int i = 1; i <= n; i++)
cin >> a[i], update(i, a[i]);

// 维护区间异或和：只需修改两个函数的 += 为 ^=
// 维护前缀最大值：只需修改两函数 += 为 max 函数
// 二维树状数组：将tr改为二维，两函数增加一层循环
```

区间改区间查
```cpp
int t1[N], t2[N], n;
int lowbit(int x) { return x & (-x); }
void add(int k, int v) {
  int v1 = k * v;
  while (k <= n) {
    t1[k] += v, t2[k] += v1;
    // 注意不能写成 t2[k] += k * v，因为 k 的值已经不是原数组的下标了
    k += lowbit(k);
  }
}
int getsum(int *t, int k) {
  int ret = 0;
  while (k) {
    ret += t[k];
    k -= lowbit(k);
  }
  return ret;
}
void add1(int l, int r, int v) {
  add(l, v), add(r + 1, -v);  // 将区间加差分为两个前缀加
}
ll getsum1(int l, int r) {
  return (r + 1ll) * getsum(t1, r) - 1ll * l * getsum(t1, l - 1) -
         (getsum(t2, r) - getsum(t2, l - 1));
}
```

== 线段树

=== 朴素线段树
支持区间查询单点修改

区间最大值
```cpp  
int n;
struct Node {
  int l, r, val;
} tr[N * 4];
void pushup(int u) { tr[u].val = max(tr[u << 1].val, tr[u << 1 | 1].val); }
// build(1, 1, n) 建树
void build(int u, int l, int r) {
  // 1、记录区间信息
  tr[u].l = l;
  tr[u].r = r;
  tr[u].val = 0;
  // 2、如果区间仅有一个数返回
  if (l == r) {
    tr[u].val = 0;
    return;
  }
  // 3、递归建树
  int mid = (l + r) >> 1;
  build(u << 1, l, mid);
  build(u << 1 | 1, mid + 1, r);
  // 4、pushup, 由于建空树，所以不需要
}
// query(1, l, r) 查询[l,r]区间的最大值
int query(int u, int l, int r) {
  // 情况1:被包含
  if (l <= tr[u].l && tr[u].r <= r)
    return tr[u].val;
  // 情况2:有交集
  int mid = (tr[u].l + tr[u].r) >> 1;
  int tmp = INT_MIN;
  if (l <= mid)
    tmp = max(tmp, query(u << 1, l, r));
  if (mid < r)
    tmp = max(tmp, query(u << 1 | 1, l, r));
  return tmp;
}
//  modify(1, x, val) 将单点 x 修改为val
void modify(int u, int x, int val) {
  if (tr[u].l == x && tr[u].r == x) {
    tr[u].val = val;
    return;
  }
  int mid = (tr[u].l + tr[u].r) >> 1;
  if (x <= mid)
    modify(u << 1, x, val);
  else
    modify(u << 1 | 1, x, val);
  pushup(u);
}
```
区间最大子段和
```cpp
int n, a[N];
struct Node {
  int l, r; // 区间端点
  int tmax, lmax, rmax, sum; // 子段和 前缀和 后缀和 区间和
} tr[N * 4];
inline void pushup(Node &u, Node &l, Node &r) {
  u.sum = l.sum + r.sum;
  u.tmax = max(l.rmax + r.lmax, max(l.tmax, r.tmax));
  u.lmax = max(l.lmax, l.sum + r.lmax);
  u.rmax = max(r.rmax, r.sum + l.rmax);
}
inline void pushup(int u) { pushup(tr[u], tr[u << 1], tr[u << 1 | 1]); }
// build(1, 1, n) 用 a[n] 建树  
void build(int u, int l, int r) {
  tr[u].l = l;
  tr[u].r = r;
  if (l == r) {
    tr[u].lmax = tr[u].rmax = tr[u].tmax = tr[u].sum = a[l];
    return;
  }
  int mid = (l + r) >> 1;
  build(u << 1, l, mid);
  build(u << 1 | 1, mid + 1, r);
  pushup(u);
}
// query(1, x, y).tmax 查询区间[x,y]的最大子段和
Node query(int u, int l, int r) {
  if (l <= tr[u].l && tr[u].r <= r)
    return tr[u];
  int mid = (tr[u].l + tr[u].r) >> 1;
  if (r <= mid)
    return query(u << 1, l, r);
  else if (l > mid)
    return query(u << 1 | 1, l, r);
  else {
    Node left = query(u << 1, l, r);
    Node right = query(u << 1 | 1, l, r);
    Node res;
    pushup(res, left, right);
    return res;
  }
}
// modify(1, x, y) 将单点x修改为y
void modify(int u, int x, int v) {
  if (tr[u].l == x && tr[u].r == x) {
    tr[u].lmax = tr[u].rmax = tr[u].tmax = tr[u].sum = v;
    return;
  }
  int mid = (tr[u].l + tr[u].r) >> 1;
  if (x <= mid)
    modify(u << 1, x, v);
  else
    modify(u << 1 | 1, x, v);
  pushup(u);
}
```
区间最大公约数
```cpp
ll n, m, a[N];
struct Node {
  int l, r;
  ll gcd, sum; // 区间和sum也要维护
} tr[4 * N];   // 此线段树维护的是差分
ll gcd(ll a, ll b) {
  return b ? gcd(b, a % b) : llabs(a); // 要考虑负数
}
void pushup(Node &u, Node &l, Node &r) {
  u.gcd = gcd(l.gcd, r.gcd);
  u.sum = l.sum + r.sum;
}
void pushup(int u) {
  pushup(tr[u], tr[u << 1], tr[u << 1 | 1]); // 所有的访问子节点都是<<
}
// build(1, 1, n) 用 a[n] 建树
void build(int u, int l, int r) {
  // 1、记录区间端点
  tr[u].l = l;
  tr[u].r = r;
  // 2、如果找到叶节点，输入信息并返回
  if (l == r) {
    tr[u].gcd = a[l] - a[l - 1];
    tr[u].sum = a[l] - a[l - 1];  // 差分
    return;
  }
  // 3、递归求子区间
  int mid = (l + r) >> 1; // 所有的求mid都是>>
  build(u << 1, l, mid);
  build(u << 1 | 1, mid + 1, r);
  // 4、子区间全部计算完成，pushup当前节点，给当前节点赋值
  pushup(u);
}
void modify(int u, int x, ll v) { // v是数值不是区间要ll
  // 1、如果找到叶节点就修改值并返回
  if (tr[u].l == x && tr[u].r == x) {
    tr[u].sum += v;
    tr[u].gcd = abs(tr[u].sum); // 处理负数
    return;                     // 找到叶节点记得立刻返回
  }
  // 2、如果没有找到递归找子区间
  int mid = (tr[u].l + tr[u].r) >> 1;
  if (x <= mid)
    modify(u << 1, x, v);
  else
    modify(u << 1 | 1, x, v);
  // 3、下方完成计算，pushup当前节点
  pushup(u);
}
Node query(int u, int l, int r) {
  // 情况1、区间完全被包含
  if (l <= tr[u].l && tr[u].r <= r) {
    return tr[u]; // 在区间内了就返回
  }
  // 情况2和3、区间在左右子区间内
  int mid = (tr[u].l + tr[u].r) >> 1;
  if (r <= mid)
    return query(u << 1, l, r);
  else if (l > mid)
    return query(u << 1 | 1, l, r);
  // 情况4、区间横跨左右子区间
  else {
    Node left = query(u << 1, l, r);
    Node right = query(u << 1 | 1, l, r);
    Node res;
    pushup(res, left, right);
    return res;
  }
}
// 查询区间[l,r]的gcd
abs(query(1, 1, l).sum); // l == r 特判
gcd(query(1, 1, l).sum, query(1, l + 1, r).gcd);

// 将区间[l,r]的值加上d
modify(1, l, d);
if (r + 1 <= n) modify(1, r + 1, -d);
```
=== 惰性线段树
支持区间查询区间修改

区间加
```cpp
int n, a[N];
struct Node {
  int l, r;
  ll sum;
  ll add;
} tr[N * 4];
void pushup(int u) { tr[u].sum = tr[u << 1].sum + tr[u << 1 | 1].sum; }
void pushdown(int p) {
  Node &u = tr[p], &l = tr[p << 1], &r = tr[p << 1 | 1];
  if (u.add != 0) {
    l.sum += (l.r - l.l + 1) * u.add;
    r.sum += (r.r - r.l + 1) * u.add;
    l.add += u.add;
    r.add += u.add;
    u.add = 0;
  }
}
// build(1, 1, n) 用a[n]建树
void build(int u, int l, int r) {
  tr[u].l = l;
  tr[u].r = r;
  if (l == r) {
    tr[u].sum = a[l];
    return;
  }
  int mid = (l + r) >> 1;
  build(u << 1, l, mid);
  build(u << 1 | 1, mid + 1, r);
  pushup(u);
}
// modify(1, x, y, k) 给区间[x,y]加上k
void modify(int p, int l, int r, ll d) {
  Node &u = tr[p];
  if (l <= u.l && u.r <= r) {
    u.sum += (u.r - u.l + 1) * d;
    u.add += d;
    return;
  }
  pushdown(p);
  int mid = (u.l + u.r) >> 1;
  if (l <= mid)
    modify(p << 1, l, r, d);
  if (r > mid)
    modify(p << 1 | 1, l, r, d);
  pushup(p);
}
// query(1, x, y) 求区间[x,y]的和
ll query(int p, int l, int r) {
  Node &u = tr[p];
  if (l <= u.l && u.r <= r)
    return u.sum;
  pushdown(p);
  int mid = (u.l + u.r) >> 1;
  ll res = 0;
  if (l <= mid)
    res += query(p << 1, l, r);
  if (r > mid)
    res += query(p << 1 | 1, l, r);
  return res;
}
```
区间加区间乘

```cpp
int n, MOD, a[N];
struct Node {
  int l, r, sum, add, mul;
} tr[N * 4];
void pushup(int u) {
  // 任何有设计加法乘法都先强制转换为ll
  tr[u].sum = ((ll)tr[u << 1].sum + tr[u << 1 | 1].sum) % MOD;
}
// 关键在于两个互相影响的懒标记如何维护：calc和pushdown函数
void calc(Node &t, int add, int mul) {
  t.sum = ((ll)t.sum * mul + (ll)(t.r - t.l + 1) * add) % MOD;
  t.mul = (ll)t.mul * mul % MOD;
  t.add = ((ll)t.add * mul + add) % MOD;
}
void pushdown(int u) {
  calc(tr[u << 1], tr[u].add, tr[u].mul);
  calc(tr[u << 1 | 1], tr[u].add, tr[u].mul);
  tr[u].add = 0, tr[u].mul = 1;
}
// build(1, 1, n) 用 a[n] 建树
void build(int p, int l, int r) {
  Node &u = tr[p];
  u.l = l, u.r = r;
  u.add = 0, u.mul = 1;
  if (l == r) {
    u.sum = a[l];
    return;
  }
  int mid = (l + r) >> 1;
  build(p << 1, l, mid);
  build(p << 1 | 1, mid + 1, r);
  pushup(p);
}
// modify(1, x, y, a, d) 将区间先乘以 d 再加上 a 
void modify(int p, int l, int r, int add, int mul) {
  Node &u = tr[p];
  if (l <= u.l && u.r <= r) {
    calc(u, add, mul);
    return;
  }
  pushdown(p);
  int mid = (u.l + u.r) >> 1; // 这里不是修改的区间的中点，不是(l+r)>>1
  if (l <= mid)
    modify(p << 1, l, r, add, mul);
  if (r > mid)
    modify(p << 1 | 1, l, r, add, mul);
  pushup(p);
}
// query(1, x, y) 查询区间 [x,y] 的和
ll query(int p, int l, int r) {
  Node &u = tr[p];
  if (l <= u.l && u.r <= r)
    return u.sum;
  pushdown(p);
  int mid = (u.l + u.r) >> 1;
  ll res = 0; // 这里的mid同理
  if (l <= mid)
    res = query(p << 1, l, r);
  if (r > mid)
    res += query(p << 1 | 1, l, r);
  res %= MOD;
  return res;
}
```
== 平衡树
=== Treap
```cpp
int n;
struct Node {
  int l, r;
  int k;
  int val; // 堆中的编号
  int cnt, size;
} tr[N];
int root, idx;
void pushup(int u) {
  tr[u].size =
      tr[tr[u].l].size + tr[tr[u].r].size + tr[u].cnt; // 上传节点信息，更新size
}
int new_node(int k) {
  tr[++idx].k = k;
  tr[idx].val = rand(); // 尽量随机，随手给个就行
  tr[idx].cnt = 1;
  tr[idx].size = 1;
  return idx;
}
void zig(int &u) // 左旋
{
  int q = tr[u].l;
  tr[u].l = tr[q].r;
  tr[q].r = u;
  u = q;
  pushup(tr[u].r);
  pushup(u); // 最后一定要记得上传，不然完了
}
void zag(int &u) { // 右旋
  int q = tr[u].r;
  tr[u].r = tr[q].l;
  tr[q].l = u;
  u = q;
  pushup(tr[u].l);
  pushup(u);
}
void build() // 建树操作，为了正确性增加两个哨兵，防止越界
{
  new_node(-INF), new_node(INF);
  root = 1, tr[1].r = 2; // 初始化一下
  pushup(root);          // 上传信息
  if (tr[1].val < tr[2].val)
    zag(root); // 不平衡了就旋转
}
void insert(int &u, int k) {
  if (u == 0)
    u = new_node(k); // 如果走到空了，就新建
  else {
    if (tr[u].k == k) // 如果找到了相同的节点，就cnt++
    {
      tr[u].cnt++;
    } else {
      if (tr[u].k > k) // 否则看看是在左边还是在右边
      {
        insert(tr[u].l, k);
        if (tr[tr[u].l].val > tr[u].val)
          zig(u); // 不平衡立马调整
      } else {
        insert(tr[u].r, k);
        if (tr[tr[u].r].val > tr[u].val)
          zag(u);
      }
    }
  }
  pushup(u); // 最后上传一下
}
void del(int &u, int k) // 删除操作
{
  if (u == 0)
    return;         // 如果没了说明节点不存在，就不管了。
  if (tr[u].k == k) // 如果找到了这个点
  {
    if (tr[u].cnt > 1)
      tr[u].cnt--; // 大于一好说，直接cnt --
    else           // 不大于一
    {
      if (tr[u].l || tr[u].r) // 先看看是不是叶节点
      {
        if (!tr[u].r || tr[tr[u].l].val) {
          zig(u);
          del(tr[u].r, k); // 记得维护平衡
        } else {
          zag(u);
          del(tr[u].l, k);
        }
      } else
        u = 0; // 是的话不用考虑平衡问题，直接删就是了
    }
  } else if (tr[u].k > k)
    del(tr[u].l, k); // 如果没有找到就判断一下在左右两边的哪一边
  else
    del(tr[u].r, k); // 找一下
  pushup(u);         // 上传更改
}
int get_rank(int u, int k) {
  if (u == 0)
    return 1; // 是 0 随便返回就行
  if (tr[u].k == k)
    return tr[tr[u].l].size + 1; // 相等了那排名应该就是左边的数量加上自己
  if (tr[u].k > k)
    return get_rank(tr[u].l, k);                              // 大了找左边
  return tr[tr[u].l].size + tr[u].cnt + get_rank(tr[u].r, k); // 找右边
}
int get_key(int u, int rank) {
  if (u == 0)
    return INF;
  if (tr[tr[u].l].size >= rank)
    return get_key(tr[u].l, rank); // 找左边
  if (tr[tr[u].l].size + tr[u].cnt >= rank)
    return tr[u].k; // 如果满足条件就直接return
  return get_key(tr[u].r, rank - tr[tr[u].l].size - tr[u].cnt); // 不然就找右边
}
int get_pr(int u, int k) // 前驱
{
  if (u == 0)
    return -INF;
  if (tr[u].k >= k)
    return get_pr(tr[u].l, k); // 找左边
  return max(get_pr(tr[u].r, k), tr[u].k); // 可能是右边可能是这个数，所以用个max
}
int get_ne(int u, int k) // 后继
{
  if (u == 0)
    return INF; // 后继的写法和前驱相反，大家可以注意一下
  if (tr[u].k <= k)
    return get_ne(tr[u].r, k);
  return min(get_ne(tr[u].l, k), tr[u].k);
}
int main() {
  build(); // 建树，要是忘了就凉了
  cin >> n;
  while (n--) {
    int op, x;
    cin >> op >> x;
    if (op == 1)         // 插入数值 x
      insert(root, x);
    else if (op == 2)    // 删除数值 x (若有多个相同的数，应只删除一个)
      del(root, x);
    else if (op == 3)    // 查询数值 x 的排名(若有多个相同的数，应输出最小的排名)
      cout << get_rank(root, x) - 1 << endl;
    else if (op == 4)    // 查询排名为 x 的数值
      cout << get_key(root, x + 1) << endl;
    else if (op == 5)    // 求数值 x 的前驱(前驱定义为小于 x 的最大的数)
      cout << get_pr(root, x) << endl;
    else if (op == 6)    // 求数值 x 的后继(后继定义为大于 x 的最小的数)。
      cout << get_ne(root, x) << endl;
  }
  return 0;
}
```