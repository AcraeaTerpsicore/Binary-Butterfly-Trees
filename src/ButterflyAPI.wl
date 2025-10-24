(* ::Package:: *)

BeginPackage["ButterflyAPI`", {"BinaryTreeUtils`"}];

ButterflyTreePairs::usage = "ButterflyTreePairs[n] enumerates ordered pairs of binary trees whose glued result has n internal nodes.";
ButterflyGluedTrees::usage = "ButterflyGluedTrees[n] returns the multiset of glued butterfly trees of size n.";
ButterflyRegisterDistribution::usage = "ButterflyRegisterDistribution[n] returns an association of register numbers to counts for glued trees of size n.";
ButterflyAverageRegister::usage = "ButterflyAverageRegister[n] gives the average register value across all glued trees of size n.";

Begin["`Private`"];

ButterflyTreePairs[0] = {};
ButterflyTreePairs[n_Integer?Positive] := ButterflyTreePairs[n] = Module[{pairs = {}},
    Do[
        With[{leftTrees = BinaryTreesByInternalNodes[k], rightTrees = BinaryTreesByInternalNodes[n - k]},
            pairs = Join[pairs, Flatten[Outer[List, leftTrees, rightTrees, 1], 1]]
        ],
        {k, 1, n}
    ];
    pairs
];
ButterflyTreePairs[_] := {};

ButterflyGluedTrees[n_Integer?Positive] := ButterflyGluedTrees[n] = Module[{pairs = ButterflyTreePairs[n]},
    GlueBinaryTrees @@@ pairs
];
ButterflyGluedTrees[_] := {};

ButterflyRegisterDistribution[n_Integer?Positive] := Module[
    {registers, tally},
    registers = BinaryTreeRegister /@ ButterflyGluedTrees[n];
    tally = Tally[registers];
    Association[Rule @@@ SortBy[tally, First]]
];
ButterflyRegisterDistribution[_] := <||>;

ButterflyAverageRegister[n_Integer?Positive] := Module[
    {dist = ButterflyRegisterDistribution[n], total, weighted},
    If[dist === <||>, Return[Indeterminate]];
    total = Total[Values[dist]];
    weighted = Total[Normal[dist] /. Rule[k_, v_] :> k v];
    N[weighted/total]
];
ButterflyAverageRegister[_] := Indeterminate;

End[];
EndPackage[];
