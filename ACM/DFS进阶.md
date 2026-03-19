---
标签:
  - 搜索
难度:
  - ★★
---
DFS 相比 BFS 使用的空间更少，但是运行时存在爆栈风险

DFS 可以分为两类，第一种外部搜索，类似整体在进行状态变化，需要回溯和恢复现场，第二种内部搜索，类似在棋盘内部走棋，不需要显式恢复现场

# 连通性模型

类似于 BFS 中的洪水填充，适合做“染色”、“标号”、“计数”等任务，BFS 在每一层需要存大量节点所以相比之下 DFS 空间使用更少

### **例题：Lake Counting**

> [落谷 - P1596 [USACO10OCT] Lake Counting S](https://www.luogu.com.cn/problem/P1596)  
> Due to recent rains, water has pooled in various places in Farmer John's field, which is represented by a rectangle of N…  

# 预处理和搜索顺序

选择合适的搜索顺序可以提高效率

### 例题：单词接龙

预处理好所有可能的接龙情况，搜索时无需对字符串本身进行判断

> [落谷 - P1019 [NOIP 2000 提高组] 单词接龙](https://www.luogu.com.cn/problem/P1019)  
> 注意：本题为上古 NOIP 原题，不保证存在靠谱的做法能通过该数据范围下的所有数据。 本题为搜索题，本题不接受 hack 数据。关于此类题目的详细内容 NOIP2000 提高组 T3  

[洛谷 P1019 单词接龙](https://www.notion.so/P1019-1cb83793b8f680138699e084d8ec307c?pvs=21)

### 例题：分成互质组

按照组的顺序搜索而非数的顺序搜索，大幅提高效率

> [OpenJudge - 7834:分成互质组](http://noi.openjudge.cn/ch0205/7834/)  
>  

[noiOJ 7834 分成互质组](https://www.notion.so/noiOJ-7834-1cb83793b8f6801e83ddedf1dc15a92d?pvs=21)

# 剪枝

根据《算法竞赛进阶指南》，有五种常见的剪枝方法，

- 优化搜索顺序（影响很大，要最先考虑）

- 排除等效冗余（如果沿着不同分支到达的子树是等效的，那么只需要搜一次）

- 可行性剪枝（又称上下界剪枝）

- 最优性剪枝（当前搜索深度已经超过了已找到的最优解）

- 记忆化搜索

### 例题：小猫爬山

优化搜索顺序，对小猫排序按照从重到轻分配，而非按照缆车的安排来搜索。可加入最优性剪枝

> [落谷 - P10483 小猫爬山](https://www.luogu.com.cn/problem/P10483)  
> Freda 和 rainbow 饲养了 N(N\le 18) 只小猫，这天，小猫们要去爬山。经历了千辛万苦，小猫们终于爬上了山顶，但是疲倦的它们再也不想徒步走下山了 Freda 和 rainbow 只好花钱让它们坐索道下山。索道上的缆车最大承重量为…  

- AC 代码
    
    ```C++
    \#include <bits/stdc++.h>using namespace std;
    const int N = 20;
    int n, c[N], w, ans = 21, g[N];
    void dfs(int gp, int cur) {
      if (gp >= ans) return;
      if (cur > n) {
        ans = min(ans, gp);
        return;
      }
      for (int i = 1; i <= gp; ++i) {
        if (c[cur] > g[i]) continue;
        g[i] -= c[cur];
        dfs(gp, cur + 1);
        g[i] += c[cur];
      }
      g[gp + 1] -= c[cur];
      dfs(gp + 1, cur + 1);
      g[gp + 1] += c[cur];
    }
    int main() {
      cin >> n >> w;
      for (int i = 1; i <= n; ++i) {
        cin >> c[i];
        g[i] = w;
      }
      ans = n;
      sort(c + 1, c + n + 1, greater<int>());
      dfs(1, 1);
      cout << ans << endl;
      return 0;
    }
    ```
    

### 例题：数独

可行性剪枝练习题，使用位运算来记录行列和九宫格某个数是否被使用过，要注意操作时使用与还是或

> [落谷 - P1784 数独](https://www.luogu.com.cn/problem/P1784)  
> 数独是根据 9 \times 9 盘面上的已知数字，推理出所有剩余空格的数字，并满足每一行、每一列、每一个粗线宫内的数字均含 1 - 9 ，不重复。每一道合格的数独谜题都有且仅有唯一答案，推理方法也以此为基础，任何无解或多解的题目都是不合格的。…  

- AC 代码
    
    ```C++
    \#include <bits/stdc++.h>
    using namespace std;
    \#define cq(x) ((x - 1) / 3 + 1)
    const int N = 12;
    int mp[N][N], row[N], col[N], sq[4][4];
    vector<pair<int, int> > space;
    void dfs(int idx) {
      if (idx >= space.size()) {
        for (int i = 1; i <= 9; ++i)
          for (int j = 1; j <= 9; ++j)
            cout << mp[i][j] << " \n"[j == 9];
        exit(0);
      }
      int x = space[idx].first, y = space[idx].second;
      int r = cq(x), c = cq(y);
      for (int i = 1; i <= 9; ++i) {
        if (row[x] >> (i - 1) & 1) continue;
        if (col[y] >> (i - 1) & 1) continue;
        if (sq[r][c] >> (i - 1) & 1) continue;
        mp[x][y] = i;
        row[x] |= 1 << (i - 1);
        col[y] |= 1 << (i - 1);
        sq[r][c] |= 1 << (i - 1);
        dfs(idx + 1);
        mp[x][y] = 0;
        row[x] &= ~(1 << (i - 1));
        col[y] &= ~(1 << (i - 1));
        sq[r][c] &= ~(1 << (i - 1));
      }
    }
    int main() {
      for (int i = 1; i <= 9; ++i) {
        for (int j = 1; j <= 9; ++j) {
          cin >> mp[i][j];
          if (mp[i][j] == 0) {
            space.push_back(make_pair(i, j));
            continue;
          }
          row[i] |= 1 << (mp[i][j] - 1);
          col[j] |= 1 << (mp[i][j] - 1);
          sq[cq(i)][cq(j)] |= 1 << (mp[i][j] - 1);
        }
      }
      dfs(0);
      return 0;
    }
    ```
    

### 例题：小木棍

需要考虑非常多剪枝的一道练习题，有排除等效冗余剪枝

> [落谷 - P1120 小木棍](https://www.luogu.com.cn/problem/P1120)  
> 本题不保证存在可以通过满足本题数据范围的任意数据做法。可以通过此题的程序不一定完全正确（算法时间复杂度错误、或不保证正确性） 本题为搜索题，本题不接受 hack 数据。关于此类题目的详细内容  

- AC 代码
    
    这个代码主函数支持多组数据输入是为了同时可以通过下面这道题，这两道题是完全一样的
    
    > [落谷 - UVA307 小木棍 Sticks](https://www.luogu.com.cn/problem/UVA307)  
    > PDF  
    
    ```C++
    \#include <bits/stdc++.h>
    using namespace std;
    const int N = 100;
    int n, a[N], len, cnt;
    bool used[N];
    // 当前在拼st号大木棍且长度为cur
    // 上一次使用的小木棍是last-1，这次要从last开始用
    bool dfs(int st, int cur, int last) {
      if (st > cnt)
        return true;
      if (cur == len) //拼了len,从1号小木棍开始拼下一根大木棍
        return dfs(st + 1, 0, 1);
      int fail = 0;
      for (int i = last; i <= n; ++i) { // 剪枝，从last开始拼
        // 木棍用过、加上超过len、上次失败的木棍长度和现在的相同，就剪枝
        if (used[i] || cur + a[i] > len || fail == a[i]) continue;
        used[i] = true;
        if (dfs(st, cur + a[i], i + 1)) return true;
        used[i] = false;
        fail = a[i]; // 能到这里说明已经失败了
        // 从1开始一根大木棍都拼不出来、当前小木棍是大木棍的最后一根且仍无解，剪枝
        if (cur == 0 || cur + a[i] == len) return false;
        // 跳过长度相同的小木棍，无需重复搜索
        while (i + 1 <= n && a[i] == a[i + 1]) ++i;
      }
      return false;
    }
    int main() {
      while (cin >> n) {
        if (n == 0) break;
        int sum = 0, maxa = 0;
        for (int i = 1; i <= n; ++i) {
          cin >> a[i];
          maxa = max(maxa, a[i]);
          sum += a[i];
        }
        sort(a + 1, a + n + 1, greater<int>());
        for (len = maxa; len <= sum; ++len) {
          if (sum % len != 0) continue;
          cnt = sum / len;
          memset(used, 0, sizeof(used));
          if (dfs(1, 0, 1)) break;
        }
        cout << len << endl;
      }
      return 0;
    }
    ```
    

### 例题：生日蛋糕

> [落谷 - P1731 [NOI1999] 生日蛋糕](https://www.luogu.com.cn/problem/P1731)  
> 数据加强版 link  

[洛谷 P1731 生日蛋糕](https://www.notion.so/P1731-15283793b8f68028bc1fcee51449a192?pvs=21)

# 迭代加深 IDS

一种结合 BFS 的逐层探索和 DFS 的深度优先的策略，本质是多次 DFS，但是每次搜索的深度不能超过 d，然后逐步增大 d

这样可以防止答案在渐层节点时在非答案的深层分支树上浪费太多时间，在搜索规模随着层数增长速度太快且能够确定在浅层就能找到答案时适用

- 虽然前面的层数会被重复搜索，但相对于一层层指数增加的节点数量其实可以忽略不计，比如说满 $a$ 叉树，第 $n$ 层节点前面所有层的节点数量加起来都没第 $n$ 层节点多，IDS 少搜一层就会快很多

### 例题：Addition Chains 加成序列

> [落谷 - UVA529 Addition Chains](https://www.luogu.com.cn/problem/UVA529)  
> 一个与 n 有关的整数加成序列 &lt;a_0,a_1,a_2,.  

[UVA529 Addition Chains](https://www.notion.so/UVA529-Addition-Chains-1cc83793b8f680de9ddfc4be60ffd5c1?pvs=21)

# 折半搜索

Meet in the middle，俗称折半搜索，将搜索内容分为两半，然后将结果合并，大致可以将时间复杂度从 $O(a^n)$ 降低至 $O(a^{n/2})$。实际应用中一般会对两半进行 DFS，所以也称双向 DFS

### 例题：送礼物

> [落谷 - P10484 送礼物](https://www.luogu.com.cn/problem/P10484)  
> 作为惩罚，GY 被遣送去帮助某神牛给女生送礼物 (GY：貌似是个好差事）但是在 GY 看到礼物之后，他就不这么认为了。某神牛有 N 个礼物，且异常沉重，但是 GY 的力气也异常的大 (-_-b)，他一次可以搬动重量和在 w 以下的任意多个物品。GY…  

[洛谷 P10484 送礼物](https://www.notion.so/P10484-1cd83793b8f68035a9b8eeba8f9e751a?pvs=21)

# IDA*

IDA* = IDS + A*，也就是启发式迭代加深搜索，在迭代加深的基础上加入了估价函数辅助搜索

- 下面两题都没写

### 例题：排书

> [落谷 - P10488 Booksort](https://www.luogu.com.cn/problem/P10488)  
> 给定 n 本书，编号为 1 \sim n。 在初始状态下，书是任意排列的。 在每一次操作中，可以抽取其中连续的一段，再把这段插入到其他某个位置。 我们的目标状态是把书按照 1 \sim n 的顺序依次排列。 求最少需要多少次操作。  

题解：[https://www.acwing.com/solution/content/4050/](https://www.acwing.com/solution/content/4050/)

- AC 代码
    
    ```C++
    \#include <bits/stdc++.h>
    using namespace std;
    const int N = 15;
    int n, q[N], w[5][N];
    // 估价函数，通过逆序对计算最少需要多少次交换
    int f() {
      int res = 0;
      for (int i = 0; i + 1 < n; i++)
        if (q[i + 1] != q[i] + 1)
          res++;
      return (res + 2) / 3;
    }
    bool dfs(int depth, int max_depth) {
      // 如果当前深度加上估价函数的值大于最大深度，剪枝
      if (depth + f() > max_depth)
        return false;
      // 有序，直接返回
      if (f() == 0)
        return true;
      // 枚举所有可能的交换
      // k > r 可以保证不重复交换
      for (int l = 0; l < n; l++) {
        for (int r = l; r < n; r++) {
          for (int k = r + 1; k < n; k++) {
            memcpy(w[depth], q, sizeof q);
            int x, y;
            for (x = r + 1, y = l; x <= k; x++, y++)
              q[y] = w[depth][x];
            for (x = l; x <= r; x++, y++)
              q[y] = w[depth][x];
            if (dfs(depth + 1, max_depth))
              return true;
            memcpy(q, w[depth], sizeof q);
          }
        }
      }
      return false;
    }
    
    int main() {
      int T;
      scanf("%d", &T);
      while (T--) {
        scanf("%d", &n);
        for (int i = 0; i < n; i++)
          scanf("%d", &q[i]);
        int depth = 0;
        while (depth < 5 && !dfs(0, depth))
          depth++;
        if (depth >= 5)
          puts("5 or more");
        else
          printf("%d\n", depth);
      }
      return 0;
    }
    ```
    

### 例题：旋转游戏

> [落谷 - UVA1343 旋转游戏 The Rotation Game](https://www.luogu.com.cn/problem/UVA1343)  
> 如图 1 所示，有一个 “\#” 形的棋盘，上面有 1,2,3 三种数字各 8 个。给定 8 种操作，分别为图中的 \text{A}\sim \text{H}。这些操作会按照图中字母与箭头所指明的方向，把一条长度为 8 的序列循环移动 1…  

题解：[https://www.acwing.com/solution/content/4056/](https://www.acwing.com/solution/content/4056/)