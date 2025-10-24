root = ExpandFileName@FileNameJoin[{DirectoryName[$InputFileName], ".."}];
AppendTo[$Path, FileNameJoin[{root, "src"}]];

Needs["BinaryTreeUtils`"];
Needs["ButterflyGeneratingFunctions`"];
Needs["ButterflyAPI`"];

enumerateButterflyCounts[maxN_Integer?Positive, p_Integer?Positive] := Module[
    {counts = Table[0, {maxN}], n, k, total},
    Do[
        total = 0;
        Do[
            With[{leftTrees = BinaryTreesByInternalNodes[k], rightTrees = BinaryTreesByInternalNodes[n - k]},
                total += Count[
                    Flatten[
                        Outer[
                            Function[{t1, t2},
                                BinaryTreeRegister[GlueBinaryTrees[t1, t2]]
                            ],
                            leftTrees,
                            rightTrees,
                            1
                        ],
                        1
                    ],
                    _?(# >= p &)
                ]
            ],
            {k, 1, n}
        ];
        counts[[n]] = total,
        {n, 1, maxN}
    ];
    counts
];

tpSeriesCoefficients[p_Integer?Positive, maxN_Integer?Positive] := Module[
    {series = Normal@ButterflyRegisterSeries[p, maxN] /. ButterflyGeneratingFunctions`Private`z -> z},
    Table[Coefficient[series, z^n], {n, 1, maxN}]
];

tests = {
    VerificationTest[
        BinaryTreeRegister[BTNode[BTNode[BTLeaf, BTLeaf], BTLeaf]],
        1,
        TestID -> "register-simple"
    ],
    VerificationTest[
        Length@BinaryTreesByInternalNodes[3],
        CatalanNumber[3],
        TestID -> "count-size-3"
    ],
    VerificationTest[
        BinaryTreeRegister[GlueBinaryTrees[BTNode[BTLeaf, BTLeaf], BTNode[BTLeaf, BTLeaf]]],
        1,
        TestID -> "register-glued"
    ],
    VerificationTest[
        Normal@ButterflyRegisterSeries[1, 6] /. ButterflyGeneratingFunctions`Private`z -> z,
        Normal@Series[MarkedButterflyGeneratingFunction[u] /. u -> UFromZ[z], {z, 0, 6}],
        TestID -> "t1-equals-a"
    ],
    VerificationTest[
        Normal[VerifyButterflyRecurrence[2, 6] /. ButterflyGeneratingFunctions`Private`z -> z],
        0,
        TestID -> "recurrence-p2"
    ],
    VerificationTest[
        Length[ButterflyGluedTrees[4]],
        tpSeriesCoefficients[1, 4][[4]],
        TestID -> "glued-count-size-4"
    ],
    With[{dist = ButterflyRegisterDistribution[3]},
        VerificationTest[
            Total[Values[dist]],
            Length[ButterflyGluedTrees[3]],
            TestID -> "distribution-total"
        ]
    ],
    With[{dist = ButterflyRegisterDistribution[3]},
        VerificationTest[
            Total[Normal[dist] /. Rule[k_, v_] :> If[k >= 2, v, 0]],
            enumerateButterflyCounts[3, 2][[3]],
            TestID -> "distribution-tail"
        ]
    ],
    With[{dist = ButterflyRegisterDistribution[3]},
        VerificationTest[
            ButterflyAverageRegister[3],
            N[Total[Normal[dist] /. Rule[k_, v_] :> k v]/Total[Values[dist]]],
            TestID -> "average-from-distribution"
        ]
    ],
    With[{maxN = 4, p = 1},
        VerificationTest[
            enumerateButterflyCounts[maxN, p],
            tpSeriesCoefficients[p, maxN],
            TestID -> "enumeration-p1"
        ]
    ],
    With[{maxN = 3, p = 2},
        VerificationTest[
            enumerateButterflyCounts[maxN, p],
            tpSeriesCoefficients[p, maxN],
            TestID -> "enumeration-p2"
        ]
    ]
};

report = TestReport[tests];

If[report["TestsFailedCount"] > 0,
    Print["TESTS FAILED"];
    Print[report];
    Exit[1],
    Print["All tests passed."];
    Print["Successes: ", report["TestsSucceededCount"]];
    Exit[0]
];
