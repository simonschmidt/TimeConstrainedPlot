TimeConstrainedPlot
===================

Mathematica package to constrain plot evaluation time.
As this is based on `EvaluationMonitor :> {x, expr}` it is recommended to use a memoized function
to avoid double evaluation.

### Installation
Download [TimeConstrainedPlot.m](https://github.com/simonschmidt/TimeConstrainedPlot/raw/master/TimeConstrainedPlot.m) and put it in the directory given by `FileNameJoin[{$UserBaseDirectory, "Applications"}]`


### Examples

Plot a slow function:

    <<<TimeConstrainedPlot`

    ClearAll[slowSin];
    slowSin[x_]:= slowSin[x] = (Pause[RandomReal[0.1]]; Sin[x])

    TimeConstrainedPlot[
        Plot3D[slowSin[x] Cos[y], {x, 0, 10}, {y, 0, 10}],
        1]

![Plot3D example](http://simonschmidt.github.io/TimeConstrainedPlot/images/plot3d.png)

### Options

All options provided to the original plot function that are valid
for the corresponding `List*Plot` will be kept. To provide more options put them in the third argument

### Scope

Constrainable plot functions:

    {ContourPlot, DensityPlot, DiscretePlot, LogLinearPlot, LogLogPlot,
     LogPlot, ParametricPlot, Plot, Plot3D, PolarPlot, StreamDensityPlot,
     StreamPlot}

### Possible Issues

There might not be enough time to cover the entire plot range:

    TimeConstrainedPlot[Plot[slowSin[x], {x, 0, 10}], 1]

![range issue](http://simonschmidt.github.io/TimeConstrainedPlot/images/range-issue.png)


With lower `PlotPoints` there is enough time to cover the range and the adaptive algorithm can start refining:

    TimeConstrainedPlot[Plot[slowSin[x], {x, 0, 10}, PlotPoints -> 5], 1]

![workaround](http://simonschmidt.github.io/TimeConstrainedPlot/images/range-issue-fix.png)


- - -

Superfluous evaluation of functions, normally each function is refined individually:

    Clear[f, g];
    f[x_?NumericQ] := (Sow[x, f]; Abs[x]);
    g[x_?NumericQ] := (Sow[x, g]; Abs[x - 1/2]);
    gp = Reap[
        fp = Reap[
          Plot[{f[x], g[x]}, {x, -1, 1}]
          , f][[-1, 1]]
        , g][[-1, 1]];


    ListPlot[{
      {#, f[#]} & /@ fp,
      {#, g[#]} & /@ gp}]

![normal eval](http://simonschmidt.github.io/TimeConstrainedPlot/images/normal-eval.png)

As `TimeConstrainedPlot` will evaluate `{x, {f[x], g[x]}` there will be redundant evaluations:

    TimeConstrainedPlot[Plot[{f[x], g[x]}, {x, -1, 1}], Infinity, Joined -> False]

![evalmon](http://simonschmidt.github.io/TimeConstrainedPlot/images/evalmon-eval.png)
