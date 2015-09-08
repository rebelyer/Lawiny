#include <cstdlib>      // random()
#include <iostream>

#include "automata.hpp"

Automata::Automata(int av_size, int av_threshold, bool av_open, bool av_conservative):
    size{av_size}, threshold{av_threshold}, open{av_open}, conservative{av_conservative} {

        height.resize(size);
        slope.resize(size);

        for(auto& v: height)
            v.resize(size);
        for(auto& v: slope)
            v.resize(size);
    }

Automata::~Automata(){}

float* Automata::get_height() {

}

void Automata::snowing() {
    std::cout<< '\n' << '\n';
    int x = random()%size;
    int y = random()%size;

    if (conservative)
        height[x][y]++;
    else
        for(int i = 0; i < x; ++i) {
            if(random() % 2)
                height[i][y] ++;
            else
                height[y][i] ++;
        }
}

void Automata::set_slope() {

    for(int i = 0; i < size; ++i)
        for(int j = 0; j < size; ++j) {
            bool bottom = j == size-2 || j == size-3;

            if(! j%2) {
                if (i > 0) {
                    if(! bottom) slope[i][j] = height[i][j] + height[i-1][j+1] - height[i][j+1] - height[i][j+2];
                    else slope[i][j] = height[i][j] + height[i-1][j+1] - height[i][j+1];
                }
                else {
                    if(! bottom) slope[0][j] = 2*height[0][j] - height[0][j+1] - height[0][j+2];
                    else slope[0][j] = 2*height[0][j] - height[i][j+1];
                }
            }

            else {
                if (i < size - 1) {
                    if (! bottom) slope[i][j] = height[i][j]+ height[i][j+1]- height[i+1][j+1]- height[i][j+2];
                    else slope[i][j] = height[i][j];
                }
                else {
                    if (! bottom) slope[i][j] = height[i][j] + height[i][j+1] - height[i][j+2];
                    else slope[i][j] = height[i][j];
                }
            }
        }
}

void Automata::fall() {
    int i, j;   // slope indexes
    for(auto vec : slope) {
        j = 0;
        for(auto sl : vec) {
            if(sl > threshold) {
                if(j%2) {
                    height[i][j]--;
                    height[i][j+1]--;
                    height[i+1][j+1]++;
                    height[i][j+2]++;
                }
                else {
                    height[i][j]--;
                    height[i-1][j+1]--;
                    height[i][j+1]++;
                    height[i][j+2]++;
                }
            }
            j++;
        }
        i++;
    }
}
void Automata::test() {
    for(auto v: height){
        for(auto h: v) std::cout << h << '\t';
        std::cout << '\n';
    }
}
