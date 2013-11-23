TimeConstrainedPlot
===================

Mathematica package to constrain plot evaluation time.

### Installation
Download [TimeConstrainedPlot.m](https://github.com/simonschmidt/TimeConstrainedPlot/raw/master/TimeConstrainedPlot.m) and put it in the directory given by `FileNameJoin[{$UserBaseDirectory, "Applications"}]`


### Examples

Plot a slow function:

    <<<TimeConstrainedPlot`

    slowSin[x_] := (Pause[RandomReal[0.01]]; Sin[x])

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

- - - 

Preserves sample refinement on a per-function basis:

    TimeConstrainedPlot[
    Plot[{Abs[x], Abs[x - 1/2]}, {x, -1, 1}]
    , 1, Joined -> False]

![sampling](http://simonschmidt.github.io/TimeConstrainedPlot/images/normal-eval.png)

### Possible Issues

There might not be enough time to cover the entire plot range:

    TimeConstrainedPlot[Plot[slowSin[x], {x, 0, 10}], 1]

![range issue](http://simonschmidt.github.io/TimeConstrainedPlot/images/range-issue.png)


With lower `PlotPoints` there is enough time to cover the range and the adaptive algorithm can start refining:

    TimeConstrainedPlot[Plot[slowSin[x], {x, 0, 10}, PlotPoints -> 5], 1]

![workaround](http://simonschmidt.github.io/TimeConstrainedPlot/images/range-issue-fix.png)

