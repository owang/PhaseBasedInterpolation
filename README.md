## PhaseBasedInterpolation
>By [Oliver Wang ](http://www.oliverwang.info)  
oliver.wang2@gmail.com

This is a *personal* reimplementation based on the publication *Phase-Based Frame Interpolation for Video* [Meyer et al. 2015]. 

All code provide here is to be used for **research purposes only**. For questions regarding commercial use, including licensing rights and IP, you must contact the owner; The Walt Disney Company.

This implementation is Matlab, and is designed for clarity over speed. As such, it is highly *un*-optimized. For realistic timing information and more details on how the method works,  please refer to the original paper:
[https://www.disneyresearch.com/publication/phasebased/](https://www.disneyresearch.com/publication/phasebased/)

Note: If you use this software, you *must* cite the following work: 

    S. Meyer, O. Wang, H. Zimmer, M. Grosse and A. Sorkine-Hornung
    Phase-based frame interpolation for video
    2015 IEEE Conference on Computer Vision and Pattern Recognition (CVPR)

This implementation also includes some lightly-modified libraries from Eero Simoncelli's wonderful MatlabPyrTools. For more information on these tools, and the restrictions of use, refer to the [webpage](https://github.com/LabForComputationalVision/matlabPyrTools).

The sample images in ./data/ are from the [Middlebury Optical Flow](http://vision.middlebury.edu/flow/) dataset. If you use these in publication, refer to their webpage for restrictions.

Run demo.m to get started