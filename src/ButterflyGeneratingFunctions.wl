(* ::Package:: *)

BeginPackage["ButterflyGeneratingFunctions`"];

ZFromU::usage = "ZFromU[u] gives the substitution z = u/(1+u)^2 used for Catalan-style generating functions.";
UFromZ::usage = "UFromZ[z] returns the power-series branch solving z = u/(1+u)^2 with UFromZ[0] = 0.";
BinaryTreeGeneratingFunction::usage = "BinaryTreeGeneratingFunction[z] is the ordinary generating function B(z) = 1 + z B(z)^2.";
MarkedButterflyGeneratingFunction::usage = "MarkedButterflyGeneratingFunction[u] returns A = (B-1)B expressed via the Catalan substitution parameter u.";
RegisterSurvivalFunction::usage = "RegisterSurvivalFunction[p, u] gives S_p(z) for Horton-Strahler numbers >= p expressed in terms of u.";
ButterflyRegisterSurvivalFunction::usage = "ButterflyRegisterSurvivalFunction[p, u] gives T_p(z) for glued trees with register >= p expressed via u.";
RegisterSurvivalSeries::usage = "RegisterSurvivalSeries[p, order] expands S_p(z) as a power series in z up to order.";
ButterflyRegisterSeries::usage = "ButterflyRegisterSeries[p, order] expands T_p(z) as a power series in z up to order.";
VerifyButterflyRecurrence::usage = "VerifyButterflyRecurrence[p, order] returns the residual of the T_p recurrence as a series in z up to order.";
ButterflyRegisterCoefficient::usage = "ButterflyRegisterCoefficient[p, n] gives the exact coefficient [z^n]T_p(z).";
ButterflyRegisterCoefficientTable::usage = "ButterflyRegisterCoefficientTable[p, max] returns the coefficients [z^n]T_p(z) for 0 <= n <= max.";
ButterflyRegisterDerivativeAtOne::usage = "ButterflyRegisterDerivativeAtOne[p] gives d/du T_p(z(u)) evaluated at u=1.";
ButterflyRegisterCoefficientAsymptotic::usage = "ButterflyRegisterCoefficientAsymptotic[p, n] estimates [z^n]T_p(z) using the leading Mellin-derived asymptotic.";

Begin["`Private`"];

ClearAll[z, u];

ZFromU[u_] := u/(1 + u)^2;

UFromZ[0] := 0;
UFromZ[z_] := (1 - 2 z - Sqrt[1 - 4 z])/(2 z);

BinaryTreeGeneratingFunction[z_] := Piecewise[{
    {1, z == 0}
}, (1 - Sqrt[1 - 4 z])/(2 z)];

MarkedButterflyGeneratingFunction[u_] := u (1 + u);

RegisterSurvivalFunction[p_Integer?NonNegative, u_] := (1 - u^2)/u * u^(2^p)/(1 - u^(2^p));
RegisterSurvivalFunction[_, _] := 0;

ButterflyRegisterSurvivalFunction[p_Integer?Positive, u_] := Module[
    {sp = RegisterSurvivalFunction[p, u], sumTerm, productTerm},
    sumTerm = Sum[
        ((1 - u^(2^h))/(1 - u)) * Product[(1 - u^(2^j + 1))/(1 - u), {j, 0, h - 1}],
        {h, 1, p - 1}
    ];
    productTerm = Product[(1 - u)/(1 - u^(2^j + 1)), {j, 0, p - 1}];
    sp*((1 + u)^2 + (1 + u + u^2) sumTerm) * productTerm
];

seriesWithSubstitution[expr_, order_] := Normal@Series[expr /. u -> UFromZ[z], {z, 0, order}];

RegisterSurvivalSeries[p_Integer?NonNegative, order_Integer?Positive] := seriesWithSubstitution[
    RegisterSurvivalFunction[p, u],
    order
];

ButterflyRegisterSeries[p_Integer?Positive, order_Integer?Positive] := seriesWithSubstitution[
    ButterflyRegisterSurvivalFunction[p, u],
    order
];

ButterflyRegisterCoefficient[p_Integer?Positive, n_Integer?NonNegative] := ButterflyRegisterCoefficient[p, n] = SeriesCoefficient[
    ButterflyRegisterSurvivalFunction[p, u] /. u -> UFromZ[z],
    {z, 0, n}
];

ButterflyRegisterCoefficientTable[p_Integer?Positive, max_Integer?NonNegative] := Table[
    ButterflyRegisterCoefficient[p, n],
    {n, 0, max}
];

ButterflyRegisterDerivativeAtOne[p_Integer?Positive] := ButterflyRegisterDerivativeAtOne[p] = Module[
    {expr},
    expr = ButterflyRegisterSurvivalFunction[p, u];
    Limit[D[expr, u], u -> 1, Assumptions -> p > 0]
];

ButterflyRegisterCoefficientAsymptotic[p_Integer?Positive, n_Integer?Positive] := Module[
    {c = ButterflyRegisterDerivativeAtOne[p]},
    c*4^n/(Sqrt[Pi] n^(3/2))
];

VerifyButterflyRecurrence[p_Integer?Positive, order_Integer?Positive] /; p >= 2 := Module[
    {bSeries, aSeries, spSeries, spPrevSeries, tpSeries, tpPrevSeries},
    bSeries = Normal@Series[BinaryTreeGeneratingFunction[z], {z, 0, order}];
    aSeries = seriesWithSubstitution[MarkedButterflyGeneratingFunction[u], order];
    spSeries = RegisterSurvivalSeries[p, order];
    spPrevSeries = RegisterSurvivalSeries[p - 1, order];
    tpSeries = ButterflyRegisterSeries[p, order];
    tpPrevSeries = ButterflyRegisterSeries[p - 1, order];
    Normal@Series[
        tpSeries*(1 - z (bSeries - spPrevSeries)) - (spSeries + z spPrevSeries tpPrevSeries + z spSeries (aSeries - tpPrevSeries)),
        {z, 0, order}
    ]
];

End[];
EndPackage[];
