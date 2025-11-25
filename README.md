# image-tamper-recovery
Semi-fragile watermark for color image tamper detection and recovery. Robust after JPEG and normal processing, fragile when content is tampered.

Processed image will carry a nearly invisible digital watermark, which can survive after mild JPEG compression and some filters. But when the content is tampered, the watermark can be used to dectect the tampered area, and recover the original image.

Code in Matlab.

This algorithm was patented CN200810097478.5, and the patent was already expired. So I decided to make everything public. MIT licence. Donation is appreciated.


# The main idea

The watermark is composed of two parts: recovery watermark and positioning watermark.

The recovery watermark is the compression of grayscale version of original image based on DWT and SPIHT encoding technology, and the bit rate is about 0.3 bits per pixel. The recovery watermark is pseudo-randomly scrambled by Logistic chaos sequence, and is embedded into the DCT coefficient matrices of chrominance components.

The positioning watermark contains several checksum bits which are respectively related to luminance and chrominance components, and is embedded into the DCT coefficient matrices of luminance components.

To address data overflow and cut off problem, two methods can be used: affine transform and multiple embedding, each has its strong point.

The positioning result is retouched with mathematical morphologic algorithm in order to enhance positioning precision.

# How to use
Use the following two functions in Matlab, imauth for embedding the watermark, imdeauth for tamper dectetion and recovery:


**imauth(carry, blksize, q, pswd, outfn, mode, maxtime)**

For example:

imauth ('sat.bmp',32,16,123456,'sat_auth.bmp','xd',3);

  bigger q offers better robustness against JPEG compession and filters, but makes the watermark more visible.

  blksize=32, mode='xd' and maxtime=3 is recommended, though 'x' may be slower.


**imdeauth(carry, blksize, q, pswd, outfn, mode)**


For example:

imdeauth('sat_auth.bmp',32,16,123456,'sat_ex.bmp','d')

# Acknowledgements
Thanks to scuteejtian for the SPHIT algorithm.

Thanks to Pascal Getreuer for the wavelet transformation algorithm.
