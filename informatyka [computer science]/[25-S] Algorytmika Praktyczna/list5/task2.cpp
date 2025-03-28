#include <iostream>
#include <vector>
using namespace std;

struct trio{
    vector<int> v1;
    int SK = 0; // max skojarzenie z korzeniem
    int SKprim = 0; // bez korzenia
};

int N;
vector<trio> v;


void dfs(int a, int b){

      for(int child : v[a].v1){
        if(child == b)          continue;
        dfs(child, a);
        v[a].SKprim += max(v[child].SK, v[child].SKprim);
      }

    for(int child : v[a].v1)
    {
        if(child == b)  continue;
        int tmp = 1 + v[a].SKprim - max(v[child].SK, v[child].SKprim) + v[child].SKprim;
        v[a].SK = max(v[a].SK, tmp);
    }


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

    dfs(0, -11322);
    cout << max(v[0].SK, v[0].SKprim) << "\n";



    return 0;
}
