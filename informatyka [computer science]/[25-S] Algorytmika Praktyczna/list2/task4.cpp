#include <iostream>
#define ll long long
using namespace std;

const int MAX_N = 100000;
ll parentArr[MAX_N + 1];
ll sizeArr[MAX_N + 1];
ll minV[MAX_N + 1], maxV[MAX_N + 1], edgeCount[MAX_N + 1];

ll findSet(int v) {
    if (v == parentArr[v])
        return v;
    return (parentArr[v] = findSet(parentArr[v]));
}

void unionSet(ll a, ll b) {
    a = findSet(a);
    b = findSet(b);
    if (a != b) {
        if (sizeArr[a] < sizeArr[b]) swap(a, b);
        parentArr[b] = a;
        sizeArr[a] += sizeArr[b];
        minV[a] = min(minV[a], minV[b]);
        maxV[a] = max(maxV[a], maxV[b]);
        edgeCount[a] += edgeCount[b] + 1;
    } else {
        edgeCount[a]++;
    }
}

int main() {
    ios_base::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);

    int N, M;
    cin >> N >> M;

    for (int i = 1; i <= N; i++) {
        parentArr[i] = i;
        sizeArr[i] = 1;
        minV[i] = i;
        maxV[i] = i;
        edgeCount[i] = 0;
    }

    while (M--) {
        ll a, b;
        cin >> a >> b;
        unionSet(a, b);
        ll r = findSet(a);
        cout << (maxV[r] - minV[r]) * edgeCount[r] << "\n";
    }

    return 0;
}
