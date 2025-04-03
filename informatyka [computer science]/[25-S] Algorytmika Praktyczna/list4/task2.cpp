#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>
using namespace std;

int log2(int a) {
    int res = 0;
    int tmp = 1;
    while (tmp < a) {
        tmp *= 2;
        res++;
    }
    return res;
}

void prepare(vector<int>& segtree, const vector<int>& arr, int node, int start, int end) {
    if (start == end) {
        segtree[node] = arr[start];
        return;
    }
    int mid = (start + end) / 2;
    prepare(segtree, arr, 2 * node + 1, start, mid);
    prepare(segtree, arr, 2 * node + 2, mid + 1, end);
    segtree[node] = min(segtree[2 * node + 1], segtree[2*node + 2]);
}

int query(const vector<int>& segtree, int node, int start, int end, int l, int r) {
    if (start > r || end < l) {
        return 2147483647;
    }
    if (l <= start && end <= r) {
        return segtree[node];
    }
    int mid = (start + end) / 2;
    int left = query(segtree, 2 * node + 1, start, mid, l, r);
    int right = query(segtree, 2 * node + 2, mid + 1, end, l, r);
    return min(left, right);
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q;
    cin >> N >> Q;
    vector<int> arr(N);
    for (int i = 0; i < N; i++) {
        cin >> arr[i];
    }

    int treeSize = 2 * pow(2, log2(N));
    vector<int> segtree(treeSize, 2147483647);
    prepare(segtree, arr, 0, 0, N - 1);

    while (Q--) {
        int a, b;
        cin >> a >> b;
        a--; b--;
        cout << query(segtree, 0, 0, N - 1, a, b) << "\n";
    }

    return 0;
}