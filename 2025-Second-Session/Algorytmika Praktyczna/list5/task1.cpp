#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;

struct trio{
    vector<int> v1;
    int max_sr = 0;
    int w = 0;
};

vector<trio> v;
int N;

void dfs(int a, int b)
{
    int max1 = 0, max2 = 0;
    int max_diam = 0;
    for (int child : v[a].v1)
    {
        if (child == b) continue;

        dfs(child, a);

        int h = v[child].w;
        if (h > max1)
        {
            max2 = max1;
            max1 = h;
        }
        else if (h > max2)
        {
            max2 = h;
        }


        max_diam = max(max_diam, v[child].max_sr);
    }

    v[a].w = max1 + 1;
    v[a].max_sr = max(max_diam, max1 + max2 + 1);
}


int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    cin >> N;
    v.resize(N);

    for (int i = 0; i < N - 1; i++) {
        int a; cin >> a; a--;
        int b; cin >> b; b--;
        (v[a].v1).push_back(b);
        (v[b].v1).push_back(a);
    }

    dfs(0, -32113);

    cout << v[0].max_sr-1 << "\n";

    return 0;
}
