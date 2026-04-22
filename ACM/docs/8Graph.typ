= 图论
== 基础
\
*链式前向星*
```cpp
// 如果是无向图 M 要乘 2
int h[N], e[M], ne[M], idx = 0;
// 添加一条边 a->b
void add(int a, int b)
{
  e[idx] = b;
  ne[idx] = h[a];
  h[a] = idx++;
}
// 记得初始化
memset(h, -1, sizeof h);
```
*拓扑排序*
```cpp
queue<int> q; // 所有0入度点
vector<int> topo; // 拓扑序答案
while(!q.empty()){
	int tmp = q.front();
	topo.push_back(tmp);
	q.pop();
	while(枚举点tmp所有的出边){
		删除该边
		d[j]--; // 指向的点入度减一
		if(d[j] == 0) q.push_back(j);
	}
}
```
== 最短路
- 稠密图：朴素 Dijkstra $O(n^2)$
- 稀疏图：堆优化 Dijkstra $O(m log n)$
- 负边权：Bellman-Ford $O(n m)$
- 负边权常用：SPFA $O(m)$ 
- 多源汇：Floyd $O(n^3)$

=== 朴素 Dijkstra

临接矩阵模板
```cpp
int g[N][N]; // 存储每条边
int dist[N]; // 存储1号点到每个点的最短距离
bool st[N];  // 存储每个点的最短路是否已经确定

// 求1号点到n号点的最短路，如果不存在则返回-1
int dijkstra() {
  memset(dist, 0x3f, sizeof dist);
  dist[1] = 0;

  for (int i = 0; i < n - 1; i++) {
    int t = -1; // 在还未确定最短路的点中，寻找距离最小的点
    for (int j = 1; j <= n; j++)
      if (!st[j] && (t == -1 || dist[t] > dist[j]))
        t = j;

    // 用t更新其他点的距离
    for (int j = 1; j <= n; j++)
      dist[j] = min(dist[j], dist[t] + g[t][j]);

    st[t] = true;
  }

  if (dist[n] == 0x3f3f3f3f)
    return -1;
  return dist[n];
}
```
临接表模板
```cpp
#include <bits/stdc++.h>
using namespace std;
const int N = 1e4 + 5; // 最大点数
const int M = 5e5 + 5; // 最大边数
// 邻接表
int head[N], ver[M];  // 表头 边的终点
int edge[M], Next[M]; // 边的权值 下一条边的编号
int idx = 0;
void add(int u, int v, int w) {
  ver[idx] = v;
  edge[idx] = w;
  Next[idx] = head[u];
  head[u] = idx++;
}
// Dijkstra
int dis[N], parent[N]; // 距离数组 父节点
bool vis[N];           // 是否已经是最短路径
int main() {
  // 初始化
  memset(head, -1, sizeof head);
  memset(dis, 0x3f, sizeof dis);
  memset(vis, false, sizeof vis);
  // 输入
  int n, m, s; // 点数 边数 起点
  cin >> n >> m >> s;
  for (int i = 0; i < m; i++) {
    int u, v, w;
    cin >> u >> v >> w;
    add(u, v, w);
  }
  // Dijkstra
  dis[s] = 0;
  for (int i = 0; i < n - 1; i++) { // 循环到n-1即可
    // 1、找到vis为false，距离dis最小的点
    int t = -1;
    for (int j = 1; j <= n; j++)
      if (vis[j] == false && (t == -1 || dis[j] < dis[t]))
        t = j;
    // 2、记录点t已经是最短路
    if (t == -1)
      break;
    vis[t] = true;
    // 3、用点t更新其他点的距离
    int it = head[t];
    while (it != -1) {
      int nx = ver[it]; // 由点t为起点的边下一个点
      dis[nx] = min(dis[nx], dis[t] + edge[it]);
      it = Next[it];
    }
  }
  // 输出答案
  for (int i = 1; i <= n; i++) {
    if (dis[i] != 0x3f3f3f3f)
      cout << dis[i] << ' ';
    else
      cout << INT_MAX << ' ';
  }
  cout << endl;
}
```

