#include <iostream>
#include <vector>
using namespace std;
#pragma GCC optimize("Ofast")
#pragma GCC target("avx,bmi,bmi2,lzcnt,popcnt")
void propagate(int ST[], int lazy[], int start, int end, int node) {
    if (lazy[node] != 0) {
        ST[node] -= lazy[node];
        if (start != end) {
            lazy[2*node + 1] += lazy[node];
            lazy[2*node + 2] += lazy[node];
        }
        lazy[node] = 0;
    }
}

bool query(int ST[], int lazy[], int start, int end, int x, int y, int v, int node = 0) {
    propagate(ST, lazy, start, end, node);
    if (start > y || end < x) return true;
    if (x <= start && end <= y) return (ST[node] >= v);
    int mid = (start + end) / 2;
    return query(ST, lazy, start, mid, x, y, v, 2*node + 1) && query(ST, lazy, mid+1, end, x, y, v, 2*node + 2);
}

void update(int ST[], int lazy[], int start, int end, int x, int y, int v, int node = 0) {
    propagate(ST, lazy, start, end, node);
    if (start > y || end < x) return;
    if (x <= start && end <= y) {
        lazy[node] += v;
        propagate(ST, lazy, start, end, node);
        return;
    }
    int mid = (start + end) / 2;
    update(ST, lazy, start, mid, x, y, v, 2*node + 1);
    update(ST, lazy, mid+1, end, x, y, v, 2*node + 2);
    ST[node] = min(ST[2*node + 1], ST[2*node + 2]);
}

int main() {
    int N,M,Q; cin >> N >> M >> Q;
    int S = 1; while(S <= N) S*=2; S--;
    int ST[4*N + 4];
    int lazy[4*N + 4]; for (int i = 0; i < 4*N; i++) lazy[i] = 0;
    for (int i = 0; i <= 4*N + 3; i++) {ST[i] = M;}

    while (Q--) {
        int x, y, v; cin >> x >> y >> v; x--; y--; y--;
        if (query(ST, lazy, 0, N, x, y, v)) {
            cout << "T\n";
            update(ST, lazy, 0, N, x, y, v, 0);
        } else {
            cout << "N\n";
        }
    }

    return 0;
}
