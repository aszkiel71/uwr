#include <bits/stdc++.h>
using namespace std;

const int MAXN = 200000;
int parentArr[MAXN + 1];
int sizeArr[MAXN + 1];
int result;
int maxSize;


void DSU(int n) {
    for (int i = 1; i <= n; i++) {
        parentArr[i] = i;
        sizeArr[i] = 1;
    }
    result = n;
    maxSize = 1;
}


int findSet(int v) {
    if (parentArr[v] == v) return v;
    return parentArr[v] = findSet(parentArr[v]);
}


void unionSet(int a, int b) {
    a = findSet(a);
    b = findSet(b);
    if (a != b) {
        if (sizeArr[a] < sizeArr[b]) swap(a, b);
        parentArr[b] = a;
        sizeArr[a] += sizeArr[b];
        maxSize = max(maxSize, sizeArr[a]);
        result--;
    }
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);

    int N, M;
    cin >> N >> M;

    DSU(N);

    for (int i = 0; i < M; i++) {
        int u, v;
        cin >> u >> v;
        unionSet(u, v);
        cout << result << " " << maxSize << "\n";
    }

    return 0;
}