=== 堆优化 Dijkstra
临接表模板
```cpp
int n;                            // 点的数量
int h[N], w[N], e[N], ne[N], idx = 0; // 邻接表存储所有边
int dist[N];                      // 存储所有点到1号点的距离
bool st[N]; // 存储每个点的最短距离是否已确定

// 求1号点到n号点的最短距离，如果不存在，则返回-1
int dijkstra() {
  // 初始化 dis 数组全为正无限，初始化起点的 dis 为 0
  memset(dist, 0x3f, sizeof dist);
  dist[1] = 0;
  priority_queue<PII, vector<PII>, greater<PII>> heap;
  heap.push({0, 1}); // first存储距离，second存储节点编号

  while (heap.size()) {
    // 寻找未确定最短路的点中的 dis 最小的点，记为 t
    auto t = heap.top();
    heap.pop();
    int ver = t.second, distance = t.first;
    // 如果 t 的最短路已经确定，则跳过
    if (st[ver])
      continue;
    // 将 t 的最短路设为已确定
    st[ver] = true;
    // 更新 t 的所有出边
    for (int i = h[ver]; i != -1; i = ne[i]) {
      int j = e[i];
      if (dist[j] > distance + w[i]) {
        dist[j] = distance + w[i];
        heap.push({dist[j], j});
      }
    }
  }

  if (dist[n] == 0x3f3f3f3f)
    return -1;
  return dist[n];
}
```
=== Bellman-Ford
```cpp
int n, m;    // n表示点数，m表示边数
int dist[N]; // dist[x]存储1到x的最短路距离

struct Edge // 边，a表示出点，b表示入点，w表示边的权重
{
  int a, b, w;
} edges[M];

// 求1到n的最短路距离，如果无法从1走到n，则返回-1。
int bellman_ford() {
  // 初始化所有的 dis 为无限大，设置起点 dis 为 0
  memset(dist, 0x3f, sizeof dist);
  dist[1] = 0;
  // 循环 n 次
  for (int i = 0; i < n; i++) {
    // 每次遍历所有的边 
    for (int j = 0; j < m; j++) {
      // 松弛边
      int a = edges[j].a, b = edges[j].b, w = edges[j].w;
      if (dist[b] > dist[a] + w)
        dist[b] = dist[a] + w;
    }
  }
  if (dist[n] > 0x3f3f3f3f / 2)
    return -1;
  return dist[n];
}
// 如果第n次迭代仍然会松弛三角不等式，就说明存在一条长度是n+1的最短路径，图中存在负权回路
```
=== SPFA
```cpp
int n;                            // 总点数
int h[N], w[N], e[N], ne[N], idx; // 邻接表存储所有边
int dist[N];                      // 存储每个点到1号点的最短距离
bool st[N];                       // 存储每个点是否在队列中
// 求1号点到n号点的最短路距离，如果从1号点无法走到n号点则返回-1
int spfa() {
  // 初始化 dis 数组全为正无限，初始化起点的 dis 为 0
  memset(dist, 0x3f, sizeof dist);
  dist[1] = 0;
  // 起点入队
  queue<int> q;
  q.push(1);
  st[1] = true;
  while (q.size()) {
    // 将队头点 t 取出
    auto t = q.front();
    q.pop();
    st[t] = false;
    // 更新 t 的所有出边，如果有点被更新就入队
    for (int i = h[t]; i != -1; i = ne[i]) {
      int j = e[i];
      if (dist[j] > dist[t] + w[i]) {
        dist[j] = dist[t] + w[i];
        if (!st[j]) // 如果队列中已存在j，则不需要将j重复插入
        {
          q.push(j);
          st[j] = true;
        }
      }
    }
  }
  if (dist[n] == 0x3f3f3f3f)
    return -1;
  return dist[n];
}
```
=== Floyd-Warshall
```cpp
// 初始化：
for (int i = 1; i <= n; i++)
  for (int j = 1; j <= n; j++)
    if (i == j) d[i][j] = 0;
    else d[i][j] = INF;
/* 输入 */
// 算法结束后，d[a][b]表示a到b的最短距离
void floyd() {
  for (int k = 1; k <= n; k++)
    for (int i = 1; i <= n; i++)
      for (int j = 1; j <= n; j++)
        d[i][j] = min(d[i][j], d[i][k] + d[k][j]);
}
```
== 最小生成树
\
- 稠密图：朴素 Prim $O(n^2)$
- 稀疏图：堆优化 Prim $O(m log n)$
- 稀疏图常用：Kruskal $O(m log n)$
=== Prim
```cpp
int n;       // n表示点数
int g[N][N]; // 邻接矩阵，存储所有边
int dist[N]; // 存储其他点到当前最小生成树的距离
bool st[N];  // 存储每个点是否已经在生成树中

// 如果图不连通，则返回INF(值是0x3f3f3f3f), 否则返回最小生成树的树边权重之和
int prim() {
  // 初始化 dist 为正无限
  memset(dist, 0x3f, sizeof dist);
  // 循环 n 次（加点 n 次）
  int res = 0;
  for (int i = 0; i < n; i++) {
    // 找到离集合最近的点 t（ dis最小 ）
    int t = -1;
    for (int j = 1; j <= n; j++)
      if (!st[j] && (t == -1 || dist[t] > dist[j]))
        t = j;
    // 如果最近点 t 的距离为正无限，则说明图不连通
    if (i && dist[t] == INF)
      return INF;
    // 如果 t 是第一个点，则不需要加上它的距离
    if (i)
      res += dist[t];
    // 标记点 t 已经在树中
    st[t] = true;
    // 用 t 更新其他点的距离
    for (int j = 1; j <= n; j++)
      dist[j] = min(dist[j], g[t][j]);
  }
  return res;
}
```
=== Kruskal
```cpp
int n, m; // n是点数，m是边数
int p[N]; // 并查集的父节点数组
struct Edge // 存储边
{
  int a, b, w;
  bool operator<(const Edge &W) const { return w < W.w; }
} edges[M];
int find(int x) // 并查集
{
  if (p[x] != x) p[x] = find(p[x]);
  return p[x];
}
int kruskal() {
  // 按权排序所有边 
  sort(edges, edges + m);
  // 初始化并查集
  for (int i = 1; i <= n; i++)
    p[i] = i; 
  // 枚举每条边
  int res = 0, cnt = 0;
  for (int i = 0; i < m; i++) {
    // 对于边a->b,如果a和b不在同一集合中,则加入边
    int a = edges[i].a, b = edges[i].b, w = edges[i].w;
    a = find(a), b = find(b);
    if (a != b) {
      p[a] = b;
      res += w;
      cnt++;
    }
  }
  if (cnt < n - 1)
    return INF;
  return res;
}
```

