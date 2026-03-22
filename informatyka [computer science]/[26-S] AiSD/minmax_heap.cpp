#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

using namespace std;


struct MinMaxHeap{
    int n;
    vector<int> heap;

    int get_lvl(int i) {
        int level = 0;
        int x = i + 1;
        while (x > 1) {
            x >>= 1;
            level++;
        }
        return level;
    }

    int get_min() {
        return heap[0];
    }

    int get_max() {
        if (n == 1) return heap[0];
        if (n == 2) return heap[1];
        return max(heap[1], heap[2]);
    }

    void insert(int x) {
        heap.push_back(x); n++;
        int lvl = get_lvl((n-1) / 2);

    }

    int grandfather(int i) {
        return (((i-1) / 2) - 1) / 2;  // (i - 3) / 4
    }

    void insert(int x) {
        heap.push_back(x); n++;
        move_up(n-1);
    }

    void delete_min() {
        heap[0] = heap[n-1]; n--;
        heap.pop_back();
        if (n > 0) move_down(0);
    }

    void delete_max() {
        if (n <= 1) {
            delete_min(); return;
        }

        int max_idx = 1;
        if (n > 2 && heap[2] > heap[1]) max_idx = 2;

        heap[max_idx] = heap[n-1]; n--;
        heap.pop_back();
        if (n > max_idx) {
            move_down(max_idx);
        }
    }

    void move_down(int i) {
        int lvl = get_lvl(i);
        if (lvl % 2) {
            move_down_max(i);
        }
        else {
            move_down_min(i);
        }
    }

    void move_up(int i) {
        int lvl = get_lvl(i);
        if (lvl % 2) {
            if (heap[(i-1) / 2] > heap[i]) {
                swap(heap[(i-1) / 2], heap[i]);
                move_up_min((i-1) / 2);
            }
            else {
                move_up_max(i);
            }
        }
        else {
            if (heap[(i-1) / 2] < heap[i]) {
                swap(heap[(i-1) / 2], heap[i]);
                move_up_max((i-1) / 2);
            }
            else {
                move_up_min(i);
            }
        }
    }

    void move_up_min(int i) {
        while (i >= 3) {
            if (heap[i] < heap[grandfather(i)]) {
                swap(heap[i], heap[grandfather(i)]);
                i = grandfather(i);
            }
            else break;
        }
    }

    void move_up_max(int i) {
        while (i >= 3) {
            if (heap[i] > heap[grandfather(i)]) {
                swap(heap[i], heap[grandfather(i)]);
                i = grandfather(i);
            }
            else break;
        }
    }

    int get_smallest_dsc(int i) {
        int smallest = -1;
        int dsc[6] = {
            2*i + 1, 2*i + 2,
            4*i + 3, 4*i + 4, 4*i + 5, 4*i + 6
        };

        for (int idx : dsc) {
            if (idx < n) {
                if (smallest == -1 || heap[idx] < heap[smallest]) {
                    smallest = idx;
                }
            }
        }
        return smallest;
    }

    int get_largest_dsc(int i) {
        int largest = -1;
        int dsc[6] = {
            2*i + 1, 2*i + 2,
            4*i + 3, 4*i + 4, 4*i + 5, 4*i + 6
        };

        for (int idx : dsc) {
            if (idx < n) {
                if (largest == -1 || heap[idx] > heap[largest]) {
                    largest = idx;
                }
            }
        }
        return largest;
    }

    void move_down_min(int i) {
        while (2*i + 1 < n) {
            int m = get_smallest_dsc(i);
            bool is_grandchild = (m >= 4*i + 3);
            if (is_grandchild) {
                if (heap[m] < heap[i]) {
                    swap(heap[i], heap[m]);
                    if (heap[m] > heap[(m-1) / 2]) {
                        swap(heap[m], heap[(m-1) / 2]);
                    }
                    i = m;
                }
                else break;
            }
            else {
                if (heap[m] < heap[i]) {
                    swap(heap[i], heap[m]);
                }
                break;
            }
        }
    }

    void move_down_max(int i) {
        while (2*i + 1 < n) {
            int m = get_largest_dsc(i);
            bool is_grandchild = (m >= 4*i + 3);
            if (is_grandchild) {
                if (heap[m] > heap[i]) {
                    swap(heap[i], heap[m]);
                    if (heap[m] < heap[(m-1) / 2]) {
                        swap(heap[m], heap[(m-1) / 2]);
                    }
                    i = m;
                }
                else break;
            }
            else {
                if (heap[m] > heap[i]) {
                    swap(heap[i], heap[m]);
                }
                break;
            }
        }
    }

    void build() {
        for (int i = (n / 2) - 1; i >= 0; i--) {
            move_down(i);
        }
    }



    MinMaxHeap(vector<int> _tab) : heap(_tab) {
        n = (int) heap.size();
        build();
    }

    void print() {
        for (int x : heap) cout << x << " ";
        cout << "\n";
    }
};




int main(){

}

