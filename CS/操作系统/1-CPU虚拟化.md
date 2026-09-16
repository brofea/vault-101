# 进程——CPU 虚拟化

## 一个进程的内容

- 程序代码（text segment / code）
- 数据区（data segment）
- 堆（heap）
- 栈（stack）
- PCB（管理信息）
- 地址空间（virtual memory）
- 打开的文件
- 信号处理状态
- 其他内核资源

其中前四项是用户空间的内容，后四项是内核空间的内容

PCB（Process Control Block）是操作系统用来管理进程的核心数据结构，大概就长这样

```c
struct PCB {
    int pid;                 // 进程 ID
    int state;               // 进程状态 running / ready / blocked
    struct CPUContext regs;  // CPU 寄存器现场
    void *page_table;        // 页表地址
    int priority;            // 调度优先级
    struct PCB *next;        // 链表指针
    struct File *files[10];  // 打开的文件
    int exit_code;           // 退出状态
};
```

## 进程 API

以 Linux 为例，进程 API 主要有三个，此外还有 `kill`、`signal`、`getpid` 等

### fork

克隆当前进程，父进程返回子进程的 PID，子进程返回 0，子进程直接从 fork 之后的指令开始执行，父子进程的 PCB、地址空间、打开的文件等都是独立的

懒复制机制：fork 之后父子进程的代码和数据区会暂时共享，直到其中一个进程修改了代码或数据区，才会触发写时复制（copy on write），为该进程分配新的代码或数据

### exec

替换当前进程的代码和数据区，执行新的程序，原来的代码在会直接被覆盖无法往后执行

### wait

父进程等待子进程结束，子进程结束后会向父进程发送 SIGCHLD 信号，父进程可以通过 wait 获取子进程的退出状态码