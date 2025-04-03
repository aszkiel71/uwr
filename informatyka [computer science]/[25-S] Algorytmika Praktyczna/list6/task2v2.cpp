#include <iostream>
#include <vector>
using namespace std;


//tc O(n^2) (could be better with Segment Tree -> watch out task2.cpp)

struct przedzial{int s, e, o;};

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N; cin >> N;    int Q; cin >> Q;        int Arr[N];    for(int i=0;i<N;i++) cin>>Arr[i];
    vector<przedzial> queries; int counter = 0;
    while(Q--) {
        int tmp; cin >> tmp;
        if(tmp == 1){
          int x, y, v; cin>>x>>y>>v;    x--; y--;
          queries.push_back(przedzial{x,y,v});
            counter++;
        }
        else{
            int k; cin >> k; k--;   int res = Arr[k];
            for (int i = 0; i < counter; i++){
                if (queries[i].s <= k && queries[i].e >= k) res += queries[i].o;
            }
            cout << res << "\n";
        }
    }

    return 0;
}
