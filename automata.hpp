#ifndef AUTOMATA_HPP
#define AUTOMATA_HPP

#include <vector>

class Automata {

    int size;
    int threshold;
    bool open;
    bool conservative;

    std::vector< std::vector< int > > height;
    std::vector< std::vector< int > > slope;


public:
    Automata(int av_size, int av_threshold, bool av_open = true, bool av_conservative = true);
    ~Automata();

    float* get_height();

    void snowing();
    void set_slope();
    void fall();
    void test();
};
#endif
