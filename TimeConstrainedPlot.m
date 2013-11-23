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
extraPlotOpts[Plot|PolarPlot]={Joined->True};
extraPlotOpts[ParametricPlot]={Joined->True,AspectRatio->Automatic};
extraPlotOpts[DiscretePlot]={Filling->Axis};
extraPlotOpts[_]={};

(* Usable plot functions *)
validPlotFunctions={ContourPlot,
DiscretePlot,DensityPlot,
ParametricPlot,PolarPlot,Plot,Plot3D,
StreamDensityPlot,StreamPlot,
LogPlot,LogLinearPlot,LogLogPlot};



$debug=False;
Attributes[TimeConstrainedPlot]={HoldFirst};

TimeConstrainedPlot[_]:=(Message[General::argr,TimeConstrainedPlot,2];False/;False)
TimeConstrainedPlot[_,t_,___]/;NonPositive[t]=!=False:=(
Message[General::timc,t];False/;False)


TimeConstrainedPlot[
plotfun_[f_,varlist:({_,_,_}..),Shortest[opts___]],
 t_?Positive,useropts___
]/;MemberQ[validPlotFunctions,plotfun]:=
Module[{
samples,
vars={varlist}[[All,1]],
listplotfun=listPlot[plotfun],
extraopts=extraPlotOpts[plotfun],
tcret,sowtag
},

samples=Last@Reap[
tcret=TimeConstrained[
plotfun[
f,varlist,
EvaluationMonitor:>Sow[{vars,f}, sowtag],
opts]
,t,$Failed];
,sowtag];

If[Head[tcret]==plotfun,Return[$Failed]];
samples=First@samples;

If[Length[vars]==1,samples=Sort[samples]];

If[$debug,
samp=samples;
If[tcret===$Failed,Print["Timed out"]]
];

(* Convert {var, f} to appropritate List*Plot form *)
samples=Which[
plotfun===ParametricPlot,
If[Depth[samples[[All,2]]]==4,
samples[[All,2]]\[Transpose],
samples[[All,2]]],

MatchQ[plotfun,StreamDensityPlot|StreamPlot],
samples,

(* Multiple functions *)
Depth[samples[[All,2]]]==3,
MapThread[
Append,
{samples[[All,1]],#}
]&/@(samples[[All,2]]\[Transpose]),

(* One function case *)
True,Flatten/@samples
];

listplotfun[
samples,
FilterRules[Join[useropts,{opts},extraopts],Options[listplotfun]]
]
]


End[];


Protect[TimeConstrainedPlot];


EndPackage[];
