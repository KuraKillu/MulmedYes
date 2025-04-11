clc; clear; close all;

%% STEP 1: Load Gambar Asli
filename = 'test.png';
if ~exist(filename, 'file')
    error('File "test.png" tidak ditemukan.');
end
img = imread(filename);
img = im2double(img);
img = imresize(img, [256 256]);
original = img;
original_gray = rgb2gray(original);
original_file_size = numel(im2uint8(original));

%% STEP 2: JPEG
jpeg_out = 'compressed_jpeg.jpg';
imwrite(im2uint8(original), jpeg_out, 'jpg', 'Quality', 75);
img_jpeg = im2double(imread(jpeg_out));
img_jpeg = imresize(img_jpeg, [256 256]);
gray_jpeg = rgb2gray(img_jpeg);
psnr_jpeg = psnr(gray_jpeg, original_gray);
mse_jpeg  = immse(gray_jpeg, original_gray);
ssim_jpeg = ssim(gray_jpeg, original_gray);
size_jpeg = dir(jpeg_out).bytes;
cr_jpeg   = original_file_size / size_jpeg;

%% STEP 3: JPEG 2000 (lossy)
jp2_out = 'compressed_jp2.jp2';
imwrite(im2uint8(original), jp2_out, 'jp2', 'Mode', 'lossy', 'CompressionRatio', 20);
img_jp2 = im2double(imread(jp2_out));
img_jp2 = imresize(img_jp2, [256 256]);
gray_jp2 = rgb2gray(img_jp2);
psnr_jp2 = psnr(gray_jp2, original_gray);
mse_jp2  = immse(gray_jp2, original_gray);
ssim_jp2 = ssim(gray_jp2, original_gray);
size_jp2 = dir(jp2_out).bytes;
cr_jp2   = original_file_size / size_jp2;

%% STEP 4: JPEG XL (Simulasi)
jxl_out = 'compressed_jxl.png';

% Trik simulasi lossy: resize kecil lalu besar lagi
resized_small = imresize(original, 0.5);  % perkecil → hilang detail
img_jxl = imresize(resized_small, [256 256]);  % perbesar kembali

imwrite(im2uint8(img_jxl), jxl_out, 'png');  % simpan hasil simulasi

gray_jxl = rgb2gray(img_jxl);
psnr_jxl = psnr(gray_jxl, original_gray);
mse_jxl  = immse(gray_jxl, original_gray);
ssim_jxl = ssim(gray_jxl, original_gray);
size_jxl = dir(jxl_out).bytes;
cr_jxl   = original_file_size / size_jxl;

%% STEP 5: WHT RGB
fwht2 = @(x) fwht(fwht(x')') / sqrt(size(x,1));
ifwht2 = @(x) ifwht(ifwht(x')') * sqrt(size(x,1));
trunc = 256;
img_wht_rgb = zeros(size(original));
for c = 1:3
    ch = original(:,:,c);
    T = fwht2(ch);
    flat = abs(T(:));
    [~, idx] = sort(flat, 'descend');
    mask = zeros(size(T));
    mask(idx(1:trunc)) = 1;
    ch_rec = mat2gray(ifwht2(T .* mask));
    img_wht_rgb(:,:,c) = ch_rec;
end
wht_out = 'compressed_wht.png';
imwrite(img_wht_rgb, wht_out);
gray_wht = rgb2gray(img_wht_rgb);
psnr_wht = psnr(gray_wht, original_gray);
mse_wht  = immse(gray_wht, original_gray);
ssim_wht = ssim(gray_wht, original_gray);
size_wht = dir(wht_out).bytes;
cr_wht   = original_file_size / size_wht;

%% STEP 6: Tampilkan FIGURE
figure('Name','Perbandingan Kompresi Gambar test.png');

subplot(2,3,1);
imshow(original);
title({'Original', ...
       'PSNR = ∞ | MSE = 0 | SSIM = 1', ...
       sprintf('Size = %.1f KB', original_file_size/1024)});

subplot(2,3,2);
imshow(img_jpeg);
title({'JPEG', ...
       sprintf('PSNR = %.2f dB | MSE = %.4f | SSIM = %.4f', psnr_jpeg, mse_jpeg, ssim_jpeg), ...
       sprintf('Size = %.1f KB | CR = %.2f×', size_jpeg/1024, cr_jpeg)});

subplot(2,3,3);
imshow(img_jp2);
title({'JPEG 2000 (lossy)', ...
       sprintf('PSNR = %.2f dB | MSE = %.4f | SSIM = %.4f', psnr_jp2, mse_jp2, ssim_jp2), ...
       sprintf('Size = %.1f KB | CR = %.2f×', size_jp2/1024, cr_jp2)});

subplot(2,3,4);
imshow(img_jxl);
title({'JPEG XL (simulasi)', ...
       sprintf('PSNR = %.2f dB | MSE = %.4f | SSIM = %.4f', psnr_jxl, mse_jxl, ssim_jxl), ...
       sprintf('Size = %.1f KB | CR = %.2f×', size_jxl/1024, cr_jxl)});

subplot(2,3,5);
imshow(img_wht_rgb);
title({'WHT RGB', ...
       sprintf('PSNR = %.2f dB | MSE = %.4f | SSIM = %.4f', psnr_wht, mse_wht, ssim_wht), ...
       sprintf('Size = %.1f KB | CR = %.2f×', size_wht/1024, cr_wht)});
