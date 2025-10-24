(* ::Package:: *)

BeginPackage["BinaryTreeUtils`"];

BTLeaf::usage = "BTLeaf represents a leaf in a binary tree.";
BTNode::usage = "BTNode[left, right] represents a binary tree node with two subtrees.";
BinaryTreeQ::usage = "BinaryTreeQ[expr] returns True when expr is a binary tree built from BTLeaf and BTNode.";
BinaryTreeRegister::usage = "BinaryTreeRegister[tree] gives the Horton-Strahler (register) number of tree.";
BinaryTreeInternalNodes::usage = "BinaryTreeInternalNodes[tree] counts internal nodes (BTNode occurrences) in tree.";
BinaryTreesByInternalNodes::usage = "BinaryTreesByInternalNodes[n] enumerates all binary trees with n internal nodes.";
GlueBinaryTrees::usage = "GlueBinaryTrees[t1, t2] replaces the rightmost leaf of t1 with t2 and returns the glued tree.";

Begin["`Private`"];

ClearAll[BTLeaf, BTNode];

BinaryTreeQ[BTLeaf] := True;
BinaryTreeQ[BTNode[left_, right_]] := BinaryTreeQ[left] && BinaryTreeQ[right];
BinaryTreeQ[_] := False;

BinaryTreeRegister[BTLeaf] := 0;
BinaryTreeRegister[BTNode[left_, right_]] /; BinaryTreeQ[BTNode[left, right]] := Module[
    {l = BinaryTreeRegister[left], r = BinaryTreeRegister[right]},
    If[l == r, l + 1, Max[l, r]]
];

BinaryTreeInternalNodes[BTLeaf] := 0;
BinaryTreeInternalNodes[BTNode[left_, right_]] /; BinaryTreeQ[BTNode[left, right]] := 1 + BinaryTreeInternalNodes[left] + BinaryTreeInternalNodes[right];

(* memoized enumeration of binary trees by internal node count *)
ClearAll[BinaryTreesByInternalNodes];
BinaryTreesByInternalNodes[0] = {BTLeaf};
BinaryTreesByInternalNodes[n_Integer?Positive] := BinaryTreesByInternalNodes[n] = Flatten[
    Table[
        BTNode[left, right],
        {k, 0, n - 1},
        {left, BinaryTreesByInternalNodes[k]},
        {right, BinaryTreesByInternalNodes[n - 1 - k]}
    ],
    2
];
BinaryTreesByInternalNodes[_] := {};

(* glue operation: replace the rightmost leaf of t1 with t2 *)
GlueBinaryTrees[BTLeaf, t2_?BinaryTreeQ] := t2;
GlueBinaryTrees[BTNode[left_, BTLeaf], t2_?BinaryTreeQ] /; BinaryTreeQ[left] := BTNode[left, t2];
GlueBinaryTrees[BTNode[left_, right_], t2_?BinaryTreeQ] /; BinaryTreeQ[BTNode[left, right]] := BTNode[left, GlueBinaryTrees[right, t2]];

End[];
EndPackage[];
