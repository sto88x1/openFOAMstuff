#!/bin/bash
### RUN OPENFOAM ###
. /usr/lib/openfoam/openfoam2212/etc/bashrc

cp -r 0.orig 0
cd surfaceMeshes
surfaceAdd inlet.stl wall.stl geometry.stl
surfaceAdd outlet.stl geometry.stl geometry.stl
#surfacePointMerge geometry.stl 0.001 geometry.stl
#surfaceTransformPoints -write-scale 0.001 geometry.stl geometry.stl
surfaceFeatureEdges -angle 45 geometry.stl geometry.fms
cd ..
cartesianMesh | tee log.cartesianMesh
checkMesh | tee log.checkMesh

. /usr/lib/openfoam/openfoam2412/etc/bashrc
decomposePar
mpirun -np 6 simpleFoam -parallel | tee log.simpleFoam
reconstructParMesh
reconstructPar
rm -r proc*
