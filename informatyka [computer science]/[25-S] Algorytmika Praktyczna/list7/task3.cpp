#include <iostream>
#include <algorithm>
using namespace std;

//probably i should do this through lazy propagation

bool query(int ST[], int start, int end, int x, int y, int v, int node = 0) {
    if (start > end || start > y || end < x) return true;
    if (x <= start && end <= y) return ST[node] >= v;
    int mid = (start + end) / 2;
    return query(ST, start, mid, x, y, v, 2*node+1) && query(ST, mid+1, end, x, y, v, 2*node+2);
}


void update(int ST[], int start, int end, int x, int y, int v, int node = 0) {
    if (start > end || start > y || end < x) return;
    if (start == end) {
        ST[node] -= v;
        return;
    }
    int mid = (start + end) / 2;
    update(ST, start, mid, x, y, v, 2*node+1);
    update(ST, mid+1, end, x, y, v, 2*node+2);
    ST[node] = min(ST[2*node+1], ST[2*node+2]);
}


int main() {
    ios_base::sync_with_stdio(false);   cin.tie(nullptr);   cout.tie(nullptr);
    int N, M, Q;
    cin >> N >> M >> Q;
    int S = 1;
    while (S <= N) S *= 2; S--;
    int ST[4*S + 4];
    for (int i = 0; i < S + N + 1; i++) {ST[i] = M;}
     while (Q--) {
        int x, y, v;
        cin >> x >> y >> v; x--; y--;
        if (query(ST, 0, N-1, x, y, v)) {
            cout << "T\n";
            update(ST, 0, N-1, x, y, v);
        } else {
            cout << "N\n";
        }
    }
    return 0;
}
