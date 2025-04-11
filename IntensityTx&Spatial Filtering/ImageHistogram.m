% Kelompok 8
% Muhammad Daffa Rizkyandri (2206829194)
% Surya Dharmasaputra Soeroso (2206827825)
% Valentino Farish Adrian (2206825896)

clear;
close all;

% Memasukkan gambar ke MATLAB
image = imread('image.jpg');

% Melakukan histogram equalization ke gambar
imageEqualization = histeq(image);

% Membuat figur untuk gambar dan grafik histogram dari kedua gambar
figure;
subplot(2,2,1), imshow(image), title('Gambar Asli');
subplot(2,2,2), imshow(imageEqualization), title('Gambar Hasil Equalization');
subplot(2,2,3), imhist(image), title('Grafik Histogram Gambar Asli');
subplot(2,2,4), imhist(imageEqualization), title('Grafik Histogram Gambar Hasil Equalization');