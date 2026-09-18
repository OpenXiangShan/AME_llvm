// Shared, non-symmetric signed data. The product is an independent golden table.
#ifndef BOSCZTT_TEST_MATRIX_DATA_H
#define BOSCZTT_TEST_MATRIX_DATA_H

enum { TileSide = 8, PaddedColumns = 10 };

#ifdef __cplusplus
#define MATRIX_DATA static constexpr
#else
#define MATRIX_DATA static const
#endif

MATRIX_DATA int Left[TileSide][TileSide] = {
    {1, -2, 3, 0, 5, -1, 2, 4},
    {-3, 4, 1, 2, -2, 0, 6, -1},
    {2, 0, -1, 5, 3, -4, 1, 2},
    {0, 1, 4, -2, 6, 3, -1, 5},
    {5, -3, 2, 1, 0, 4, -2, 6},
    {1, 6, -4, 3, 2, -1, 5, 0},
    {-2, 5, 0, 4, -3, 2, 1, 7},
    {4, 2, 6, -1, 1, 5, -3, 0},
};

MATRIX_DATA int Right[TileSide][TileSide] = {
    {3, 1, -2, 4, 0, 5, -1, 2},
    {0, -3, 4, 1, 2, -1, 5, 6},
    {2, 5, 1, -4, 3, 0, 6, -2},
    {-1, 2, 3, 5, -2, 4, 0, 1},
    {4, -2, 0, 6, 1, 3, 2, -3},
    {5, 0, -1, 2, 4, -3, 1, 7},
    {-2, 4, 6, 0, 5, 1, -4, 3},
    {1, 6, 2, -3, 7, 2, 4, 0},
};

MATRIX_DATA int Product[TileSide][TileSide] = {
    {24, 44, 14, 6, 44, 35, 24, -32},
    {-30, 16, 63, -11, 28, -13, -3, 42},
    {-9, 17, 24, 41, -7, 56, -2, -23},
    {56, 27, 3, 2, 66, 9, 68, -4},
    {48, 54, -21, 4, 46, 30, 28, 11},
    {-15, -15, 58, 51, 17, 25, -12, 51},
    {-7, 43, 54, -18, 61, 1, 47, 56},
    {60, 12, -20, 5, 30, -1, 61, 30},
};

#undef MATRIX_DATA
#endif
