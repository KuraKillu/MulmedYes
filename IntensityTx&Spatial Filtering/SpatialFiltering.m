% Kelompok 8
% Muhammad Daffa Rizkyandri (2206829194)
% Surya Dharmasaputra Soeroso (2206827825)
% Valentino Farish Adrian (2206825896)

clear;
close all;

% Memasukkan gambar ke MATLAB
image = imread('image.jpg');

% Parameter untuk filter
filterSize = [15 15]; % Ukuran array dari filter Mean
spatialSharpness = 1; % Konstanta penajaman Laplacian

% Membuat filter mean dan laplace
filterMean = fspecial('average', filterSize);
filterLaplace = fspecial('laplacian', spatialSharpness);

% Inisialisasi array untuk menyimpan hasil filter
% Digunakan tipe data uint8 dikarenakan gambar hanya dapat menyimpan dari 0
% sampai 255 perpixelnya. Pada laplacian digunakan int16 dikarenakan dari
% perhitungan laplacian dapat dihasilkannya nilai minus.
filteredMean = zeros(size(image), 'uint8'); 
filteredLaplacian = zeros(size(image), 'int16');

% Menerapkan filter ke masing-masing channel RGB
% 1 = Red, 2 = Green, 3 = Blue
for c = 1:3
    filteredMean(:,:,c) = imfilter(image(:,:,c), filterMean);
    
    % Terapkan Laplacian dan gabungkan dengan gambar asli
    laplacianTemp = imfilter(image(:,:,c), filterLaplace);
    filteredLaplacian(:,:,c) = imsubtract(image(:,:,c), laplacianTemp);
end

% Mengubah tipe data hasil laplacian menjadi uint8 kembali
filteredLaplacian = uint8(filteredLaplacian);

% Menampilkan gambar
figure, imshow(image), title('Gambar Asli'); 
figure, imshow(filteredMean), title('Mean Filter (Blur)');
figure, imshow(filteredLaplacian), title('Laplacian Filter (Sharpened)');