== 二分图
\
- 染色法 $O(n+m)$
- 匈牙利算法 $O(n m)$ （实际运行远小于 $O(n m)$）

=== 染色法
```cpp
int n;                      // n表示点数
int h[N], e[M], ne[M], idx; // 邻接表存储图
int color[N]; // 表示每个点的颜色，-1表示未染色，0表示白色，1表示黑色

// 参数：u表示当前节点，c表示当前点的颜色
bool dfs(int u, int c) {
  color[u] = c;
  // 遍历 u 的所有出边，如果未染色则染相反色，如果已染色则判断是否矛盾
  for (int i = h[u]; i != -1; i = ne[i]) {
    int j = e[i];
    if (color[j] == -1) {
      if (!dfs(j, !c))
        return false;
    } else if (color[j] == c)
      return false;
  }
  return true;
}

bool check() {
  memset(color, -1, sizeof color);
  bool flag = true;
  for (int i = 1; i <= n; i++)
    if (color[i] == -1)  // 点 i 未染色
      if (!dfs(i, 0)) {  // 染色为 0
        flag = false;    // 染色失败说明不是二分图
        break;
      }
  return flag;
}
```
=== 匈牙利算法
```cpp
int n1, n2; // n1表示第一个集合中的点数，n2表示第二个集合中的点数
int h[N], e[M], ne[M], idx; // 邻接表存储所有边，匈牙利算法中只会用到从第一个集合指向第二个集合的边，所以这里只用存一个方向的边
int match[N]; // 存储第二个集合中的每个点当前匹配的第一个集合中的点是哪个
bool st[N];   // 表示第二个集合中的每个点是否已经被遍历过

bool find(int x) {
  for (int i = h[x]; i != -1; i = ne[i]) {
    int j = e[i];
    if (!st[j]) {
      st[j] = true;
      if (match[j] == 0 || find(match[j])) {
        match[j] = x;
        return true;
      }
    }
  }
  return false;
}
// 求最大匹配数，依次枚举第一个集合中的每个点能否匹配第二个集合中的点
int res = 0;
for (int i = 1; i <= n1; i++) {
  memset(st, false, sizeof st);
  if (find(i)) res++;
}
```
== 联通性
=== Tarjan

给定邻接表 e，求图中强连通分量的数量 scc_cnt，以及每个点所在的强连通分量编号 id

```cpp
vector<vector<int>> e;           // 邻接表
int dfn[N], low[N], timestamp;   // 时间戳
int id[N], scc_cnt;              // 强连通分量编号
stack<int> stk; bool instk[N];   // 栈

void tarjan(int u) {
  dfn[u] = low[u] = ++timestamp;
  stk.push(u), instk[u] = true;

  for (int v : e[u]) {
    if (!dfn[v])
      tarjan(v), low[u] = min(low[u], low[v]);
    else if (instk[v])
      low[u] = min(low[u], dfn[v]);
  }
  if (low[u] == dfn[u]) {
    scc_cnt++;
    int y;
    do {
      y = stk.top();
      stk.pop();
      instk[y] = false;
      id[y] = scc_cnt;
    } while (y != u);
  }
}

for (int i = 1; i <= n; ++i)
  if (!dfn[i])
    tarjan(i);
```