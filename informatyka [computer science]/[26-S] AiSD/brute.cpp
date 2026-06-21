#include <iostream>
#include <queue>
#include <vector>

using namespace std;

// Używamy dużej wartości nieskończoności dla typu long long
const long long INF = 1e18;

int main() {
  // Optymalizacja wejścia/wyjścia (przydatna przy stress testach z dużą ilością
  // danych)
  ios_base::sync_with_stdio(false);
  cin.tie(NULL);

  int n, m, k;
  if (!(cin >> n >> m >> k)) return 0;

  // Graf reprezentowany jako lista sąsiedztwa
  // pair<cel, waga_krawędzi>
  vector<vector<pair<int, long long>>> adj(n + 1);

  for (int i = 0; i < m; ++i) {
    int u, v;
    long long w;
    cin >> u >> v >> w;
    adj[u].push_back({v, w});
    adj[v].push_back({u, w});
  }

  // Wczytanie miast docelowych
  vector<int> targets(k);
  for (int i = 0; i < k; ++i) {
    cin >> targets[i];
  }

  // Tablica odległości od stolicy (wierzchołek 1)
  vector<long long> dist(n + 1, INF);

  // Kolejka priorytetowa: pair<odległość, wierzchołek>
  // greater<> zapewnia, że najmniejszy element jest na górze (Min-Heap)
  priority_queue<pair<long long, int>, vector<pair<long long, int>>,
                 greater<pair<long long, int>>>
      pq;

  dist[1] = 0;
  pq.push({0, 1});

  // Standardowy algorytm Dijkstry
  while (!pq.empty()) {
    long long d = pq.top().first;
    int u = pq.top().second;
    pq.pop();

    // Jeśli zdejmiemy nieaktualny (dłuższy) dystans z kolejki, ignorujemy go
    if (d > dist[u]) continue;

    // Relaksacja krawędzi
    for (const auto& edge : adj[u]) {
      int v = edge.first;
      long long w = edge.second;

      if (dist[u] + w < dist[v]) {
        dist[v] = dist[u] + w;
        pq.push({dist[v], v});
      }
    }
  }

  long long total_distance = 0;

  // Obliczanie całkowitego dystansu (tam i z powrotem)
  for (int target : targets) {
    // Jeśli do jakiegoś celu nie da się dotrzeć
    if (dist[target] == INF) {
      cout << "NIE\n";
      return 0;
    }
    total_distance += 2LL * dist[target];
  }

  // Wypisanie wyniku
  cout << total_distance << "\n";

  return 0;
}
