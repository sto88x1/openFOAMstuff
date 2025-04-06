#!/bin/sh

#### Preparing ROOM
cp ./STL/box.stl ./room/surfaceMeshes/
cp ./STL/AMI.stl ./room/surfaceMeshes/

cd room/surfaceMeshes/
surfaceTransformPoints -write-scale 0.001 box.stl box.stl
surfaceTransformPoints -write-scale 0.001 AMI.stl AMI.stl
surfaceAdd box.stl AMI.stl geometry.stl
surfacePointMerge geometry.stl 1e-6 geometry.stl
surfaceFeatureEdges -angle 45 geometry.stl geometry.fms
cd ..

cartesianMesh | tee log.cartesianMesh
topoSet | tee log.topoSet
checkMesh | tee log.checkMesh

cd ..
#### Preparing SPHERE
cp ./STL/wall.stl ./sphere/surfaceMeshes/
cp ./STL/AMI.stl ./sphere/surfaceMeshes/

cd sphere/surfaceMeshes/
surfaceTransformPoints -write-scale 0.001 wall.stl wall.stl
surfaceTransformPoints -write-scale 0.001 AMI.stl AMI.stl
surfaceAdd wall.stl AMI.stl geometry.stl
surfacePointMerge geometry.stl 1e-6 geometry.stl
surfaceFeatureEdges -angle 45 geometry.stl geometry.fms
cd ..

cartesianMesh | tee log.cartesianMesh
topoSet | tee log.topoSet
checkMesh | tee log.checkMesh

cd ..
mergeMeshes -overwrite room sphere

cd room
createPatch -overwrite
# splitMeshRegions -overwrite -cellZones
# rm -r constant/polyMesh
cp -r 0.orig 0
decomposePar
mpirun -np 6 pimpleFoam -parallel | tee log.pimpleFoam
reconstructPar
rm -r proc*