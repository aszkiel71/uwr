#include <iostream>
#include <vector>
#include <climits>
#include <cmath>
#include <algorithm>
#pragma GCC optimize("Ofast")
using namespace std;

// -------------------
struct our_pair {
    int id;
    int h;
};

int logus(int a, int b = 2){
    int res = 0; int tmp = 1;
    while (tmp < a) {tmp *= b; res++;}
    return res;
}

void dfs(int u, int v, vector<our_pair> &euler_tour, vector<vector<int>> &tree, int height, vector<int> &parent) {
    parent[u] = v;
    euler_tour.push_back({u, height});
    for (int child : tree[u]) {
        if (child == v) {
            continue;
        }
        dfs(child, u, euler_tour, tree, height + 1, parent);
        euler_tour.push_back({u, height});
    }
}

int queryRMQ(const vector<our_pair>& euler_tour, const vector<vector<int>>& rmq_table, int l, int r) {
    if (l > r) swap(l, r);
    int j = floor(log2(r - l + 1));
    int left_index = rmq_table[l][j];
    int right_index = rmq_table[r - (1 << j) + 1][j];
    if (euler_tour[left_index].h <= euler_tour[right_index].h) {
        return euler_tour[left_index].id;
    } else {
        return euler_tour[right_index].id;
    }
}

// ---------------------

void dfs2(int u, int parent, vector<vector<int>> &tree, vector<int> &sciezki){
    for(int child : tree[u]){
        if(child == parent) continue;
        dfs2(child, u, tree, sciezki);
        sciezki[u] += sciezki[child];
    }
}

int main() {
    ios_base::sync_with_stdio(false);cin.tie(nullptr);cout.tie(nullptr);
    int N, M; cin >> N >> M;
    vector <vector <int>> tree(N+1); for (int i = 0; i < N - 1; ++i) {int k, v; cin >> k >> v; tree[k].push_back(v); tree[v].push_back(k);}
    vector<int> parent(N+1, -1);

    // --------------------------

    vector<our_pair> euler_tour;
    dfs(1, -1337, euler_tour, tree, 0, parent);
    vector<int> occurence(N+1, -1337); int idx = 0;
    for (const auto &pair : euler_tour){
        if (occurence[pair.id] == -1337){
            occurence[pair.id] = idx;
        }
        idx++;
    }

    vector<vector<int>> rmq_table(euler_tour.size(), vector<int>(logus(euler_tour.size())+1));

    for (int i = 0; i < euler_tour.size(); ++i) {
        rmq_table[i][0] = i;
    }

    for (int j = 1; j <= logus(euler_tour.size()); ++j) {
        int power_of_2 = 1 << (j - 1);
        for (int i = 0; i + (1 << j) <= euler_tour.size(); ++i) {
            int left = rmq_table[i][j - 1];
            int right = rmq_table[i + power_of_2][j - 1];
            if (euler_tour[left].h <= euler_tour[right].h) {
                rmq_table[i][j] = left;
            } else {
                rmq_table[i][j] = right;
            }
        }
    }
    // ----------------------------

    vector<int> sciezki(N+1, 0);

    while(M--){
      int u, v; cin >> u >> v;    int anc = u;
      if (u != v) anc = queryRMQ(euler_tour, rmq_table, occurence[u], occurence[v]);
      sciezki[u]++; sciezki[v]++; sciezki[anc]--; if (anc != 1) sciezki[parent[anc]]--;
    }
    dfs2(1, -1338, tree, sciezki);
    for(int i = 1; i <= N; i++)    cout << sciezki[i] << " ";


    return 0;
}