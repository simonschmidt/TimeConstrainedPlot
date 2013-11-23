(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* :Title: TimeConstrainedPlot *) 
(* :Author: Simon Schmidt *)
(* :Summary: Time constrained plot generation *)
(* :Context: TimeConstrainedPlot` *)
(* :Package version: 1.0 *)
(* :Mathematica version: 8.0 for Linux x86 (64-bit) (October 10, 2011) *)


BeginPackage["TimeConstrainedPlot`"];


Unprotect[TimeConstrainedPlot];
ClearAll[TimeConstrainedPlot];


(* :Usage Messages: *)


TimeConstrainedPlot::usage="TimeConstrainedPlot[plot, t] Creates plot and stops calculating new points after t seconds";



(* :Error Messages: *)


Begin["`Private`"];


(* Get corresponding list version of plot function *)
listPlot[DiscretePlot|ParametricPlot]=ListPlot;
listPlot[plotfun_]:=ToExpression["List"<>SymbolName[plotfun]];

(* Extra opts to emulate original plot functions *)
extraPlotOpts[Plot|PolarPlot|LogPlot|LogLogPlot|LogLinearPlot]={Joined->True};
extraPlotOpts[ParametricPlot]={Joined->True,AspectRatio->Automatic};
extraPlotOpts[DiscretePlot]={Filling->Axis};
extraPlotOpts[_]={};

(* Usable plot functions *)
validPlotFunctions={(*ContourPlot,*)
DiscretePlot,DensityPlot,
ParametricPlot,PolarPlot,Plot,Plot3D,
(*StreamDensityPlot,StreamPlot,*)
LogPlot,LogLinearPlot,LogLogPlot};



$debug=False;
Attributes[TimeConstrainedPlot]={HoldFirst};

TimeConstrainedPlot[_]:=(Message[General::argr,TimeConstrainedPlot,2];False/;False)
TimeConstrainedPlot[_,t_,___]/;NonPositive[t]=!=False:=(
Message[General::timc,t];False/;False)


TimeConstrainedPlot[
plotfun_[expr_,varlist:({_,_,_}..),Shortest[opts___]],
 t_?Positive,useropts___
]/;MemberQ[validPlotFunctions,plotfun]:=
Module[{
samples,
vars={varlist}[[All,1]],
listplotfun=listPlot[plotfun],
extraopts=extraPlotOpts[plotfun],
tcret,sowtag,sowexpr,nexpr=0,
sowing
},

Scan[(
nexpr++;
With[{i=nexpr},
sowexpr[i,{vars__?NumericQ}]:=Last[Sow[{vars,#},sowtag[i]]];
];)&,
(* Possible to avoid evaluation here? *)
If[ListQ[expr],expr,{expr}]];
sowing=sowexpr[#,vars]&/@Range[nexpr];

samples=Last@Reap[
tcret=TimeConstrained[
plotfun[
sowing,varlist,
opts]
,t,$Failed];
,sowtag/@Range[nexpr]];

If[Head[tcret]==plotfun,Return[$Failed]];
samples=samples[[All,1]];

If[Length[vars]==1,samples=Sort/@samples];

If[$debug,
samp=samples;
If[tcret===$Failed,Print["Timed out"]]
];

(* Convert {var, f} to appropritate List*Plot form *)
samples=Which[
plotfun===ParametricPlot,
If[Depth[samples]==5,
samples[[All,All,2]],
PadLeft[samples,Automatic,None][[All,All,2]]\[Transpose]
],

True,samples
];

listplotfun[
samples,
FilterRules[Join[{useropts},{opts},extraopts],Options[listplotfun]]
]
]


End[];


Protect[TimeConstrainedPlot];


EndPackage[];
