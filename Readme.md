## Description 
Packs 2 arrays interchangeably in bytes32 storage variables.

## Benchmark
2 arrays of 10 elements, `uint16 intervals_` and `uint8 rewards_`.
This repo solution vs regular array `uint16` with intervals and rewards interchangeably set.

|         | Packed [gas] | Regular [gas] |
|---------|--------------|---------------|
| Set     | 46644        | 86276         |
| Iterate | 47699        | 63772         |

## Results

In some use cases, this repo solution might save gas costs by **46%** (difference of **40k** gas) when setting and **25%** (difference of **16k** gas) when iterating.